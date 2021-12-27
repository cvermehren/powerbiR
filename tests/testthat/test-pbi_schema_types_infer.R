test_that("Logical vector is infered as 'Boolean'", {
  expect_equal(pbi_schema_types_infer(c(TRUE, FALSE)), "Boolean")
})

test_that("Integer vector is infered as 'Int64'", {
  expect_equal(pbi_schema_types_infer(as.integer(c(1, 2))), "Int64")
})

test_that("Double vector is infered as 'Double'", {
  expect_equal(pbi_schema_types_infer( as.double(c(1, 2))), "Double")
})

test_that("Date vector is infered as 'Date'", {
  expect_equal(pbi_schema_types_infer( as.Date(c("2021-01-01", "2021-01-02"))), "DateTime")
})

test_that("Date vector is infered as 'Date'", {
  expect_equal(pbi_schema_types_infer( Sys.Date()), "DateTime")
})

test_that("Time vector is infered as 'Date'", {
  expect_equal(pbi_schema_types_infer( Sys.time()), "DateTime")
})

test_that("Factor vector is infered as 'String'", {
  expect_equal(pbi_schema_types_infer( factor(c("Man", "Woman"))), "String")
})
