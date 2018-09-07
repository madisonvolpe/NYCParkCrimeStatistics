```{r}

#Read in multiple xlsx files at once 
temp = list.files(pattern="*.xlsx")
library(openxlsx)
myfiles = lapply(temp, read.xlsx)
names(myfiles) <- temp


#Further clean each dataframe-remove top NA rows that originally had no data
for(i in 1:length(myfiles)){
myfiles[[i]] <- myfiles[[i]][!is.na(myfiles[[i]][2:12]),]
}

#Delete rows that have ALL NAs
for(i in 1:length(myfiles)){
myfiles[[i]] <- myfiles[[i]][rowSums(is.na(myfiles[[i]])) != ncol(myfiles[[i]]), ]
}

#Make 1st row the colnames of each dataframe in the list
for(i in 1:length(myfiles)){
colnames(myfiles[[i]]) <- myfiles[[i]][1, ]
myfiles[[i]]= myfiles[[i]][-1, ]    
}

#Add year column to each dataframe in list 
library(stringi)
temp <-gsub(".xlsx$","",temp)
Years <- stri_extract_last(regex="\\d{4}$", temp)

for(i in 1:length(myfiles)){
  if(grepl(pattern = Years[i], names(myfiles)[[i]])==TRUE){
    myfiles[[i]]["Year"] <- rep(Years[i], nrow(myfiles[[i]]))
  }
}

#Change murder colname in df(12) of list 
names(myfiles[[12]])[5] <- "MURDER"

#Rbind dataframes in list  into one dataframe
library(plyr)
Crime<-rbind.fill(myfiles)

#make colnames of Crime more user-friendly, replace spaces with periods
names(Crime)<-gsub("\\s", ".", names(Crime))

#view structure of crime 
str(Crime)

#making certain columns numeric
num.cols <- c("SIZE.(ACRES)", "MURDER", "RAPE", "ROBBERY", "FELONY.ASSAULT", "BURGLARY", "GRAND.LARCENY", "GRAND.LARCENY.OF.MOTOR.VEHICLE", "TOTAL")
Crime[num.cols] <- sapply(Crime[num.cols],as.numeric)

#write to csv
write.csv(Crime, "ParkCrimesMerged2015.2017.csv")
```

