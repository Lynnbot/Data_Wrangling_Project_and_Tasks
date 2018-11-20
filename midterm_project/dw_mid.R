###################
###TITLE: QBS181 Midterm
###AUTHOR: Lynn Chen
###DATE: 25/10/2018
###DESCRIPTION: The major goal of this document is to perform data cleaning prior to further analysis.
###             Data comes from <https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/DIQ_I.htm#DIQ060U>.
###################

#Initial set up
setwd("~/Documents/2018FALL_Class/R/Data Wrangling/")
library(tidyverse)
library(foreign)
rawdat <- read.xport(file = "DIQ_I.XPT")
str(rawdat)

#Data cleaning starts here.
#STEP1: remove uninformative observations
# Observations who were reported as neither a diabetes nor a pre-diatbetes are regarded uninformative.
dat <- filter(rawdat, DIQ010 != 9)
summary(dat)



#STEP2: Substitute NA with "null" in categorical variables, NA with 888 in continuous variables.
continuous.var <- c("DID040", "DID060", "DID250", "DID260", "DIQ280", "DIQ300S", "DIQ300D", "DID310S", "DID310D", "DID320", "DID330", "DID341", "DID350")
categorical.var <- c("DIQ010", "DIQ160", "DIQ170", "DIQ172", "DIQ175A",
                     "DIQ175B", "DIQ175C","DIQ175D","DIQ175E" ,"DIQ175F" ,"DIQ175G",
                     "DIQ175H" ,"DIQ175I" ,"DIQ175J" , "DIQ175K","DIQ175L","DIQ175M",
                     "DIQ175N","DIQ175O","DIQ175P","DIQ175Q","DIQ175R","DIQ175S",
                     "DIQ175T","DIQ175U","DIQ175V","DIQ175W","DIQ175X","DIQ180",
                     "DIQ050","DIQ060U", "DIQ070","DIQ230","DIQ240",
                     "DIQ260U","DIQ275","DIQ291","DIQ350U","DIQ360","DIQ080")


for (i in categorical.var){
  column <- dat[,i]
  column[is.na(column)] <- "null"
  dat[,i] <- column
}


for (i in continuous.var){
  column <- dat[,i]
  column[is.na(column)] <- 888
  dat[,i] <- column
}




#STEP3: coerce categorical variables into factors.
for (i in categorical.var){
  dat[,i] <- as.factor(dat[,i])
  print(i)
}

str(dat)
summary(dat)


# STEP4:  Unify units
# Unify units of DID060 as "Months"
for (i in 1:length(dat$DIQ060U)) {
    if (dat$DIQ060U[i] == 2) {dat$DID060[i] <- dat$DID060[i]*12}
}

# Unify units of DID260 as "per week"
for (i in 1:length(dat$DID260)){
  if (dat$DIQ260U[i] == 1) dat$DID260[i] <- dat$DID260[i] * 7
  if (dat$DIQ260U[i] == 3) dat$DID260[i] <- dat$DID260[i] / 4
  if (dat$DIQ260U[i] == 4) dat$DID260[i] <- dat$DID260[i] / 52
}



#STEP5: Substitute values for its interpretation and change column names.

# 5.1 Substitute values
levels(dat$DIQ010)[1] <- "Yes"
levels(dat$DIQ010)[2] <- "No"
levels(dat$DIQ010)[3] <- "Borderline"


levels(dat$DIQ160)[1] <- "Yes"
levels(dat$DIQ160)[2] <- "No"
levels(dat$DIQ160)[3] <- "Do not know"

levels(dat$DIQ170)[1] <- "Yes"
levels(dat$DIQ170)[2] <- "No"
levels(dat$DIQ170)[3] <- "Do not know"

levels(dat$DIQ172)[1] <- "Yes"
levels(dat$DIQ172)[2] <- "No"
levels(dat$DIQ172)[3] <- "Refused"
levels(dat$DIQ172)[4] <- "Do not know"

levels(dat$DIQ175A)[1] <- "Family history"
levels(dat$DIQ175B)[1] <- "Overwight"
levels(dat$DIQ175C)[1] <- "Age"
levels(dat$DIQ175D)[1] <- "Poor diet"
#Codes for variables DIQ175E to DIQ175W are similar and thus omitted.
levels(dat$DIQ175X)[1] <- "Polycystic ovarian syndrome"

levels(dat$DIQ180)[1] <- "Yes"
levels(dat$DIQ180)[2] <- "No"
levels(dat$DIQ180)[3] <- "Refused"
levels(dat$DIQ180)[4] <- "Do not know"

levels(dat$DIQ050)[1] <- "Yes"
levels(dat$DIQ050)[2] <- "No"
levels(dat$DIQ050)[3] <- "Refused"
levels(dat$DIQ050)[4] <- "Do not know"


# 5.2 Change column names
colnames(dat) <- c("Respondent sequence number", "Doctor told you have diabetes", "Age when first told you had diabetes",
                   "Ever told you have prediabetes", "Ever told have health risk for diabetes", 
                   "Feel could be at risk for diabetes", "Family history", "Overweight", "Age", 
                   "Poor diet", "Race", "Had a baby weighed over 9 lbs. at birth", "Lack of physical activity", 
                   "High blood pressure", "High blood sugar", "High cholesterol", "Hypoglycemic", 
                   "Extreme hunger", "Tingling/numbness in hands or feet", "Blurred vision", "Increased fatigue",
                   "Anyone could be at risk", "Doctor warning", "Other, specify", "Gestational diabetes",
                   "Frequent urination", "Thirst", "Craving for sweet/eating a lot of sugar", "Medication",
                   "Polycystic ovarian syndrome", "Had blood tested past three years", "Taking insulin now",
                   "How long taking insulin", "Unit of measure (month/year)", "Take diabetic pills to lower blood sugar",
                   "How long ago saw a diabetes specialist", "Is there one Dr you see for diabetes",
                   "Past year how many times seen doctor", "How often check blood for glucose/sugar",
                   "Unit of measure (day/week/month/year)", "Past year Dr checked for A1C", "What was your last A1C level",
                   "What does Dr say A1C should be","What was your recent SBP", "What was your recent DBP", 
                   "What does Dr say SBP should be", "What does Dr say DBP should be", "What was most recent LDL number", 
                   "What does Dr say LDL should be", "Past year times Dr check feet for sores", 
                   "How often do you check your feet", "Unit of measure (day/week/month/year)", 
                   "Last time had pupils dilated for exam", "Diabetes affected eyes/had retinopathy")



head(dat)
write.csv(dat, file = "chen_dw_midterm.csv")

#STEP5: Varification
summary(dat)



