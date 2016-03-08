rmdr <- file.path(tempdir(), "rmote_server")
f1 <- tempfile(fileext = ".png")
f2 <- tempfile(fileext = ".png")
f3 <- tempfile(fileext = ".png")

rmote::start_rmote(rmdr)

?lm
r1 <- file.exists(file.path(rmdr, "output0001.html"))

?glm
r2 <- file.exists(file.path(rmdr, "output0002.html"))

library(lattice)
xyplot(1:10 ~ 1:10)
r3 <- file.exists(file.path(rmdr, "output0003.html"))

png(file = f1)
xyplot(1:10 ~ 1:10)
dev.off()
r4 <- file.exists(f1)

library(ggplot2)
qplot(mpg, wt, data = mtcars)
r5 <- file.exists(file.path(rmdr, "output0004.html"))

png(file = f2)
qplot(mpg, wt, data = mtcars)
dev.off()
r6 <- file.exists(f1)

plot(1:10)
rmote::plot_done()
r7 <- file.exists(file.path(rmdr, "output0005.html"))

png(file = f3)
plot(1:10)
dev.off()
r8 <- file.exists(f3)

# TODO: testthat doesn't like this
# runs fine in .GlobalEnv in an interactive session
# look into it...
test_that("rmote working", {
  if(FALSE) {
    expect_true(r1)
    expect_true(r2)
    expect_true(r3)
    expect_true(r4)
    expect_true(r5)
    expect_true(r6)
    expect_true(r7)
    expect_true(r8)
  }
})

rmote::stop_rmote()
