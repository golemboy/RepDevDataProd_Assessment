library("rjson")
library("dplyr")

#functions
listToDataFrame <- function(lst) {
  fl <- do.call(c, unlist(lst, recursive=FALSE))
  col_names <- unique(names(fl))
  data <- as.data.frame(matrix(fl, byrow = TRUE, nrow = length(lst), ncol = length(col_names)),stringsAsFactors=FALSE)
  colnames(data) <- col_names
  #data <- as.data.frame(fl, stringsAsFactors=FALSE)
  data  
}

num_row <- "100"
contract_name<-"Paris" 
velib_json <-"http://opendata.paris.fr/api/records/1.0/search?dataset=stations-velib-disponibilites-en-temps-reel&rows=%s&facet=banking&facet=bonus&facet=status&facet=bike_stands&facet=available_bike_stands&facet=available_bikes&facet=last_update&facet=name&refine.contract_name=%s"
#http://opendata.paris.fr/api/records/1.0/search?dataset=stations-velib-disponibilites-en-temps-reel&rows=100&facet=banking&facet=bonus&facet=status&facet=bike_stands&facet=available_bike_stands&facet=available_bikes&facet=last_update&facet=name&refine.contract_name=Paris

#Get data
url <- sprintf(fmt = velib_json, num_row, contract_name)
json_data <- readLines(url, warn=FALSE) 
json_lst <- fromJSON(paste(json_data, collapse="")) 

records <- json_lst$records
facet_groups <- json_lst$facet_groups

dt <- listToDataFrame(records)
dt$fields.name
head(dt)




