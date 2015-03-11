library(rjson)
library(dplyr)


selected_field <<- c("fields.name", "fields.borough", "fields.available_bikes", "fields.available_bike_stands", "fields.last_update","lat","long")

#functions
list_of_list_to_dataframe_of_list <- function(lst) {
  fl <- do.call(c, unlist(lst, recursive=FALSE)) #obtain a flatten list
  col_names <- unique(names(fl)) # get cols name
  # obtain a datframe of list
  data <- as.data.frame(matrix(fl, byrow = TRUE, nrow = length(lst), ncol = length(col_names)),stringsAsFactors=FALSE)
  colnames(data) <- col_names # rename columns
  
  data  
}

#extract zip code from number
get_zip <- function(number) {
  (number - (number %% 1000))/1000
}


get_top_available_bikes <- function(dt, top, borough) {
  dts <- dt %>%
    select(recordid, fields.borough, fields.available_bikes) %>%      
    arrange(desc(fields.available_bikes)) 
  
  if (borough > 20)
    grp <- dts %>% group_by(fields.borough, max(fields.available_bikes))
  else 
    grp <- dts %>% filter(fields.borough == borough) %>% group_by(recordid, max(fields.available_bikes))    
    
  inner_join(x = dt, y = head(grp, top), by = c("recordid","fields.available_bikes","fields.borough")) %>% 
  arrange(desc(fields.available_bikes))
}

get_top_available_bike_stands <- function(dt, top, borough) {
  dts <- dt %>%
    select(recordid, fields.borough, fields.available_bike_stands) %>%
    arrange(desc(fields.available_bike_stands))
    if (borough > 20)
      grp <- dts %>% group_by(fields.borough, max(fields.available_bike_stands))
    else 
      grp <- dts %>% filter(fields.borough == borough) %>% group_by(recordid, max(fields.available_bike_stands))
          
  
  inner_join(x = dt, y = head(grp, top), by = c("recordid","fields.available_bike_stands","fields.borough"))  %>%
  arrange(desc(fields.available_bike_stands)) 
}

get_top_bikes <- function(dt, top, stands,borough) {  
  dts <- as.data.frame(dt[1])
  geo_data <- as.data.frame(dt[2])
  
  if (stands == FALSE)
    top_data <- get_top_available_bikes(dts,top,borough)
  else
    top_data <- get_top_available_bike_stands(dts,top,borough)
  
  coord_df <- filter(geo_data, recordid %in% top_data$recordid) %>% select(recordid, fields.position)  
  position<-do.call(rbind,coord_df$fields.position)
  record_id<-do.call(rbind,coord_df$recordid)
  coord_data <- as.data.frame(cbind(record_id,position), stringsAsFactors = FALSE)
  colnames(coord_data) <- c("recordid","lat","long")
  top_dt <- inner_join(x=top_data, y=coord_data, by = "recordid")
  top_dt[,selected_field]
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
    mutate(fields.borough = get_zip(fields.number)) %>%    
    filter(fields.borough <= 20)
    

  
  list(dts,geo_data)      
}



# num_row <- "1000" #"1230"
# contract_name<-"Paris" 
# velib_json <-"http://opendata.paris.fr/api/records/1.0/search?dataset=stations-velib-disponibilites-en-temps-reel&rows=%s&facet=banking&facet=bonus&facet=status&facet=bike_stands&facet=available_bike_stands&facet=available_bikes&facet=last_update&facet=name&refine.contract_name=%s"

# dt <- get_data(velib_json)
# dtf <- as.data.frame(dt[1])
# geo_data <- as.data.frame(dt[2])
# 
# 
# top_available_bikes <- get_top_bikes(dt, 10, FALSE,1)
# 
# top_available_bikes
# top_available_bike_stands <- get_top_bikes(dt, 10, TRUE, 1)
# top_available_bike_stands
