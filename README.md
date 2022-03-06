This repository contains R code to extract events from two timelines of periods of the COVID-19 pandemic put together by the Senedd Research team into a table. The output can be found in the [output](output) directory.

As well as extracting the timelines' events into a more easily reused format, it does some basic cleaning of the underlying information - for example, it removes Microsoft Outlook SafeLinks wrappers and Google Analytics trackers from links in event descriptions.

# How-to

```r
devtools::load_all()

fifth_senedd_timeline <- fetch_timeline_from_url("https://research.senedd.wales/research-articles/coronavirus-timeline-welsh-and-uk-governments-response/")
sixth_senedd_timeline <- fetch_timeline_from_url("https://research.senedd.wales/research-articles/coronavirus-timeline-the-response-in-wales/")

sixth_senedd_timeline %>% bind_rows(fifth_senedd_timeline) %>% arrange(datestamp) %>% write_csv("output/two_timelines.csv")

```
