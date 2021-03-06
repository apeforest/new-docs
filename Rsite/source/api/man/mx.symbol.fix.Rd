% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mxnet_generated.R
\name{mx.symbol.fix}
\alias{mx.symbol.fix}
\title{fix:Returns element-wise rounded value to the nearest \
integer towards zero of the input.}
\usage{
mx.symbol.fix(...)
}
\arguments{
\item{data}{NDArray-or-Symbol
The input array.}

\item{name}{string, optional
Name of the resulting symbol.}
}
\value{
out The result mx.symbol
}
\description{
Example::
}
\details{
fix([-2.1, -1.9, 1.9, 2.1]) = [-2., -1.,  1., 2.]

The storage type of ``fix`` output depends upon the input storage type:

- fix(default) = default
   - fix(row_sparse) = row_sparse
   - fix(csr) = csr



Defined in src/operator/tensor/elemwise_unary_op_basic.cc:L795
}

