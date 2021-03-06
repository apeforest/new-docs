% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mxnet_generated.R
\name{mx.nd.radians}
\alias{mx.nd.radians}
\title{Converts each element of the input array from degrees to radians.}
\arguments{
\item{data}{NDArray-or-Symbol
The input array.}
}
\value{
out The result mx.ndarray
}
\description{
.. math::
   radians([0, 90, 180, 270, 360]) = [0, \pi/2, \pi, 3\pi/2, 2\pi]
}
\details{
The storage type of ``radians`` output depends upon the input storage type:

- radians(default) = default
   - radians(row_sparse) = row_sparse
   - radians(csr) = csr



Defined in src/operator/tensor/elemwise_unary_op_trig.cc:L182
}

