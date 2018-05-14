Machine Learning
================

More specifically, deep learning using Tensorflow.

Supervised machine learning
---------------------------

ML systems learn how to combine input to produce useful predictions on never-before-seen data.

* Label: the thing you want to predict (the output, or `y`)
* Features: the input variables describing our data (the input, or `x`)

* Example: an instance of input data `x`
* Labeled example: input paired with a _known_ output `(x, y`)
* Unlabeled example: input with _unknown_ output `(x, ?)`

A simple example of this is _linear regression_. Given a set of points (labeled examples), find a line that fits the data. 

This line allows you to predict output for a given input.

Loss
----

* Loss: The difference between the predicted `y'` and the actual `y`
  * A common way to calculate loss for regression: __L2 Loss__
    * Square of the difference between prediction and label.
    * `(y - y')^2`
    * Graphed, loss function is a parabola. Minimum loss is at the bottom!
      * i.e. our goal is the _minimum_ of the loss curve.

When training our ML system, our goal is to reduce loss.
  * Feed features into model, it spits out predicted outputs.
  * Compare our output with labeled examples and calculate loss.
  * Based on that loss, adjust parameters and iterate again.
    * The derivative points us which we we need to move on our loss curve (gradient).
    * With each step, we move closer to the minimum (bottom of curve).
    * This process is called __gradient descent__.

__Step size__ is the size of the steps you take along your loss curve to zero in on the minimum.
  * If your rate is too small, it takes to long to find the minimum.
  * If your rate is too big, you overshoot on either side of the minimum.
  * An ideal rate gets you to the minimum in the smallest number of steps.

__Learning rate__ is the parameter than controls step size.
  * Scalar multiplier on the gradient vector.

How do you perform these loss checks on big sets of examples?
  * Stochastic Gradient Descent (SGD): one example at a time.
  * Mini-Batch Gradient Descent: batchs of examples, average the loss and gradient.

Tensorflow
----------

At bottom, a library for performing calculations over tensors. Tensors are collections of points (usually floating point numbers) with a size and shape:
  * Scalar: single point ("0-dimension")
  * Vector: 1-dimension set of points
  * Matrix: 2-dimension set of points
  * Tensor: generally, an n-dimension set of points.

Layered on top of this tensor API are some higher-level APIs for supervised machine learning.
  * e.g. [Estimators API](https://www.tensorflow.org/programmers_guide/estimators)

Exercises to try:
  * [First steps with Tensorflow](https://colab.research.google.com/notebooks/mlcc/first_steps_with_tensor_flow.ipynb)

Generalization
--------------

__Generalization__ is the ability of your model to make accurate predictions with never before seen data – that is, data you have not trained on.

If your training dataset is not representative of other  datasets, your model may not generalizae well.
  * This is called "overfitting".

Generally speaking, the _less complicated_ the model, the _more generalizable_ the model.

When developing a model, it's a good idea to have both
  * A __training__ dataset to build the model
  * A __test__ dataset to determine how generalizable it is.

When gathering training and test data from a distribution:

  1. Draw examples independently and identically (iid) at random
  2. The distribution is stationary (doesn't change over time)
  3. Pull all examples from the same distribution!

__NB:__ Debugging in ML is often _data debugging_ rather than code debugging.

Creating features ("representation")
------------------------------------

Recall that  __features__ are the input variables describing our data (the input, or `x`).

How do we turn our data into features? We need to turn them into tensors.
  * Numbers: no real conversion is necessary. Just put them in a tensor.
  * Strings: this is obviously trickier!
    * Enumerate: enumerate all possible values of the string.
    * One-hot encoding: if we only care about one string value, convert that to `1`, and all other values to `0`.

Enumeration as a means to represent string data is only really useful if you have a reasonably sized set of enums (for example, 50 state postal codes).

If each enum is nearly unique, then you're not modeling much at all! It's not generalizable.

Bucketing or "binning" is another useful tool. Create buckets for your data (for example, for a set of geolocation data, bucket it by state).jA

