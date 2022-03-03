un_outlook_protect_url <- function(outlook_protected_url){

	parsed_url <- httr::parse_url(outlook_protected_url)

	if(is.null(parsed_url$hostname)){
		return(outlook_protected_url)
	}

	if(!(parsed_url$hostname %>% stringr::str_detect("\\.safelinks\\.protection\\.outlook\\.com$"))){
		return(outlook_protected_url)
	}

	if(is.null(parsed_url$query)){
		return(outlook_protected_url)
	}

	if(is.null(parsed_url$query$url)){
		return(outlook_protected_url)
	}

	return(parsed_url$query$url)
}