% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getGammaMutRates.R
\name{getGammaMutRates}
\alias{getGammaMutRates}
\title{Get a Vector of Randomly Chosen Mutation Rates}
\usage{
getGammaMutRates(n, gmean = 1e-04, gstd = 1e-05)
}
\arguments{
\item{n}{Number of loci to select rates for}

\item{gmean}{Mean of the gamma distribution}

\item{gstd}{Std Dev of the gamma distribution}
}
\value{
a vector of mutation rates (type numeric)
}
\description{
Get a vector of mutation rates from a gamma distribution by
  specifying the mean and std. dev. of the distribution
}
\examples{
rates = getGammaMutRates(1000,gmean=0.0001, gstd=0.0001)
hist(rates)
rates = getGammaMutRates(1000,gmean=0.0001, gstd=0.00001)
hist(rates)
}

