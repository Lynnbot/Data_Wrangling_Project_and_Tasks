##################################
library(tidyverse)
dim(table2)
# 1. Compute the rate for table2
## 1.a
case <- table2 %>%
  filter(type == "cases")
## 1.b
whole.pop <- table2 %>%
  filter(type == "population")
## 1.c
rate1 <- cbind(case[1:2], rate = (case[,4]/whole.pop[,4])*1e4)
## 1.d
colnames(rate1)[3] <- "IR per 10,000 person"
rate1

# 1. Compute the rate for table4a +table4b
rate2 <- data_frame("1999" = rep(0,3), "2000" = 1)
rate2[1] <- (table4a[2]/table4b[2])*1e4
rate2[2] <- (table4a[3]/table4b[3])*1e4
rate2 %>%
  setNames(c("1999", "2000"))%>%
  cbind(table4a[1],.)
##################################

##################################
#2.
table4a %>% gather("1999","2000",key="year",value="cases")
##################################

##################################
#3.
#install.packages("nycflights13")
install.packages("lubridate")
library(nycflights13)
library(lubridate)
rawdat <- nycflights13::flights
summary(flights$month) #1-12
summary(flights$day) #1-31
summary(flights$sched_dep_time) #24H


## 3.a
flights.in.day <- flights %>%
  group_by(month, day) %>%
  count() 

par(mgp = c(2.5,1,0), cex = .8, mar = c(4,4,5,1))
plot(1:365, flights.in.day$n, type = "s", col = "skyblue3", lwd = 1.5,
     main = "Flights Times Fluctuation in NYC Airport, 2013",
     xlab = "Days", ylab = "Flights Departed from NYC")


#Zoom in on time scale for better visualization.
flights.in.Jan <- flights %>%
  filter(month == 1) %>%
  group_by(month, day) %>%
  count() 

par(mgp = c(2.5,1,0), cex = .8, mar = c(4,4,5,1))
plot(1:31,flights.in.Jan$n, type = "s", lwd = 2,
     main = "Flights Times Fluctuation in Juanuary, 2013",
     xlab = "Days", ylab = "Flights Departed from NYC")
segments(c(7,14,21,28),0,c(7,14,21,28),1200, col=2, lty = 2)


## 3.b
### Filter out the records with missing values in dep_time, sched_dep_time or dep_delay
fl <- flights %>%
  filter(!is.na(dep_time)) %>%
  filter(!is.na(sched_dep_time)) %>%
  filter(!is.na(dep_delay)) 

### Formatting the month, day, dep_time & sched_dep_time
fl$month <- sprintf("%02d", fl$month)
fl$day <- sprintf("%02d", fl$day)
fl$dep_time <- sprintf("%04d", fl$dep_time)
fl$sched_dep_time <- sprintf("%04d", fl$sched_dep_time)

fl_dt <- fl %>%
  mutate(dep_time = make_datetime(year, month, day, dep_time))



fl <- fl %>%
  mutate(dep_time_2 = paste(month, day, dep_time, sep = ",")) %>%
  mutate(sched_dep_time_2 = paste(month, day, sched_dep_time, sep = ","))
head(fl$dep_time_2); head(fl$sched_dep_time_2)

dep.time <- as.POSIXlt(fl$dep_time_2, format = "%m,%d,%H%M")
sched.dep.time <- as.POSIXlt(fl$sched_dep_time_2, format = "%m,%d,%H%M")

fl[152,]
fl[839:844,]

consistency <- rep(0, nrow(fl))
consistency[difftime(dep.time, sched.dep.time, units = c("mins")) == fl$dep_delay] <- 1

fl[which(consistency == 0),]


## 3.c
fl %>%
  filter(!is.na(dep_delay)) %>%
  filter(dep_delay %in% seq(-20,-30,-1)) %>%
  filter(dep_delay %in% seq(-50,-60,-1))
############################################

# 4.
library(rvest)
qbs <-  read_html("https://geiselmed.dartmouth.edu/qbs/")
head(qbs)

h1_text <- qbs %>% html_nodes("h1") %>%html_text()
h2_text <- qbs %>% html_nodes("h2") %>%html_text()
length(h2_text)
h3_text <- qbs %>% html_nodes("h3") %>%html_text()
h4_text <- qbs %>% html_nodes("h4") %>%html_text()
p_nodes <- qbs %>%html_nodes("p")
p_nodes[1:6]
p_text <- qbs %>% html_nodes("p") %>%html_text()
length(p_text)

ul_text <- qbs %>% html_nodes("ul") %>%html_text()
length(ul_text)


upcoming_events <- matrix(1:6, nrow=2)
colnames(upcoming_events) <- c("Events_Title", "Time", "Description")
upcoming_events[,1] <- qbs %>%
  html_nodes(".feature-posts-list a") %>% 
  html_text()
upcoming_events[,2] <- qbs %>%
  html_nodes(".rss_snippet_date") %>% 
  html_text()
upcoming_events[,3] <- qbs %>%
  html_nodes(".rss_snippet_description") %>% 
  html_text()
tbl_df(upcoming_events)



###################

a <- ISOdate("12AM")
format(a, "%H%p")

as.POSIXct("2013,01,02,0730", format = "%Y,%m,%d,%H%M")
as.POSIXlt("2013,01,02,07,30", format = "%Y,%m,%d,%H,%M")
minute(rawdat$sched_dep_time, origin = "0000")

sprintf("%02d", c(1,2))


make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}
flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt[152,]
