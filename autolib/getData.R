require("rjson")
require("plyr")
num_row <- "500"
autolib_json <- "http://opendata.paris.fr/api/records/1.0/search?dataset=stations_et_espaces_autolib_de_la_metropole_parisienne&rows=%s&facet=identifiant_autolib&facet=code_postal&facet=ville&facet=emplacement"
url <- sprintf(fmt = autolib_json, num_row)
json_data <- fromJSON( file = url)
records <- json_data$records
fl <- do.call(c, unlist(records, recursive=FALSE))
data <- data.frame(matrix(fl, byrow = TRUE, nrow = length(records), ncol = 15))
colnames(data) <- unique(names(fl))
