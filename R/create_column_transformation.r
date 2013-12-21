#' Old-to-new column mapping transformation
#'
#' A mungebit which does not affect any existing columns, but can transform
#' other columns into 
#' can be abstracted into a column transformation. This function allows one
#' to specify what happens to an individual column, and the mungebit will be
#' the resulting column transformation applied to an arbitrary combination of
#' columns.
#'
#' @param transformation a function. The only argument should be the original
#'    column.
#' @return a function which takes a data.frame and a vector of columns and
#'    applies the transformation.
#' @export
#' @examples
#' doubler <- column_transformation(function(x) 2*x)
#' # doubles the Sepal.Length column in the iris dataset
#' doubler(iris, c('Sepal.Length')) 
create_column_transformation <- function(transformation) {
  function(dataframe, cols, new_col, ...) {
    # The fastest way to do this. The alternatives are provided in the comment below
    assign("*tmp.fn.left.by.mungebits.library*",
           transformation, envir = parent.frame())
    cols <- 
      if (is.character(cols)) force(cols)
      else colnames(dataframe)[cols]

    invisible(eval(substitute({
      # Trick to make assignment incredibly fast. Could screw up the
      # data.frame if the function is interrupted, however.
      class(dataframe) <- 'list'
      on.exit(class(dataframe) <- 'data.frame')
      dataframe[[new_col]] <-
        `*tmp.fn.left.by.mungebits.library*`(dataframe[cols], ...)
      class(dataframe) <- 'data.frame'
      dataframe
    }), envir = parent.frame()))
  }
}

# Possible column transformations:
# 1: function(dataframe, col) { dataframe[col] <- 2*dataframe[col]; dataframe }
# 2: function(dataframe, col) { eval(substitute(dataframe[col] <- 2*dataframe[col]), envir = parent.frame()) }
# 3: function(dataframe, col) { class(dataframe) <- 'list'; for(colname in col) dataframe[[colname]] <- 2*dataframe[[colname]]; class(dataframe) <- 'data.frame'; dataframe }
# 4: function(dataframe, col) { eval(substitute({ class(dataframe) <- 'list'; for(colname in col) dataframe[[col]] <- 2*dataframe[[col]]; class(dataframe) <- 'data.frame'; dataframe }), envir = parent.frame()) }
# 5: The method above for dynamic lambdas
# An extra rm function after the assign increases runtime by 75% with frequent application.
# The fifth option is the fastest.

