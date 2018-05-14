Machine Learning
================

More specifically, deep learning using Tensorflow.

Supervised machine learning
---------------------------

ML systems learn how to combine input to produce useful predictions on never-before-seen data.

* Label: the thing you want to predict (the ouput, or `y`)
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
    * The derivative points us which we we need to move on our loss curve.
    * With each step, we move closer to the minimum (bottom of curve).
    * This process is called __gradient descent__.

