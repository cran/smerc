% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/uls.zones.R
\name{uls.zones}
\alias{uls.zones}
\title{Determine sequence of ULS zones.}
\usage{
uls.zones(cases, pop, w, ubpop = 0.5, check.unique = FALSE)
}
\arguments{
\item{cases}{The number of cases observed in each region.}

\item{pop}{The population size associated with each
region.}

\item{w}{A binary spatial adjacency matrix for the
regions.}

\item{ubpop}{The upperbound of the proportion of the
total population to consider for a cluster.}

\item{check.unique}{A logical value indicating whether a
check for unique values should be determined.  The
default is \code{FALSE}.  This is unlikely to make a
practical different for most real data sets.}
}
\value{
Returns a list of zones to consider for
  clustering.  Each element of the list contains a vector
  with the location ids of the regions in that zone.
}
\description{
\code{uls.zones} determines the unique zones obtained by
implementing the ULS (Upper Level Set) test of Patil and
Taillie (2004).
}
\details{
The zones returned must have a total population less than
\code{ubpop * sum(pop)} of all regions in the study area.
}
\examples{
data(nydf)
data(nyw)
uls.zones(cases = nydf$cases, pop = nydf$population, w = nyw)
}
\references{
Patil, G.P. & Taillie, C. Upper level set
  scan statistic for detecting arbitrarily shaped
  hotspots. Environmental and Ecological Statistics
  (2004) 11(2):183-197.
  <doi:10.1023/B:EEST.0000027208.48919.7e>
}
\author{
Joshua French
}
