# Develop a Neural Network with MXNet in Five Minutes

This 5 minute tutorial is designed for new users of the mxnet package for R. It shows how to construct a neural network for classification and regression tasks. The data we use is in the **mlbench** R package. 

First, we need to load the required R packages:

```{.python .input .R  n=1}
if (!require(mlbench)) {
    install.packages('mlbench')
}
require(mxnet)
```

```{.json .output n=1}
[
 {
  "name": "stderr",
  "output_type": "stream",
  "text": "Loading required package: mlbench\nLoading required package: mxnet\n"
 }
]
```

## Classification

We load some data for a simple classification problem with two classes:

```{.python .input .R  n=2}
data(Sonar, package="mlbench")
Sonar[,61] = as.numeric(Sonar[,61])-1  # the target labels
set.seed(0)
train.ind = sample(1:nrow(Sonar), size=ceiling(0.7*nrow(Sonar)))
train.x = data.matrix(Sonar[train.ind, 1:60])
train.y = Sonar[train.ind, 61]
test.x = data.matrix(Sonar[-train.ind, 1:60])
test.y = Sonar[-train.ind, 61]
table(train.y)  # distribution of classes in training data
```

```{.json .output n=2}
[
 {
  "data": {
   "text/plain": "train.y\n 0  1 \n80 66 "
  },
  "metadata": {},
  "output_type": "display_data"
 }
]
```

We are going to use a multi-layer perceptron as our classifier (i.e. what is commonly thought of as the standard feedforward neural network). 
In the **mxnet** package, we have a function called ``mx.mlp`` for building a general multi-layer neural network to do classification or regression.

``mx.mlp`` requires the following parameters:

- Training data and label

- Number of hidden nodes in each hidden layer

- Number of nodes in the output layer

- Type of the activation

- Type of the output loss

- The device to train (GPU or CPU)

- Other extra parameters for ``mx.model.FeedForward.create``

The following code shows an example usage of ``mx.mlp``:

```{.python .input .R  n=4}
mx.set.seed(0)
model <- mx.mlp(train.x, train.y, hidden_node=c(200,100), out_node=2, out_activation="softmax",
                num.round=20, array.batch.size=15, learning.rate=0.1, momentum=0.9,
                eval.metric=mx.metric.accuracy)
```

```{.json .output n=4}
[
 {
  "name": "stderr",
  "output_type": "stream",
  "text": "Warning message in mx.model.select.layout.train(X, y):\n\u201cAuto detect layout of input matrix, use rowmajor..\n\u201dStart training with 1 devices\n[1] Train-accuracy=0.493333351612091\n[2] Train-accuracy=0.546666684746742\n[3] Train-accuracy=0.546666684746742\n[4] Train-accuracy=0.546666684746742\n[5] Train-accuracy=0.546666684746742\n[6] Train-accuracy=0.546666684746742\n[7] Train-accuracy=0.546666684746742\n[8] Train-accuracy=0.546666684746742\n[9] Train-accuracy=0.546666684746742\n[10] Train-accuracy=0.546666684746742\n[11] Train-accuracy=0.546666684746742\n[12] Train-accuracy=0.546666684746742\n[13] Train-accuracy=0.633333346247673\n[14] Train-accuracy=0.666666683554649\n[15] Train-accuracy=0.693333351612091\n[16] Train-accuracy=0.606666684150696\n[17] Train-accuracy=0.766666680574417\n[18] Train-accuracy=0.773333346843719\n[19] Train-accuracy=0.813333344459534\n[20] Train-accuracy=0.800000011920929\n"
 }
]
```

Specifying ``mx.set.seed`` controls all randomness within **mxnet** (as opposed to ``set.seed`` within R), and ensures our results are reproducible.

Above, we have created a three-layer neural network with 200 hidden units in the first layer, 100 hidden units in the second layer, and 2 units in the output layer (one for each possible class in our classification task).
Our network has been trained for 20 epochs (``num.round``) over the provided data via the SGD-with-momentum optimization algorithm using mini-batches of size 15 (``array.batch.size``), a learning rate of 0.1, and a momentum factor of 0.9.
You can see the training accuracy in each epoch as training progresses. 

To summarize what operations are performed by our network and its overall architecture, view the computation graph:

```{.python .input .R  n=5}
graph.viz(model$symbol)
```

```{.json .output n=5}
[
 {
  "data": {
   "text/plain": "HTML widgets cannot be represented in plain text (need html)"
  },
  "metadata": {
   "text/html": {
    "isolated": true
   }
  },
  "output_type": "display_data"
 }
]
```

It is easy to use our trained model to make predictions regarding the probability of each class for our test examples:

```{.python .input  n=9}
preds = predict(model, test.x)
```

```{.json .output n=9}
[
 {
  "name": "stderr",
  "output_type": "stream",
  "text": "Warning message in mx.model.select.layout.predict(X, model):\n\u201cAuto detect layout of input matrix, use rowmajor..\n\u201d"
 }
]
```

Note for that for multi-class predictions, **mxnet** outputs nclass x nexamples, with each row corresponding to the probability of the class.
We can easily evaluate the quality of these predictions:

```{.python .input  n=10}
p = max.col(t(preds))-1
    table(p, test.y)
```

```{.json .output n=10}
[
 {
  "data": {
   "text/plain": "   test.y\np    0  1\n  0 13  3\n  1 18 28"
  },
  "metadata": {},
  "output_type": "display_data"
 }
]
```

## Regression

Next, we load data for a simple regression task:

```{.python .input  n=48}
data(BostonHousing, package="mlbench")
set.seed(0)
train.ind = sample(1:nrow(BostonHousing), size=ceiling(0.7*nrow(BostonHousing)))
train.x = data.matrix(BostonHousing[train.ind, -14])
train.y = BostonHousing[train.ind, 14]
test.x = data.matrix(BostonHousing[-train.ind, -14])
test.y = BostonHousing[-train.ind, 14]
summary(train.y)  # distribution of target values in training data
```

```{.json .output n=48}
[
 {
  "data": {
   "text/plain": "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n   5.00   16.80   21.00   22.37   25.00   50.00 "
  },
  "metadata": {},
  "output_type": "display_data"
 }
]
```

We can simply invoke ``mx.mlp`` again to train a feedforward neural network for regression. We just need to  appropriately change ``out_activation`` and ``eval.metric`` to tell our model to employ the root mean-square error objective, which is more appropriate for predicting continuous values (we also set ``out_node`` = 1 to reflect the fact that model should now only output a single value as its prediction):

```{.python .input  n=69}
mx.set.seed(0)
model <- mx.mlp(train.x, train.y, hidden_node=c(20,10), out_node=1, out_activation="rmse",
                num.round=20, array.batch.size=15, learning.rate=1e-4, momentum=0.9,
                eval.metric=mx.metric.rmse)
```

```{.json .output n=69}
[
 {
  "name": "stderr",
  "output_type": "stream",
  "text": "Warning message in mx.model.select.layout.train(X, y):\n\u201cAuto detect layout of input matrix, use rowmajor..\n\u201dStart training with 1 devices\n[1] Train-rmse=23.9678078492482\n[2] Train-rmse=23.5028984546661\n[3] Train-rmse=22.5812517801921\n[4] Train-rmse=20.3200194438299\n[5] Train-rmse=17.2182632684708\n[6] Train-rmse=14.401038924853\n[7] Train-rmse=12.2674139142036\n[8] Train-rmse=10.8264979521434\n[9] Train-rmse=9.93604691823324\n[10] Train-rmse=9.42248182495435\n[11] Train-rmse=9.14319875836372\n[12] Train-rmse=8.99817247192065\n[13] Train-rmse=8.92577150464058\n[14] Train-rmse=8.89138073722521\n[15] Train-rmse=8.87639011939367\n[16] Train-rmse=8.87099523345629\n[17] Train-rmse=8.87011263767878\n[18] Train-rmse=8.87115873893102\n[19] Train-rmse=8.87282834450404\n[20] Train-rmse=8.8579886953036\n"
 }
]
```

However, this time we are also going to introduce a flexible way to configure neural networks in **mxnet** via the ``Symbol`` system.  The ``Symbol`` system takes care of the links among nodes, activation, dropout ratio, etc. 
We can configure a multi-layer neural network as follows:

```{.python .input  n=71}
# Define the input data
    data <- mx.symbol.Variable("data")
    # A fully connected hidden layer
    # data: input source
    # num_hidden: number of neurons in this hidden layer
    fc1 <- mx.symbol.FullyConnected(data, num_hidden=1)

    # Use linear regression for the output layer
    lro <- mx.symbol.LinearRegressionOutput(fc1)
```

What matters for a regression task is mainly the last function. It enables the new network to optimize for squared loss. Now let’s train on this simple data set. In this configuration, we omitted all hidden layers so that the input layer is directly connected to the output layer (i.e. we are simply using a linear model).

Using ``mx.model.FeedForward.create``, we can instantiate the parameters of the network structure defined above and learn good values for them based on our training dataset:

```{.python .input  n=141}
mx.set.seed(0)
model <- mx.model.FeedForward.create(lro, X=train.x, y=train.y,
                                     ctx=mx.cpu(), num.round=20, array.batch.size=15,
                                     learning.rate=1e-6, momentum=0.9,  eval.metric=mx.metric.rmse)
```

```{.json .output n=141}
[
 {
  "name": "stderr",
  "output_type": "stream",
  "text": "Warning message in mx.model.select.layout.train(X, y):\n\u201cAuto detect layout of input matrix, use rowmajor..\n\u201dStart training with 1 devices\n[1] Train-rmse=14.1140765945117\n[2] Train-rmse=9.52746474742889\n[3] Train-rmse=8.94830052057902\n[4] Train-rmse=8.68864792585373\n[5] Train-rmse=8.61729238430659\n[6] Train-rmse=8.56938248872757\n[7] Train-rmse=8.52548146247864\n[8] Train-rmse=8.48463354508082\n[9] Train-rmse=8.44903008143107\n[10] Train-rmse=8.41727783282598\n[11] Train-rmse=8.38848445812861\n[12] Train-rmse=8.36210161447525\n[13] Train-rmse=8.33772893746694\n[14] Train-rmse=8.31504078706106\n[15] Train-rmse=8.29377285639445\n[16] Train-rmse=8.27371203899384\n[17] Train-rmse=8.25468560059865\n[18] Train-rmse=8.23654981454214\n[19] Train-rmse=8.21918612718582\n[20] Train-rmse=8.20249579350154\n"
 }
]
```

It is again easy to use this learned model to make predictions on new data points and evaluate the quality of these predictions:

```{.python .input  n=147}
preds = predict(model, test.x)
summary(as.vector(preds))
sprintf("test RMSE = %f", sqrt(mean((preds-test.y)^2)))
```

```{.json .output n=147}
[
 {
  "name": "stderr",
  "output_type": "stream",
  "text": "Warning message in mx.model.select.layout.predict(X, model):\n\u201cAuto detect layout of input matrix, use rowmajor..\n\u201d"
 },
 {
  "data": {
   "text/plain": "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n  2.563  23.326  25.028  23.766  25.933  34.460 "
  },
  "metadata": {},
  "output_type": "display_data"
 },
 {
  "data": {
   "text/html": "'test RMSE = 8.226206'",
   "text/latex": "'test RMSE = 8.226206'",
   "text/markdown": "'test RMSE = 8.226206'",
   "text/plain": "[1] \"test RMSE = 8.226206\""
  },
  "metadata": {},
  "output_type": "display_data"
 }
]
```

Currently, **mxnet** has four predefined evaluation metrics: "accuracy", "rmse", "mae", and "rmsle". 
You can also define your own metrics via the provided interface:

```{.python .input  n=148}
demo.metric.mae <- mx.metric.custom("demo_mae", function(label, pred) {
      pred <- mx.nd.reshape(pred, shape = 0)
      res <- mx.nd.mean(mx.nd.abs(label-pred))
      return(as.array(res))
    })
```

As an example, we have defined the mean absolute error metric ourselves above. Now, we can simply plug it into the training function:

```{.python .input  n=149}
mx.set.seed(0)
model <- mx.model.FeedForward.create(lro, X=train.x, y=train.y,
                                     ctx=mx.cpu(), num.round=20, array.batch.size=15,
                                     learning.rate=1e-6, momentum=0.9, eval.metric=demo.metric.mae)
```

```{.json .output n=149}
[
 {
  "name": "stderr",
  "output_type": "stream",
  "text": "Warning message in mx.model.select.layout.train(X, y):\n\u201cAuto detect layout of input matrix, use rowmajor..\n\u201dStart training with 1 devices\n[1] Train-demo_mae=11.820208966732\n[2] Train-demo_mae=7.56104199091593\n[3] Train-demo_mae=6.81287555893262\n[4] Train-demo_mae=6.60872280597687\n[5] Train-demo_mae=6.55220044652621\n[6] Train-demo_mae=6.51340645551682\n[7] Train-demo_mae=6.47485866149267\n[8] Train-demo_mae=6.44060067335765\n[9] Train-demo_mae=6.41434012850126\n[10] Train-demo_mae=6.39076174298922\n[11] Train-demo_mae=6.36941055456797\n[12] Train-demo_mae=6.35087002317111\n[13] Train-demo_mae=6.33650963505109\n[14] Train-demo_mae=6.32416961590449\n[15] Train-demo_mae=6.3127772907416\n[16] Train-demo_mae=6.30181616544724\n[17] Train-demo_mae=6.2910447716713\n[18] Train-demo_mae=6.2804245253404\n[19] Train-demo_mae=6.27007535099983\n[20] Train-demo_mae=6.26013531287511\n"
 }
]
```

```{.python .input  n=150}
preds = predict(model, test.x)
sprintf("test MAE = %f", mean(abs(preds-test.y)))
```

```{.json .output n=150}
[
 {
  "name": "stderr",
  "output_type": "stream",
  "text": "Warning message in mx.model.select.layout.predict(X, model):\n\u201cAuto detect layout of input matrix, use rowmajor..\n\u201d"
 },
 {
  "data": {
   "text/html": "'test MAE = 6.539299'",
   "text/latex": "'test MAE = 6.539299'",
   "text/markdown": "'test MAE = 6.539299'",
   "text/plain": "[1] \"test MAE = 6.539299\""
  },
  "metadata": {},
  "output_type": "display_data"
 }
]
```

Congratulations! You’ve learned the basics for using MXNet to train neural networks in R. To learn how to use MXNet’s more advanced features, see the other tutorials provided on this website.