\name{munge}
\alias{munge}
\title{General-purpose data munging}
\usage{
munge(dataframe, ...)
}
\arguments{
  \item{dataframe}{a data set to operate on.}

  \item{...}{usually a list specifying the necessary
  operations (see examples).}
}
\value{
data.frame that has had the specified operations applied to
it, along with an additional property \code{mungepieces}
that records the history of applied functions. These can be
used to reproduce the transformations on e.g., a dataset
that needs to have a prediction run.
}
\description{
One can use \code{munge} to take a \code{data.frame}, apply
a given set of transformations, and persistently store the
operations on the \code{data.frame}, ready to run on a
future \code{data.frame}.
}
\examples{
iris2 <- munge(iris,
  list(column_transformation(function(x) 2 * x), 'Sepal.Length'))
stopifnot(iris2[['Sepal.Length']] == iris[['Sepal.Length']] * 2)

iris2 <- munge(iris,
   # train function & predict function
   list(c(column_transformation(function(x) 2 * x),
        column_transformation(function(x) 3 * x)),
   # arguments to pass to transformation, i.e. column names in this case
   'Sepal.Length'))
stopifnot(iris2[['Sepal.Length']] == iris[['Sepal.Length']] * 2)
iris3 <- munge(iris, attr(iris2, 'mungepieces'))
# used transformations ("mungepieces") stored on iris2 and apply to iris3.
# They will remember that they've been trained already and run the
# prediction routine instead of the training routine. Note the above is
# also equivalent to the shortcut: munge(iris, iris2)
stopifnot(iris3[['Sepal.Length']] == iris[['Sepal.Length']] * 3)
}

