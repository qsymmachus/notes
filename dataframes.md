# Dataframes

These notes capture an overview of how you can use some key technologies for more performant analytic queries in applications, using a few key technologies:

- [Apache Arrow](https://arrow.apache.org/), a columnar, in-memory data format optimized for analytics operations. This format is sometimes called "Arrow".
- [Pola.rs](https://pola.rs/), a library for running analytic queries using Arrow as its underlying in-memory representation. It operates on tabular 2-dimensional data structures with labelled rows and columns called "dataframes".

Taken together, these technologies allow you to convert data from a relational database into a format than can be efficiently queried for analytics use cases.

It's common to just refer to this combination of technologies as "dataframes", but to be precise, we're layering a few different technologies:

```
┌─────────────────────────────────┐
│   Polars DataFrame API          │  ← Query engine with lazy evaluation (uses dataframes)
├─────────────────────────────────┤
│   Arrow Columnar Memory Format  │  ← How data lives in RAM
├─────────────────────────────────┤
│   Arrow IPC / Parquet / CSV ... │  ← Serialization to/from disk or network
└─────────────────────────────────┘
```

Let's walk through a example of how this all works.

## 1. Load raw data as Arrow IPC buffers

Probably the most expensive step in this whole process is getting the data you need _out_ of the database and ready to be used in the Arrow format.

There are a variety of ways to do this, but they way you've seen it done in the past is to preemptively load and cache the data in Arrow IPC (Inter-Process Communication) format. Think of this as the Arrow format but specifically for serialization (storage on disk/cache, sent over the network).

The Arrow IPC data can they be retrieved and used as `Buffer`s in the following steps.

## 2. Assemble Arrow tables into a Polars `LazyDataFrame`

At this point we can now read the pre-computed Arrow buffers into Polars. This generates the actual dataframe (underlying data structure) that future queries will run against:

```typescript
import pl, { type LazyDataFrame } from "nodejs-polars";

let reviewsDataFrame = pl
  .readIPC(Buffer.from(reviewRequests)) // `reviewRequests` is a pre-cached Arrow IPC buffer
  .lazy()
  .join(pl.readIPC(Buffer.from(reviewees)).lazy(), {
    how: "inner",
    on: ["reviewee_id", "review_cycle_id"],
  })
  .join(pl.readIPC(Buffer.from(reviewGroups)).lazy(), {
    how: "inner",
    on: ["review_group_id", "review_cycle_id"],
  })
  .join(pl.readIPC(Buffer.from(reviewCycles)).lazy(), {
    how: "inner",
    on: "review_cycle_id",
  })
  .join(pl.readIPC(Buffer.from(recurringReviewCycleRules)).lazy(), {
    how: "left",
    leftOn: "new_rule_id",
    rightOn: "recurring_rule_id",
  })
  // Remove all rows related to deleted review cycles
  .filter(pl.col("deleted_at").isNull());
```

In this example, the joins mirror the existing relational model resulting in a single wide `LazyDataFrame`.

An advantage of Polars is the use of this `LazyDataFrame` – it allows you build the _underlying dataframe_ needed to run analytic queries, in advance of actually running any queries (whence the "laziness").

## 3. Use the `LazyDataFrame` to run analytic queries

With your `LazyDataFrame` generated, you can now run some analytic queries on demand. Here are some examples:

### Counts

```typescript
const reviewsPerCycle = await reviewsDataFrame
  .groupBy("review_cycle_id")
  .agg(pl.count().alias("review_count"))
  .sort("review_count", true) // descending
  .collect();

console.log(reviewsPerCycle.toRecords());
// [{ review_cycle_id: 42, review_count: 350 }, { review_cycle_id: 17, review_count: 210 }, ...]
```

### Filter and group by

```typescript
const breakdownByGroupType = await reviewsDataFrame
  .filter(pl.col("review_cycle_entity_id").eq(pl.lit(myCycleEntityId)))
  .groupBy("review_group_type")
  .agg(pl.col("reviewee_id").nUnique().alias("unique_reviewees"))
  .collect();

console.log(breakdownByGroupType.toRecords());
// [{ review_group_type: "self", unique_reviewees: 120 }, { review_group_type: "peer", unique_reviewees: 95 }, ...]
```

### Aggregate functions and pagination

```typescript
const avgRatings = await reviewsDataFrame
  .filter(pl.col("rating").isNotNull())
  .groupBy("review_cycle_id")
  .agg(
    pl.mean("rating").alias("avg_rating"),
    pl.col("reviewee_id").nUnique().alias("reviewee_count"),
  )
  .sort("avg_rating", true)
  .collect();

const total = avgRatings.height;
const page = avgRatings.slice(offset, limit);
const rows = page.toRecords() as {
  review_cycle_id: number;
  avg_rating: number;
  reviewee_count: number;
}[];
```
