% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grd.R
\name{nmgrd}
\alias{nmgrd}
\title{Reads the NONMEM \code{.grd} file for final parameter gradient}
\usage{
nmgrd(file)
}
\arguments{
\item{file}{File where the list is located}
}
\value{
return a list with \verb{$rawGrad}
}
\description{
Reads the NONMEM \code{.grd} file for final parameter gradient
}
\examples{

nmgrd(system.file("mods/cpt/runODE032.grd", package="nonmem2rx"))

}
\author{
Matthew L. Fidler
}
