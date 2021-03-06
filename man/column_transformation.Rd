\name{column_transformation}
\alias{column_transformation}
\title{Pure column transformations.}
\usage{
column_transformation(transformation, mutating = FALSE, named = FALSE)
}
\arguments{
  \item{transformation}{a function. The only argument
  should be the original column.}

  \item{mutating}{a logical. Announces whether the
  transformation passed in attempts to maintain state
  between prediction and training runs using the "inputs"
  global. (see also \code{\link{mungebit}})}

  \item{named}{a logical. Whether or not the transformation
  should be passed an atomic vector, or a list of length 1
  whose single element is given the same name as the column
  currently being processed.}
}
\value{
a function which takes a data.frame and a vector of columns
and applies the transformation.
}
\description{
A mungebit which affects multiple columns identically and
independently can be abstracted into a column
transformation. This function allows one to specify what
happens to an individual column, and the mungebit will be
the resulting column transformation applied to an arbitrary
combination of columns.
}
\examples{
doubler <- column_transformation(function(x) 2*x)
# doubles the Sepal.Length column in the iris dataset
doubler(iris, c('Sepal.Length'))
}
\seealso{
\code{\link{multi_column_transformation}}
}

