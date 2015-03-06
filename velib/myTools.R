
## cast a list element witch contains a vector to a vector
list_element_to_vector <- function(list_elem) {
  as.vector(sapply(list_elem,unlist))
}

list_element_to_df <- function(x) {
  t(as.data.frame(sapply(list_elem,unlist)))
}

trim <- function (x) gsub("^\\s+|\\s+$", "", x)