library("rjson")
library("dplyr")
#setwd(paste0(getwd(),"/velib"))
#source("myTools.R")

#functions
list_of_list_to_dataframe_of_list <- function(lst) {
  fl <- do.call(c, unlist(lst, recursive=FALSE)) #obtain a flatten list
  col_names <- unique(names(fl)) # get cols name
  # obtain a datframe of list
  data <- as.data.frame(matrix(fl, byrow = TRUE, nrow = length(lst), ncol = length(col_names)),stringsAsFactors=FALSE)
  colnames(data) <- col_names # rename columns
  #dt <- as.data.frame(lapply(data, unlist),stringsAsFactors=FALSE) # finally obtain a data frame of characters
  data  
}

get_zipcode <- function(x) {
  adress <- unlist(strsplit(x, " "))
  adress[[length(adress)-1]]
}

get_coordinates_df <- function(geo_data, record_id) {
  #unlist(geo_data[geo_data$recordid %in% recordid,]$fields.position)    
  #geo_data$recordid <- unlist(geo_data$recordid)  
  filter(geo_data, recordid %in% record_id) %>% select(recordid, fields.position)
}

get_coordinates <- function(geo_data, record_id) {  
  unlist((
    get_coordinates_df(geo_data, record_id)
    )$fields.position)
}

get_top_available_bikes <- function(dts, top) {
    grp <- dts %>%
      select(recordid, fields.zipcode, fields.available_bikes) %>%      
      arrange(desc(fields.available_bikes)) %>%
      group_by(fields.zipcode, max(fields.available_bikes))
    
    inner_join(x = dts, y = head(grp, top), by = c("recordid","fields.available_bikes","fields.zipcode")) %>% 
      select(recordid, fields.zipcode, fields.available_bikes, fields.available_bike_stands, fields.bonus, fields.last_update) %>%
      arrange(desc(fields.available_bikes))
}

get_top_available_bike_stands <- function(dts, top) {
  grp <- dts %>%
    select(recordid, fields.zipcode, fields.available_bike_stands) %>%
    arrange(desc(fields.available_bike_stands)) %>%
    group_by(fields.zipcode, max(fields.available_bike_stands))
  
  inner_join(x = dts, y = head(grp, top), by = c("recordid","fields.available_bike_stands","fields.zipcode"))  %>%
    select(recordid, fields.zipcode, fields.available_bikes, fields.available_bike_stands, fields.bonus, fields.last_update) %>%
    arrange(desc(fields.available_bike_stands)) 
}



#Get data
get_data <- function(json_source) {
  url <- sprintf(fmt = json_source, num_row, contract_name)
  json_data <- readLines(url, warn=FALSE) 
  json_lst <- fromJSON(paste(json_data, collapse="")) 

  records <- json_lst$records
  facet_groups <- json_lst$facet_groups

  dtl <- list_of_list_to_dataframe_of_list(records)
    
  #on isole les colonnes coordonnées
  geo_data <- select(dtl, c(2,14:16))
  velib_data <- as.data.frame(lapply(select(dtl, -c(14:16)), unlist),stringsAsFactors=FALSE)
    
  dts <- velib_data %>% 
    arrange(desc(fields.last_update), desc(fields.available_bikes), desc(fields.available_bike_stands)) %>%
    filter(fields.status == "OPEN") %>%
    mutate(fields.zipcode = get_zipcode(fields.address)) %>%
    select(recordid, fields.name, fields.zipcode, fields.available_bikes, fields.available_bike_stands, fields.bonus, fields.last_update)
    
  #if (bonus != NA)
   # dts <- filter(dts, fields.bonus == bonus)
  
  list(dts,geo_data)      
}

get_top_bikes <- function(dt, top, stands) {  
  dts <- as.data.frame(dt[1])
  geo_data <- as.data.frame(dt[2])
  
  if (stands == FALSE)
    top_data <- get_top_available_bikes(dts,top)
  else
    top_data <- get_top_available_bike_stands(dts,top)
  
  coord_df <- get_coordinates_df(geo_data, top_data$recordid)
  position<-do.call(rbind,coord_df$fields.position)
  record_id<-do.call(rbind,coord_df$recordid)
  coord_data <- as.data.frame(cbind(record_id,position), stringsAsFactors = FALSE)
  colnames(coord_data) <- c("recordid","lat","long")
  top_dt <- inner_join(x=top_data, y=coord_data, by = "recordid")
  top_dt
}

# num_row <- "100" #"1230"
# contract_name<-"Paris" 
# velib_json <-"http://opendata.paris.fr/api/records/1.0/search?dataset=stations-velib-disponibilites-en-temps-reel&rows=%s&facet=banking&facet=bonus&facet=status&facet=bike_stands&facet=available_bike_stands&facet=available_bikes&facet=last_update&facet=name&refine.contract_name=%s"
# 
# dt <- get_data(velib_json)
# 
# top_available_bikes <- get_top_bikes(dt, 10, FALSE)
# top_available_bike_stands <- get_top_bikes(dt, 10, TRUE)
