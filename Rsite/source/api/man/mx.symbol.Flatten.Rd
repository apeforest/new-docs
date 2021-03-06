% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mxnet_generated.R
\name{mx.symbol.flatten}
\alias{mx.symbol.flatten}
\title{flatten:Flattens the input array into a 2-D array by collapsing the higher dimensions.}
\usage{
mx.symbol.flatten(...)
}
\arguments{
\item{data}{NDArray-or-Symbol
Input array.}

\item{name}{string, optional
Name of the resulting symbol.}
}
\value{
out The result mx.symbol
}
\description{
.. note:: `Flatten` is deprecated. Use `flatten` instead.
}
\details{
For an input array with shape ``(d1, d2, ..., dk)``, `flatten` operation reshapes
the input array into an output array of shape ``(d1, d2*...*dk)``.

Note that the bahavior of this function is different from numpy.ndarray.flatten,
which behaves similar to mxnet.ndarray.reshape((-1,)).

Example::

x = [[
        [1,2,3],
        [4,5,6],
        [7,8,9]
    ],
    [    [1,2,3],
        [4,5,6],
        [7,8,9]
    ]],

flatten(x) = [[ 1.,  2.,  3.,  4.,  5.,  6.,  7.,  8.,  9.],
       [ 1.,  2.,  3.,  4.,  5.,  6.,  7.,  8.,  9.]]



Defined in src/operator/tensor/matrix_op.cc:L259
}

