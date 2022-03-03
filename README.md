```r
devtools::load_all()

fifth_senedd_timeline <- fetch_timeline_from_url("https://research.senedd.wales/research-articles/coronavirus-timeline-welsh-and-uk-governments-response/")
sixth_senedd_timeline <- fetch_timeline_from_url("https://research.senedd.wales/research-articles/coronavirus-timeline-the-response-in-wales/")

sixth_senedd_timeline %>% bind_rows(fifth_senedd_timeline) %>% arrange(datestamp) %>% write_csv("output/two_timelines.csv")


```