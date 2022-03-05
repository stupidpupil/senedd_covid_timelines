strip_tracker_query_params <- function(in_url){
	parsed_url <- httr::parse_url(in_url)

	if(is.null(parsed_url$query)){
		return(in_url)
	}

	parsed_url$query[["_ga"]] <- NULL
	parsed_url$query[["_"]] <- NULL


	new_url <- parsed_url %>% httr::build_url()

	if(length(new_url) == 0){
		return(in_url)
	}

	return(new_url)
}