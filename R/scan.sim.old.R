#' Perform \code{scan.test} on simulated data
#'
#' \code{scan.sim} efficiently performs
#' \code{\link{scan.test}} on a simulated data set.  The
#' function is meant to be used internally by the
#' \code{\link{scan.test}} function, but is informative for
#' better understanding the implementation of the test.
#'
#' @inheritParams flex.sim
#' @inheritParams scan.test
#' @param nn A list of nearest neighbors produced by \code{\link{nnpop}}.
#'
#' @return A vector with the maximum test statistic for each
#'   simulated data set.
#' @export
#' @keywords internal
#' @examples
#' data(nydf)
#' coords <- with(nydf, cbind(longitude, latitude))
#' d <- gedist(as.matrix(coords), longlat = TRUE)
#' nn <- scan.nn(d, pop = nydf$pop, ubpop = 0.1)
#' cases <- floor(nydf$cases)
#' ty <- sum(cases)
#' ex <- ty / sum(nydf$pop) * nydf$pop
#' yin <- nn.cumsum(nn, cases)
#' ein <- nn.cumsum(nn, ex)
#' tsim <- scan.sim(nsim = 1, nn, ty, ex, ein = ein, eout = sum(ex) - ein)
scan.sim <- function(nsim = 1, nn, ty, ex, type = "poisson",
                     ein = NULL, eout = NULL,
                     tpop = NULL, popin = NULL, popout = NULL,
                     cl = NULL,
                     simdist = "multinomial",
                     pop = NULL,
                     min.cases = 2) {
  message("The function has been deprecated. Please switch to use scan.sim.adj")
  # match simdist with options
  simdist <- match.arg(simdist, c("multinomial", "poisson", "binomial"))
  arg_check_sim(
    nsim = nsim, ty = ty, ex = ex, type = type,
    nn = nn, ein = ein, eout = eout, tpop = tpop,
    popin = popin, popout = popout, static = TRUE,
    simdist = simdist, pop = pop,
    w = diag(length(ex))
  )

  # compute max test stat for nsim simulated data sets
  tsim <- pbapply::pblapply(seq_len(nsim), function(i) {
    # simulate new data
    if (simdist == "multinomial") {
      ysim <- stats::rmultinom(1, size = ty, prob = ex)
    } else if (simdist == "poisson") {
      ysim <- stats::rpois(length(ex), lambda = ex)
      ty <- sum(ysim)
      mult <- ty / sum(ex)
      ein <- ein * mult
      eout <- eout * mult
    } else if (simdist == "binomial") {
      ysim <- stats::rbinom(
        n = length(ex), size = pop,
        prob = ex / pop
      )
      ty <- sum(ysim)
    }
    # compute test statistics for each zone
    yin <- nn.cumsum(nn, ysim)
    if (type == "poisson") {
      tall <- stat_poisson(yin, ty - yin, ein, eout)
    } else if (type == "binomial") {
      tall <- stat_binom(yin, ty - yin, ty, popin, popout, tpop)
    }
    # make sure minimum number of cases satisfied
    max(tall[yin >= min.cases])
  }, cl = cl)
  unlist(tsim, use.names = FALSE)
}
