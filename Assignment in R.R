setwd("F:/CM-Groep/Cursussen/Data science/05_ReproducibleResearch/Week1/RepData_PeerAssessment1")
unzip("activity.zip")
data <- read.csv("activity.csv", colClasses = "character", na.strings="Not Available")
data$steps <- as.numeric(data$steps)

# question 2
data_aggregated_sum <- aggregate(data$steps, list(data$date), sum , na.rm=TRUE)
hist(data_aggregated_sum$x, main="Histogram of number of steps taken per day")

# question3
data_aggregated_summary <- aggregate(data$steps, list(data$date), summary , na.rm=TRUE)
data_aggregated_summary

#question 4 : Time series plot of the average number of steps taken
data_aggregated_mean <- aggregate(data$steps, list(data$date), mean , na.rm=TRUE)
plot(as.Date(data_aggregated_mean$Group.1), data_aggregated_mean$x, type = "l", xlab= "Date", ylab= "Mean number of steps per day")

# question5
data$date[[which.max(data$steps)]]
data$interval[[which.max(data$steps)]]

# question6: Code to describe and show a strategy for imputing missing data
tapply(is.na(data$steps), data$date, FUN=sum)
# Fill with mean for that interval
data_aggregated_interval <- aggregate(data$steps, list(data$interval), mean , na.rm=TRUE)
data_aggregated_interval$interval <- data_aggregated_interval$Group.1
imputed_data <- merge(data, data_aggregated_interval, by = "interval")
for(i in 1:nrow(imputed_data)) if(is.na(imputed_data[i,]$steps)) imputed_data[i,]$steps <- imputed_data[i,]$x

# question 7
imputed_data_sum <- aggregate(imputed_data$steps, list(imputed_data$date), sum , na.rm=TRUE)
hist(imputed_data_sum$x, main="Histogram of number of steps taken per day - imputed")

imputed_data_summary <- aggregate(imputed_data$steps, list(imputed_data$date), summary , na.rm=TRUE)
imputed_data_summary

#question 8 Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends
library(chron)
imputed_data$dow <- weekdays(as.Date(imputed_data$date),abbr = TRUE)
imputed_data$weekend = chron::is.weekend(imputed_data$date)

imputed_data_weekend <- aggregate(imputed_data$steps, list(imputed_data$weekend, imputed_data$interval), mean , na.rm=TRUE)
par(mfrow = c(1,2))
with(imputed_data_weekend[imputed_data_weekend$Group.1 == FALSE,], plot(imputed_data_weekend$Group.2, imputed_data_weekend$x, type = "l", ylab = 'Weekday Interval Means',xlab = 'Interval'))
with(imputed_data_weekend[imputed_data_weekend$Group.1 == TRUE,],  plot(imputed_data_weekend$Group.2, imputed_data_weekend$x, type = "l", ylab = 'Weekend Interval Means',xlab = 'Interval'))

