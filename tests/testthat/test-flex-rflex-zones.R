context("flex, rflex.zones w/ loop & verbose")
# preliminaries
data(nydf)
data(nyw)
coords <- nydf[, c("longitude", "latitude")]
pop <- nydf$population
cases <- nydf$cases

# construct zones
fzones1 <- flex.zones(coords, w = nyw, k = 3, longlat = TRUE)
invisible(capture.output(fzones2 <- flex.zones(coords,
  w = nyw, k = 3, longlat = TRUE,
  verbose = TRUE
)))
fzones3 <- flex.zones(coords,
  w = nyw, k = 3, longlat = TRUE,
  loop = TRUE
)
invisible(capture.output(fzones4 <- flex.zones(coords,
  w = nyw, k = 3, longlat = TRUE,
  loop = TRUE, verbose = TRUE
)))

# construct zones w/ flex_zones
fzones1b <- flex_zones(coords, w = nyw, k = 3, longlat = TRUE)
invisible(capture.output(fzones2b <- flex_zones(coords,
  w = nyw, k = 3, longlat = TRUE,
  verbose = TRUE
)))
fzones3b <- flex_zones(coords,
  w = nyw, k = 3, longlat = TRUE,
  loop = TRUE
)
fzones4b <- flex_zones(coords,
  w = nyw, k = 3, longlat = TRUE,
  loop = TRUE, verbose = TRUE
)

nn <- knn(coords, longlat = TRUE, k = 10)
ex <- pop * sum(cases) / sum(pop)
rzones1 <- rflex.zones(nn, w = nyw, cases = floor(cases), ex = ex)
rzones2 <- rflex.zones(nn,
  w = nyw, cases = floor(cases), ex = ex,
  verbose = TRUE
)
rzones3 <- rflex.zones(nn,
  w = nyw, cases = floor(cases), ex = ex,
  loop = TRUE
)
rzones4 <- suppressMessages(rflex.zones(nn,
  w = nyw, cases = floor(cases), ex = ex,
  loop = TRUE, verbose = TRUE
))

rzones1b <- rflex_zones(nn, w = nyw, cases = floor(cases), ex = ex)
invisible(capture.output(rzones2b <- rflex_zones(nn,
  w = nyw, cases = floor(cases), ex = ex,
  verbose = TRUE
)))
rzones3b <- rflex_zones(nn,
  w = nyw, cases = floor(cases), ex = ex,
  loop = TRUE
)
rzones4b <- suppressMessages(rflex_zones(nn,
  w = nyw, cases = floor(cases), ex = ex,
  loop = TRUE, verbose = TRUE
))
# load(system.file("R/sysdata.rda", package = "smerc"))
primes100k <- get0("primes100k",
                   envir = asNamespace("smerc"))
lprimes <- log(primes100k[seq_along(nn)])
# compare list of zones with possibly different orderings
zcompare <- function(z1, z2) {
  s1 <- sapply(z1, sort)
  s2 <- sapply(z2, sort)
  all.equal(s1, s2)
}

test_that("compare flex.zones and rflex.zones w/ and w/o loop/verbose", {
  expect_equal(fzones1, fzones2)
  expect_equal(fzones1, fzones3)
  expect_equal(fzones1, fzones4)
  expect_equal(rzones2, rzones2)
  expect_equal(rzones2, rzones3)
  expect_equal(rzones2, rzones4)

  expect_true(zcompare(fzones1, fzones1b))
  expect_true(zcompare(fzones1, fzones2b))
  expect_true(zcompare(fzones1, fzones3b))
  expect_true(zcompare(fzones1, fzones4b))
  expect_true(zcompare(rzones1, rzones1b))
  expect_true(zcompare(rzones1b, rzones2b))
  expect_true(zcompare(rzones1b, rzones3b))
  expect_true(zcompare(rzones1b, rzones4b))
})

# some debugging junk
#
# u = c(2, 13, 35, 47)
# is.element(list(u), rzones1)
# is.element(list(u), rzones1b)
#
# p = rflex.midp(floor(cases), ex)
# alpha1 = 0.2
# # determine which regions are "hot" (keep) or "cold" (remove)
# keep = which(p < alpha1)
# nkeep = length(keep)
#
# remove = setdiff(seq_along(ex), keep)
# # remove connections when p >= alpha1
# w = nyw
# w[, remove] = 0
# nn = knn(coords, k = 10)
# z1 = scsg2(nn, w, idx = keep[1])
# z2 = scsg2_cpp(nn, w, idx = keep[1], lprimes = lprimes)
