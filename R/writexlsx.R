

#' @name write.xlsx
#' @title write directly to an xlsx file
#' @author Alexander Walker
#' @param x object or a list of objects that can be handled by \code{\link{writeData}} to write to file
#' @param file xlsx file name
#' @param asTable write using writeDataTable as opposed to writeData
#' @param ... optional parameters to pass to functions:
#' \itemize{
#'   \item{createWorkbook}
#'   \item{addWorksheet}
#'   \item{writeData}
#'   \item{saveWorkbook}
#' }
#' 
#' see details.
#' @details Optional parameters are:
#' \itemize{
#'   \item{\bold{creator}}{ A string specifying the workbook author}
#'   \item{\bold{sheetName}}{ Name of the worksheet}
#'   \item{\bold{gridLines}}{ A logical. If FALSE, the worksheet grid lines will be hidden.}
#'   \item{\bold{startCol}}{ A vector specifiying the starting column(s) to write df}
#'   \item{\bold{startRow}}{ A vector specifiying the starting row(s) to write df}
#'   \item{\bold{xy}}{ An alternative to specifying startCol and startRow individually. 
#'  A vector of the form c(startCol, startRow)}
#'   \item{\bold{colNames or col.names}}{ If TRUE, column names of x are written.}
#'   \item{\bold{rowNames or row.names}}{ If TRUE, row names of x are written.}
#'   \item{\bold{headerStyle}}{ Custom style to apply to column names.}
#'   \item{\bold{borders}}{ Either "surrounding", "columns" or "rows" or NULL.  If "surrounding", a border is drawn around the
#' data.  If "rows", a surrounding border is drawn a border around each row. If "columns", a surrounding border is drawn with a border
#' between each column.  If "\code{all}" all cell borders are drawn.}
#'   \item{\bold{borderColour}}{ Colour of cell border}
#'   \item{\bold{borderStyle}}{ Border line style.}
#'   \item{\bold{overwrite}}{ Overwrite existing file (Defaults to TRUE as with write.table)}
#' }
#' 
#' columns of x with class Date or POSIXt are automatically
#' styled as dates and datetimes respectively.
#' @seealso \code{\link{addWorksheet}}
#' @seealso \code{\link{writeData}}
#' @seealso \code{\link{createStyle}} for style parameters
#' @return A workbook object
#' @examples
#' 
#' ## write to working directory
#' options("openxlsx.borderColour" = "#4F80BD") ## set default border colour
#' write.xlsx(iris, file = "writeXLSX1.xlsx", colNames = TRUE, borders = "columns")
#' write.xlsx(iris, file = "writeXLSX2.xlsx", colNames = TRUE, borders = "surrounding")
#' 
#' 
#' hs <- createStyle(textDecoration = "BOLD", fontColour = "#FFFFFF", fontSize=12,
#'                   fontName="Arial Narrow", fgFill = "#4F80BD")
#' 
#' write.xlsx(iris, file = "writeXLSX3.xlsx", colNames = TRUE, borders = "rows", headerStyle = hs)
#' 
#' ## Lists elements are written to individual worksheets, using list names as sheet names if available
#' l <- list("IRIS" = iris, "MTCATS" = mtcars, matrix(runif(1000), ncol = 5))
#' write.xlsx(l, "writeList1.xlsx")
#' 
#' ## different sheets can be given different parameters
#' write.xlsx(l, "writeList2.xlsx", startCol = c(1,2,3), startRow = 2,
#'            asTable = c(TRUE, TRUE, FALSE), withFilter = c(TRUE, FALSE, FALSE))
#' 
#' @export
write.xlsx <- function(x, file, asTable = FALSE, ...){
  
  
  ## set scientific notation penalty
  
  params <- list(...)
  
  ## Possible parameters
  
  #---createWorkbook---#
  ## creator
  
  #---addWorksheet---#
  ## sheetName
  ## gridLines
  
  #---writeData---#
  ## startCol = 1,
  ## startRow = 1, 
  ## xy = NULL,
  ## colNames = TRUE,
  ## rowNames = FALSE,
  ## headerStyle = NULL,
  ## borders = NULL,
  ## borderColour = "#4F81BD"
  ## borderStyle
  
  #----writeDataTable---#
  ## startCol = 1
  ## startRow = 1
  ## xy = NULL
  ## colNames = TRUE
  ## rowNames = FALSE
  ## tableStyle = "TableStyleLight9"
  ## tableName = NULL
  ## headerStyle = NULL
  ## withFilter = TRUE
  
  #---saveWorkbook---#
  #   overwrite = TRUE
  
  if(!is.logical(asTable))
    stop("asTable must be a logical.")
  
  creator <- ""
  if(creator %in% names(params))
    creator <- params$creator
  
  sheetName <- "Sheet 1"
  if("sheetName" %in% names(params)){
    
    if(nchar(params$sheetName) > 31)
      stop("sheetName too long! Max length is 31 characters.")
    
    sheetName <- as.character(params$sheetName)
  }
  
  gridLines <- TRUE
  if("gridLines" %in% names(params)){
    if(all(is.logical(params$gridLines))){
      gridLines <- params$gridLines
    }else{
      stop("Argument gridLines must be TRUE or FALSE")
    }
  }
  
  overwrite <- TRUE
  if("overwrite" %in% names(params)){
    if(is.logical(params$overwrite)){
      overwrite <- params$overwrite
    }else{
      stop("Argument overwrite must be TRUE or FALSE")
    }
  }
  
  withFilter <- TRUE
  if("withFilter" %in% names(params)){
    if(is.logical(params$withFilter)){
      withFilter <- params$withFilter
    }else{
      stop("Argument withFilter must be TRUE or FALSE")
    }
  }
  
  startRow <- 1
  if("startRow" %in% names(params)){
    if(all(startRow > 0)){
      startRow <- params$startRow
    }else{
      stop("startRow must be a positive integer")
    }
  }
  
  startCol <- 1
  if("startCol" %in% names(params)){
    if(all(startCol > 0)){
      startCol <- params$startCol
    }else{
      stop("startCol must be a positive integer")
    }
  }
  
  colNames <- TRUE
  if("colNames" %in% names(params)){
    if(is.logical(params$colNames)){
      colNames <- params$colNames
    }else{
      stop("Argument colNames must be TRUE or FALSE")
    }
  }
  
  ## to be consistent with write.csv
  if("col.names" %in% names(params)){
    if(is.logical(params$col.names)){
      colNames <- params$col.names
    }else{
      stop("Argument col.names must be TRUE or FALSE")
    }
  }
  
  
  rowNames <- FALSE
  if("rowNames" %in% names(params)){
    if(is.logical(params$rowNames)){
      rowNames <- params$rowNames
    }else{
      stop("Argument colNames must be TRUE or FALSE")
    }
  }
  
  ## to be consistent with write.csv
  if("row.names" %in% names(params)){
    if(is.logical(params$row.names)){
      rowNames <- params$row.names
    }else{
      stop("Argument row.names must be TRUE or FALSE")
    }
  }
  
  xy <- NULL
  if("xy" %in% names(params)){
    if(length(params$xy) != 2)
      stop("xy parameter must have length 2")
    xy <- params$xy
  }
  
  
  headerStyle <- NULL
  if("headerStyle" %in% names(params)){
    
    if(length(params$headerStyle) == 1){
      if("Style" %in% class(params$headerStyle)){
        headerStyle <- params$headerStyle
      }else{
        stop("headerStyle must be a style object.")
      }
    }else{
      if(all(sapply(params$headerStyle, function(x) "Style" %in% class(x)))){
        headerStyle <- params$headerStyle
      }else{
        stop("headerStyle must be a style object.")
      }
    }
  }
  
  borders <- NULL
  if("borders" %in% names(params)){
    borders <- tolower(params$borders)
    if(!all(borders %in% c("surrounding", "rows", "columns")))
      stop("Invalid borders argument")
  }
  
  borderColour <- getOption("openxlsx.borderColour", "black")
  if("borderColour" %in% names(params))
    borderColour <- params$borderColour
  
  borderStyle <- getOption("openxlsx.borderStyle", "thin")
  if("borderStyle" %in% names(params)){
    borderStyle <- validateBorderStyle(params$borderStyle)
  }
  
  tableStyle <- "TableStyleLight9"
  if("tableStyle" %in% names(params))
    tableStyle <- params$tableStyle
  
  
  ## create new Workbook object
  wb <- Workbook$new(creator)
  
  ## If a list is supplied write to individual worksheets using names if available
  if("list" %in% class(x)){
    
    nms <- names(x)
    nSheets <- length(x)
    
    if(is.null(nms)){
      nms <- paste("Sheet", 1:nSheets)
    }else if(any("" %in% nms)){
      nms[nms %in% ""] <- paste("Sheet", (1:nSheets)[nms %in% ""])
    }else{
      nms <- make.names(nms, unique  = TRUE)
    }
    
    ## make all inputs as long as the list
    if(length(withFilter) != nSheets)
      withFilter <- rep_len(withFilter, length.out = nSheets)
    
    if(length(colNames) != nSheets)
      colNames <- rep_len(colNames, length.out = nSheets)
    
    if(length(rowNames) != nSheets)
      rowNames <- rep_len(rowNames, length.out = nSheets)
    
    if(length(startRow) != nSheets)
      startRow <- rep_len(startRow, length.out = nSheets)
    
    if(length(startCol) != nSheets)
      startCol <- rep_len(startCol, length.out = nSheets)
        
    if(length(headerStyle) != nSheets & !is.null(headerStyle))
      headerStyle <- lapply(1:nSheets, function(x) headerStyle)
        
    if(length(borders) != nSheets & !is.null(borders))
      borders <- rep_len(borders, length.out = nSheets)
    
    if(length(borderColour) != nSheets)
      borderColour <- rep_len(borderColour, length.out = nSheets)
    
    if(length(borderStyle) != nSheets)
      borderStyle <- rep_len(borderStyle, length.out = nSheets)
    
    if(length(asTable) != nSheets)
      asTable <- rep_len(asTable, length.out = nSheets)
    
    if(length(tableStyle) != nSheets)
      tableStyle <- rep_len(tableStyle, length.out = nSheets)
    
    for(i in 1:nSheets){
      
      wb$addWorksheet(nms[[i]], showGridLines = gridLines)
      
      if(asTable[i]){
                
        writeDataTable(wb = wb,
                       sheet = i,
                       x = x[[i]],
                       startCol = startCol[[i]],
                       startRow = startRow[[i]],
                       xy = xy,
                       colNames = colNames[[i]],
                       rowNames = rowNames[[i]],
                       tableStyle = tableStyle[[i]],
                       tableName = NULL,
                       headerStyle = headerStyle[[i]],
                       withFilter = withFilter[[i]])
        
      }else{
        
        writeData(wb = wb, 
                  sheet = i,
                  x = x[[i]],
                  startCol = startCol[[i]],
                  startRow = startRow[[i]], 
                  xy = xy,
                  colNames = colNames[[i]],
                  rowNames = rowNames[[i]],
                  headerStyle = headerStyle[[i]],
                  borders = borders[[i]],
                  borderColour = borderColour[[i]],
                  borderStyle = borderStyle[[i]])
        
      }
      
      
    }
    
    
  }else{
    
    wb$addWorksheet(sheetName, showGridLines = gridLines)
    
    if(asTable){
      
      if(!"data.frame" %in% class(x))
        stop("x must be a data.frame is asTable == TRUE")
      
      writeDataTable(wb = wb,
                     sheet = 1,
                     x = x,
                     startCol = startCol,
                     startRow = startRow,
                     xy = xy,
                     colNames = colNames,
                     rowNames = rowNames,
                     tableStyle = tableStyle,
                     tableName = NULL,
                     headerStyle = headerStyle)
      
    }else{
            
      writeData(wb = wb, 
                sheet = 1,
                x = x,
                startCol = startCol,
                startRow = startRow, 
                xy = xy,
                colNames = colNames,
                rowNames = rowNames,
                headerStyle = headerStyle,
                borders = borders,
                borderColour = borderColour,
                borderStyle = borderStyle)      
    }
    
  }
  
  
  
  saveWorkbook(wb = wb, file = file, overwrite = overwrite)
  
  invisible(wb)
  
}

