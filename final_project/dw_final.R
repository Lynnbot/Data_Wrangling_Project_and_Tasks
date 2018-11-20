#install.packages("RODBC")
library(RODBC)
library(tidyverse)
#set up a connect channel towards sql
con <- odbcConnect("dartmouth",
                 "ychen",
                 "ychen@qbs181")
#import table Demographics from sql
demographics <- sqlQuery(con, "select * from Demographics")
demographics

#import table Demographics from sql
chronic_conditions <- sqlQuery(con, "select * from ChronicConditions")
chronic_conditions

#import table Demographics from sql
text <- sqlQuery(con, "select * from Text")
text

#Merge three imported tables by their id
#and ensure that every ID have 1 record with the latest TextSentDate
wholesurvey <- demographics %>%
  merge(chronic_conditions, by.x = "contactid", by.y = "tri_patientid") %>%
  merge(text, by.x = "contactid", by.y = "tri_contactId") %>%
  group_by(contactid) %>%
  slice(which.max(TextSentDate))
wholesurvey


