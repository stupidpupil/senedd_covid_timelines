fetch_timeline_from_url <- function(timeline_url, locale="en_GB.utf8"){

	timeline_html <- rvest::read_html(timeline_url)

	timeline_element <- timeline_html %>% html_element(".timeline")

	ret_tibble <- tibble()

	parse_timeline_content <- function(el) {
		original_lc_time_locale <- Sys.getlocale("LC_TIME")

		on.exit({
			Sys.setlocale("LC_TIME", original_lc_time_locale)
		})

		Sys.setlocale("LC_TIME", locale)

		title <- el %>% html_element("h2") %>% html_text()
		datestamp <- el %>% 
			html_element("h3") %>% html_text() %>% 
			stringr::str_replace("Juky", "July") %>% # Fix a spelling error
			strptime("%d %B %Y") %>% lubridate::as_date()

		links <- el %>% html_elements("a")

		purrr::walk(links, function(x){xml2::xml_attr(x, "href") <- un_outlook_protect_url(xml2::xml_attr(x, "href"))})

		content_html <- el %>% html_elements("p") %>% as.character() %>% paste(collapse="\n")

		return(list(title=title, datestamp=datestamp, content_html=content_html))
	}

	for (el in timeline_element %>% html_elements(".timeline-content")) {
		tlc <- parse_timeline_content(el)

		ret_tibble <- ret_tibble %>%
			bind_rows(as_tibble(tlc))
	}

	cymraeg_link <- timeline_html %>% html_node(xpath="//a[@id=\"languageSwitchButton\" and contains(@href,\"ymchwil\")]")

	if(!is.na(cymraeg_link)){
		cymraeg_tibble <- fetch_timeline_from_url(cymraeg_link %>% html_attr("href"), locale="cy_GB.utf8") %>% 
			rename_with(~str_c(., "_welsh"), everything()) %>%
			distinct()

		ret_tibble <- ret_tibble %>% 
			distinct() %>% bind_cols(cymraeg_tibble)
	}


	return(ret_tibble)
}