% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/wrappers.R
\name{setHeader}
\alias{setHeader}
\title{Set header for all worksheets}
\usage{
setHeader(wb, text, position = "center")
}
\arguments{
\item{wb}{A workbook object}

\item{text}{header text. A character vector of length 1.}

\item{position}{Postion of text in header. One of "left", "center" or "right"}
}
\description{
Set header for all worksheets
}
\examples{
wb <- createWorkbook("Edgar Anderson")
addWorksheet(wb, "S1")
writeDataTable(wb, "S1", x = iris[1:30,], xy = c("C", 5))

## set all headers
setHeader(wb, "This is a header", position="center")
setHeader(wb, "To the left", position="left")
setHeader(wb, "On the right", position="right")

## set all footers
setFooter(wb, "Center Footer Here", position="center")
setFooter(wb, "Bottom left", position="left")
setFooter(wb, Sys.Date(), position="right")

saveWorkbook(wb, "headerFooterExample.xlsx", overwrite = TRUE)
}
\author{
Alexander Walker
}

