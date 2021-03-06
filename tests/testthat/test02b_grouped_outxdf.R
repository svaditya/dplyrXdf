context("Grouped functionality, output to xdf")
mtx <- rxDataStep(mtcars, "mtx.xdf", overwrite=TRUE)

verifyData <- function(xdf, expectedClass)
{
    is.data.frame(head(xdf)) && class(xdf) == expectedClass  # test for exact class
}


test_that("arrange works", {
    tbl <- mtx %>% group_by(gear) %>% arrange(mpg, disp, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
})

test_that("distinct works", {
    tbl <- mtx %>% group_by(gear) %>% distinct(cyl, gear, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))

    # .keep_all will have no effect when dplyr < 0.5 installed
    skip_if_not(packageVersion("dplyr") >= package_version("0.5"))
    tbl <- mtx %>% group_by(gear) %>% distinct(cyl, gear, .keep_all=TRUE, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
    tbl <- mtx %>% group_by(gear) %>% distinct(cyl, gear, .keep_all=FALSE, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
})

test_that("do works", {
    expect_warning(mtx %>% group_by(gear) %>% do(m=lm(mpg ~ disp, .), .outFile="test2b.xdf"))
    expect_warning(mtx %>% group_by(gear) %>% doXdf(m=rxLinMod(mpg ~ disp, .), .outFile="test2b.xdf"))
})

test_that("factorise works", {
    tbl <- mtx %>% group_by(gear) %>% factorise(mpg, cyl, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
    expect(all(sapply(rxGetVarInfo(tbl)[c("mpg", "cyl")], "[[", "varType") == "factor"),
           "factor conversion failed")
})

test_that("filter works", {
    tbl <- mtx %>% group_by(gear) %>% filter(mpg > 16, cyl == 8, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
})

test_that("mutate works", {
    tbl <- mtx %>% group_by(gear) %>% mutate(m2=2*mpg, sw=sqrt(wt), .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
})

test_that("rename works", {
    tbl <- mtx %>% group_by(gear) %>% rename(cc=cyl, mm=mpg, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
    expect_true(all(c("cc", "mm") %in% names(tbl)))
})

test_that("select works", {
    tbl <- mtx %>% group_by(gear) %>% select(mpg, cyl, drat, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
})

test_that("subset works", {
    tbl <- mtx %>% group_by(gear) %>% subset(cyl==6, c(2,3,4), .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
})

test_that("summarise works", {
    tbl <- mtx %>% group_by(gear) %>% summarise(m=mean(mpg), .method=1, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
    tbl <- mtx %>% group_by(gear) %>% summarise(m=mean(mpg), .method=2, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
    tbl <- mtx %>% group_by(gear) %>% summarise(m=mean(mpg), .method=3, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
    tbl <- mtx %>% group_by(gear) %>% summarise(m=mean(mpg), .method=4, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
    tbl <- mtx %>% group_by(gear) %>% summarise(m=mean(mpg), .method=5, .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
})

test_that("transmute works", {
    tbl <- mtx %>% group_by(gear) %>% transmute(m2=2*mpg, sw=sqrt(wt), .outFile="test2b.xdf")
    expect_true(verifyData(tbl, "RxXdfData"))
})


# cleanup
file.remove("mtx.xdf")
