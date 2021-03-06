# ------------------------------------------------------------------------------
# slide2_vec

test_that("slide2_vec() works", {
  expect_equivalent(slide2_vec(1L, 1L, ~.x + .y), 2L)
})

test_that("slide2_vec() retains names of x", {
  expect_equivalent(slide2_vec(c(x = 1L), c(y = 1L), ~.x + .y), c(x = 2L))
})

test_that("slide2_vec() can simplify automatically", {
  expect_equivalent(slide2_vec(1, 2, ~.x + .y, .ptype = NULL), 3)
})

test_that("slide2_vec() errors if it can't simplify", {
  fn <- function(x, y) if (x == 1L) {1} else {"hi"}
  expect_error(
    slide2_vec(1:2, 1:2, fn, .ptype = NULL),
    class = "vctrs_error_incompatible_type"
  )
})

# ------------------------------------------------------------------------------
# suffix tests

test_that("slide2_int() works", {
  expect_equivalent(slide2_int(1L, 1L, ~.x + .y), 2L)
})

test_that("slide2_int() can coerce", {
  expect_equivalent(slide2_int(1, 1, ~.x + .y), 2L)
})

test_that("slide2_dbl() works", {
  expect_equivalent(slide2_dbl(1, 1, ~.x), 1)
})

test_that("slide2_dbl() can coerce", {
  expect_equivalent(slide2_dbl(1L, 1L, ~.x + .y), 2)
})

test_that("slide2_chr() works", {
  expect_equivalent(slide2_chr("x", 1, ~.x), "x")
})

test_that("slide2_chr() can coerce", {
  expect_equivalent(slide2_chr(1, 1, ~.x + .y), "2")
})

test_that("slide2_lgl() works", {
  expect_equivalent(slide2_lgl(TRUE, 1, ~.x), TRUE)
})

test_that("slide2_lgl() can coerce", {
  expect_equivalent(slide2_lgl(1, 0, ~.x + .y), TRUE)
})

# ------------------------------------------------------------------------------
# data frame suffix tests

test_that("slide2_dfr() works", {
  expect_equal(
    slide2_dfr(1:2, 1:2, ~c(.x, .y), .before = 1),
    data.frame(
      ...1 = c(1, 1),
      ...2 = c(1, 2),
      ...3 = c(NA, 1),
      ...4 = c(NA, 2)
    )
  )

  x <- 1:2
  expect_equal(
    slide2_dfr(x, x, ~data.frame(x = .x, y = .y), .before = 1),
    data.frame(x = c(1, 1, 2), y = c(1, 1, 2))
  )
})

test_that("slide2_dfc() works", {
  x <- 1:2
  expect_equal(
    slide2_dfc(x, x, ~data.frame(x = .x, y = .y), .before = 1),
    data.frame(
      x...1 = c(1, 1),
      y...2 = c(1, 1),
      x...3 = c(1, 2),
      y...4 = c(1, 2)
    )
  )
})
