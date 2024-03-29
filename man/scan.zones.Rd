% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scan.zones.R
\name{scan.zones}
\alias{scan.zones}
\title{Determine zones for the spatial scan test}
\usage{
scan.zones(coords, pop, ubpop = 0.5, longlat = FALSE)
}
\arguments{
\item{coords}{An \eqn{n \times 2} matrix of centroid
coordinates for the regions in the form (x, y) or
(longitude, latitude) is using great circle distance.}

\item{pop}{The population size associated with each
region.}

\item{ubpop}{The upperbound of the proportion of the
total population to consider for a cluster.}

\item{longlat}{The default is \code{FALSE}, which
specifies that Euclidean distance should be used. If
\code{longlat} is \code{TRUE}, then the great circle
distance is used to calculate the intercentroid
distance.}
}
\value{
Returns a list of zones to consider for
  clustering.  Each element of the list contains a vector
  with the location ids of the regions in that zone.
}
\description{
\code{scan.zones} determines the unique candidate
zones to consider for the circular spatial scan test of
Kulldorff (1997).
}
\examples{
data(nydf)
coords <- cbind(nydf$longitude, nydf$latitude)
zones <- scan.zones(
  coords = coords, pop = nydf$pop,
  ubpop = 0.1, longlat = TRUE
)
}
\references{
Kulldorff, M. (1997) A spatial
scan statistic. Communications in Statistics - Theory and
Methods, 26(6): 1481-1496,
<doi:10.1080/03610929708831995>
}
\author{
Joshua French
}
