% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/slide-index.R
\name{slide_index}
\alias{slide_index}
\alias{slide_index_vec}
\alias{slide_index_dbl}
\alias{slide_index_int}
\alias{slide_index_lgl}
\alias{slide_index_chr}
\alias{slide_index_dfr}
\alias{slide_index_dfc}
\title{Slide relative to an index}
\usage{
slide_index(.x, .i, .f, ..., .before = 0L, .after = 0L, .complete = FALSE)

slide_index_vec(
  .x,
  .i,
  .f,
  ...,
  .before = 0L,
  .after = 0L,
  .complete = FALSE,
  .ptype = NULL
)

slide_index_dbl(.x, .i, .f, ..., .before = 0L, .after = 0L, .complete = FALSE)

slide_index_int(.x, .i, .f, ..., .before = 0L, .after = 0L, .complete = FALSE)

slide_index_lgl(.x, .i, .f, ..., .before = 0L, .after = 0L, .complete = FALSE)

slide_index_chr(.x, .i, .f, ..., .before = 0L, .after = 0L, .complete = FALSE)

slide_index_dfr(
  .x,
  .i,
  .f,
  ...,
  .before = 0L,
  .after = 0L,
  .complete = FALSE,
  .names_to = NULL,
  .name_repair = c("unique", "universal", "check_unique")
)

slide_index_dfc(
  .x,
  .i,
  .f,
  ...,
  .before = 0L,
  .after = 0L,
  .complete = FALSE,
  .size = NULL,
  .name_repair = c("unique", "universal", "check_unique", "minimal")
)
}
\arguments{
\item{.x}{\verb{[vector]}

The vector to iterate over and apply \code{.f} to.}

\item{.i}{\verb{[vector]}

The index vector that determines the window sizes. The lower bound
of the window range will be computed as \code{.i - .before}, and the upper
bound as \code{.i + .after}. It is fairly common to supply a date vector
as the index, but not required.

There are 3 restrictions on the index:
\itemize{
\item The size of the index must match the size of \code{.x}, they will not be
recycled to their common size.
\item The index must be an \emph{increasing} vector, but duplicate values
are allowed.
\item The index cannot have missing values.
}}

\item{.f}{\verb{[function / formula]}

If a \strong{function}, it is used as is.

If a \strong{formula}, e.g. \code{~ .x + 2}, it is converted to a function. There
are three ways to refer to the arguments:
\itemize{
\item For a single argument function, use \code{.}
\item For a two argument function, use \code{.x} and \code{.y}
\item For more arguments, use \code{..1}, \code{..2}, \code{..3} etc
}

This syntax allows you to create very compact anonymous functions.}

\item{...}{Additional arguments passed on to the mapped function.}

\item{.before, .after}{\verb{[vector(1) / Inf]}

The number of values before or after the current element of \code{.i} to
include in the sliding window. Set to \code{Inf} to select all elements
before or after the current element. Negative values are allowed, which
allows you to "look forward" from the current element if used as the
\code{.before} value, or "look backwards" if used as \code{.after}.

Any object that can be added or subtracted from \code{.i} with \code{+} and \code{-}
can be used. For example, a lubridate period, such as \code{\link[lubridate:weeks]{lubridate::weeks()}}.

The ranges that result from computing \code{.i - .before} and \code{.i + .after}
have the same 3 restrictions as \code{.i} itself.}

\item{.complete}{\verb{[logical(1)]}

Should \code{.f} be evaluated on complete windows only? If \code{FALSE},
the default, then partial computations will be allowed.}

\item{.ptype}{\verb{[vector(0) / NULL]}

A prototype corresponding to the type of the output.

If \code{NULL}, the default, the output type is determined by computing the
common type across the results of the calls to \code{.f}.

If supplied, the result of each call to \code{.f} will be cast to that type,
and the final output will have that type.

If \code{getOption("vctrs.no_guessing")} is \code{TRUE}, the \code{.ptype} must be
supplied. This is a way to make production code demand fixed types.}

\item{.names_to}{Optionally, the name of a column where the names
of \code{...} arguments are copied. These names are useful to identify
which row comes from which input. If supplied and \code{...} is not named,
an integer column is used to identify the rows.}

\item{.name_repair}{One of \code{"unique"}, \code{"universal"}, or
\code{"check_unique"}. See \code{\link[vctrs:vec_as_names]{vec_as_names()}} for the meaning of these
options.

With \code{vec_rbind()}, the repair function is applied to all inputs
separately. This is because \code{vec_rbind()} needs to align their
columns before binding the rows, and thus needs all inputs to
have unique names. On the other hand, \code{vec_cbind()} applies the
repair function after all inputs have been concatenated together
in a final data frame. Hence \code{vec_cbind()} allows the more
permissive minimal names repair.}

\item{.size}{If, \code{NULL}, the default, will determine the number of
rows in \code{vec_cbind()} output by using the standard recycling rules.

Alternatively, specify the desired number of rows, and any inputs
of length 1 will be recycled appropriately.}
}
\value{
A vector fulfilling the following invariants:

\subsection{\code{slide_index()}}{
\itemize{
\item \code{vec_size(slide_index(.x)) == vec_size(.x)}
\item \code{vec_ptype(slide_index(.x)) == list()}
}

}

\subsection{\code{slide_index_vec()} and \verb{slide_index_*()} variants}{
\itemize{
\item \code{vec_size(slide_index_vec(.x)) == vec_size(.x)}
\item \code{vec_size(slide_index_vec(.x)[[1]]) == 1L}
\item \code{vec_ptype(slide_index_vec(.x, .ptype = ptype)) == ptype}
}

}
}
\description{
\code{slide_index()} is similar to \code{slide()}, but allows a secondary \code{.i}-ndex
vector to be provided.

This is often useful in business calculations, when
you want to compute a rolling computation looking "3 months back", which
is approximately but not equivalent to, 3 * 30 days. \code{slide_index()} allows
for these irregular window sizes.
}
\examples{
x <- 1:5

# In some cases, sliding over `x` with a strict window size of 2
# will fit your use case.
slide(x, ~.x, .before = 1)

# However, if this `i` is a date vector paired with `x`, when computing
# rolling calculations you might want to iterate over `x` while
# respecting the fact that `i` is an irregular sequence.
i <- as.Date("2019-08-15") + c(0:1, 4, 6, 7)

# For example, a "2 day" window should not pair `"2019-08-19"` and
# `"2019-08-21"` together, even though they are next to each other in `x`.
# `slide_index()` computes the lookback value from the current date in `.i`,
# meaning that if you are currently on `"2019-08-21"` and look back 1 day,
# it will correctly not include `"2019-08-19"`.
slide_index(i, i, ~.x, .before = 1)

# We could have equivalently used a lubridate period object for this as well,
# since `i - lubridate::days(1)` is allowed
slide_index(i, i, ~.x, .before = lubridate::days(1))

# ---------------------------------------------------------------------------

# When `.i` has repeated values, they are always grouped together.
i <- c(2017, 2017, 2018, 2019, 2020, 2020)
slide_index(i, i, ~.x)
slide_index(i, i, ~.x, .after = 1)

# ---------------------------------------------------------------------------
# Rolling regressions

# Rolling regressions are easy with `slide_index()` because:
# - Data frame `.x` values are iterated over rowwise
# - The index is respected by using `.i`
set.seed(123)

df <- data.frame(
  y = rnorm(100),
  x = rnorm(100),
  i = as.Date("2019-08-15") + c(0, 2, 4, 6:102) # <- irregular
)

# 20 day rolling regression. Current day + 19 days back.
# Additionally, set `.complete = TRUE` to not compute partial results.
regr <- slide_index(df, df$i, ~lm(y ~ x, .x), .before = 19, .complete = TRUE)

regr[16:18]

# The first 16 slots are NULL because there is no possible way to
# look back 19 days from the 16th index position and construct a full
# window. But on the 17th index position, `""2019-09-03"`, if we look
# back 19 days we get to `""2019-08-15"`, which is the same value as
# `i[1]` so a full window can be constructed.
i[16] - 19 >= i[1] # FALSE
i[17] - 19 >= i[1] # TRUE

}
\seealso{
\code{\link[=slide]{slide()}}, \code{\link[=hop_index]{hop_index()}}, \code{\link[=slide_index2]{slide_index2()}}
}
