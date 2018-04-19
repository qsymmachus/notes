APACHE BEAM
===========

Apache Beam is a framework for defining both batch and streaming data-processing pipelines.

You can think of Beam as an additional layer of abstraction on top of an underlying "distributed processing back-end":

* Apache Apex
* Apache Flink
* Apache Spark
* Google Cloud Dataflow

Creating the pipeline
---------------------

### `PipelineOptions`

`PipelineOptions` defines the options for your Beam pipeline. Common options include:

* The pipeline runner that will execute this pipeline (more on runners later)
* If you're using Google Dataflow, the project to run the pipeline in
* The pipeline input and output destinations (either files, tables, or GCS buckets)

`PipelineOptions` may be hard-coded into your pipeline code, or more often, passed as CLI arguments.

```
PipelineOptions options = PipelineOptionsFactory.create();
```

### `Pipeline`

The next step is to create a `Pipeline` object with the options we've just constructed.

The `Pipeline` creates a graph of transformations to be executed.

```
Pipeline p = Pipeline.create(options)
```

Applying pipeline transformations
---------------------------------

A pipeline takes some input, applies one or more transformations, and writes the results to some output.'

In this doc, we'll walk through an example pipeline that generates word counts from the works of Shakespeare.

### 1. `PCollection`

This is the "stuff" of your transformation. The input and output data are usually represented as  `PCollection`s.

`PCollection` are abstract enough to represent almost any dataset, including unbounded datasets.

### 2. Reading from a file

Our first step in our example pipeline is to read the works of Shakespeare from a file.

Yep, this returns a `PCollection`:

```java
p.apply(TextIO.read().from("gs://apache-beam-samples/shakespeare/*")) 
```

### 3. Split into lines

In this step, we split the text into lines, where each element is a individual word.

In other words, we're taking a `PCollection` of lines, and turning it into a `PCollection` of words via a `FlatMapElements` transform:

```java
.apply("ExtractWords", FlatMapElements
  .into(TypeDescriptors.strings())
  .via((String word) -> Arrays.asList(word.split("[^\\p{L}]+"))))
```

### 4. Counting the words

The Beam SKD provides a `Count` transform, which takes a `PCollection` of any type, and returns a `PCollection` of key-value pairs.

Each key is a unique element in the original `PCollection` (in this example, a word), and each value is the number of times that element occurs in the collection.

```java
.apply(Count.<String>perElement())
```

### 5. Filtering out empty words

We can filter out empty words using the `Filter` transform:

```java
.apply(Filter.by((String word) -> !word.isEmpty())
```

### 6. Transforming the counts

The next transform simple formats our key-value pairs into something human-readable, `Word: count`.

This is a simple `MapElements` transform:

```java
.apply("FormatResults", MapElements
  .into(TypeDescriptors.strings())
  .via((KV<String, Long> wordCount) -> wordCount.getKey() + ": " + wordCount.getValue()))
```

### 7. Output to a file

Our final transformation is to write our output to a file:

```java
.apply(TextIO.write().to("wordcounts"));
```

Running the pipeline
--------------------

In the previous section, we defined a word count pipeline that looks like this:

```java
p.apply(TextIO.read().from("gs://apache-beam-samples/shakespeare/*"))
  .apply(FlatMapElements
    .into(TypeDescriptors.strings())
    .via((String word) -> Arrays.asList(word.split("[^\\p{L}]+"))))
  .apply(Filter.by((String word) -> !word.isEmpty()))
  .apply(Count.perElement())
  .apply(MapElements
    .into(TypeDescriptors.strings())
    .via((KV<String, Long> wordCount) -> wordCount.getKey() + ": " + wordCount.getValue()))
  .apply(TextIO.write().to("wordcounts"));
```

We can run it with this simple command:

```java
p.run().waitUntilFinish();
```

ParDo and DoFn
--------------

`ParDo` is the fundamental unit of transformation in Beam. A `ParDo` invokes a user-specified function on each element of a `PCollection`.

The function invoked by a `ParDo` is called a `DoFn` (these names are awful). These can be defined anonymously inline, as in our early example. Alternatively, you can define your own `DoFn`s.

Here's a custom `DoFn` that encapsulates our word extraction logic. Given a `PCollection` of lines, it transforms it into a `PCollection` of individual words:

```java
static class ExtractWordsFn extends DoFn<String, String> {
  @ProcessElement
  public void processElement(ProcessContext c) {
    // Split the line into words.
    String[] words = c.element().split(ExampleUtils.TOKENIZER_PATTERN);

    // Output each word encountered into the output PCollection.
    for (String word : words) {
      if (!word.isEmpty()) {
        c.output(word);
      }
    }
  }
}
```

You can then use your custom `DoFn` on a pipeline transform. See the example in "Extending PTransform" below.


Extending PTransform
--------------------

In the previous sections, we saw a series of transformations – `FlatMapElements`, `Count`, `Filter`, etc. These are all subtypes of the `PTransform` type.

You can create your own extensions of `PTransform` to encapsulate custom transformations. These extensions are also easier to unit test.

Here's an extension of `PTransform` that encapsulates part of our word count pipeline:

```java
public static class CountWords extends PTransform<PCollection<String>,
    PCollection<KV<String, Long>>> {
  @Override
  public PCollection<KV<String, Long>> expand(PCollection<String> lines) {

    // Convert lines of text into individual words.
    PCollection<String> words = lines.apply(
        ParDo.of(new ExtractWordsFn())); // Here, we're using our custom `DoFn` from above.

    // Count the number of times each word occurs.
    PCollection<KV<String, Long>> wordCounts =
        words.apply(Count.<String>perElement());

    return wordCounts;
  }
}
```

You can then use your custom `PTransform` like this:

```java
Pipeline p = ...

p.apply(...)
 .apply(new CountWords())
```

Customizing PipelineOptions
---------------------------

In the "Create the pipeline" section above, we briefly covered how to instantiate `PipelineOptions`. In our first example,
our pipeline options were hardcoded. However, it is more common to parse out options from the command line.

You can create custom command line options by extending `PipelineOptions`:

```java
public interface WordCountOptions extends PipelineOptions {

  /**
   * By default, this example reads from a public dataset containing the text of
   * King Lear. Set this option to choose a different input file or glob.
   */
  @Description("Path of the file to read from")
  @Default.String("gs://apache-beam-samples/shakespeare/kinglear.txt")
  String getInputFile();
  void setInputFile(String value);

  /**
   * Set this required option to specify where to write the output.
   */
  @Description("Path of the file to write to")
  @Required
  String getOutput();
  void setOutput(String value);
}
```

Once you have these custom options, you can instantiate them like this:

```java
WordCountOptions options = PipelineOptionsFactory.fromArgs(args).withValidation().as(WordCountOptions.class);
```

You can retrieve and use options with `options.getSomeOption`:

```java
p.apply("ReadLines", TextIO.read().from(options.getInputFile()))
```

Then from the command lines, custom options are passed in as flags:

```sh
mvn compile exec:java -Dexec.mainClass=org.apache.beam.examples.WordCount \
     -Dexec.args="--inputFile=pom.xml --output=counts" -Pdirect-runner
```

PAssert and testing
-------------------

`PAssert` allows you to perform simple assertions on the state of a `PCollection. Here's an example unit test on our word count pipeline that uses `PAssert`:

```java
public class WordCountTest {

  static final String[] WORDS_ARRAY = new String[] {
    "hi there", "hi", "hi sue bob",
    "hi sue", "", "bob hi"};

  static final List<String> WORDS = Arrays.asList(WORDS_ARRAY);

  static final String[] COUNTS_ARRAY = new String[] {
      "hi: 5", "there: 1", "sue: 2", "bob: 2"};

  @Rule
  public TestPipeline p = TestPipeline.create();

  /** Example test that tests a PTransform by using an in-memory input and inspecting the output. */
  @Test
  @Category(ValidatesRunner.class)
  public void testCountWords() throws Exception {
    PCollection<String> input = p.apply(Create.of(WORDS).withCoder(StringUtf8Coder.of()));

    PCollection<String> output = input.apply(new CountWords())
      .apply(MapElements.via(new FormatAsTextFn()));

    PAssert.that(output).containsInAnyOrder(COUNTS_ARRAY);
    p.run().waitUntilFinish();
  }
}
```

Bounded vs Unbounded 
--------------------

Inputs to a pipeline can either be "bounded" (that is, finite) or "unbounded" (in which case we're dealing with a stream).

If your input is unbounded, all `PCollections` in the pipeline will be unbounded as well.

Windowing
---------

You can treat an unbounded `PCollection` as a bounded `PCollection` by breaking it up into finite `Window`s.

`PTransforms` that aggregate multiple elements process each `Pcollection` as a succession of multiple, finite windows, even though the entire collection may be of infinite size (a stream).

```java
PCollection<String> windowedWords = input
  .apply(Window.<String>into(
    FixedWindows.of(Duration.standardMinutes(options.getWindowSize()))));

PCollection<KV<String, Long>> wordCounts = windowedWords.apply(new WordCount.CountWords());
```

Unbounded Sinks
---------------

When dealing with unbounded inputs, you need to have an unbounded output (or "sink").

When using text files as an output, a common strategy is to partition the files by Window:

```java
wordCounts
  .apply(MapElements.via(new WordCount.FormatAsTextFn()))
  .apply(new WriteOneFilePerWindow(output, options.getNumShards()));
```

