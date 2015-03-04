install.packages("rjson")
library("rjson")
library("plyr")
num_row <- "900"
filter_town <-"Paris"
autolib_json <- "http://opendata.paris.fr/api/records/1.0/search?dataset=stations_et_espaces_autolib_de_la_metropole_parisienne&rows=%s&facet=identifiant_autolib&facet=code_postal&facet=ville&facet=emplacement"
url <- sprintf(fmt = autolib_json, num_row)
json_data <- fromJSON( file = url)
records <- json_data$records
fl <- do.call(c, unlist(records, recursive=FALSE))
data <- data.frame(matrix(fl, byrow = TRUE, nrow = length(records), ncol = 15))
colnames(data) <- unique(names(fl))
head(data)

dtParis <-subset(x = data, fields.ville == filter_town)
dt <- subset(data, data$fields.identifiant_autolib == "Paris/Croix des Petits Champs/4")
head(dtParis)

man(unlist(dtParis$fields.autolib))

dt <- subset(data, fields.autolib == max(unlist(dtParis$fields.autolib)))
dt
head(dtParis)

