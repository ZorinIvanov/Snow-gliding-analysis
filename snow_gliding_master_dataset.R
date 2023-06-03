library("padr")
library(dplyr)
library(data.table)

# Create cumulative global radiation for every day and merge the two stations 
station2 <- read.csv("aggregates_sta.csv",header=TRUE, sep=",")
station2$date <- as.Date(station2$Group.1, "%Y-%m-%d")  # convert the date as date format
station2[,"cum_rad"] <- cumsum(station2$Rad_mean.x)  # create a cumulative sum for the income radiation variable

station <- read.csv("aggregates.csv",header=TRUE, sep=",")
station$date <- as.Date(station$Group.1, "%Y-%m-%d")  # convert the date as date format
station <- pad(station)  # use the pad function from the padr library to fill any gaps in the datetime variable

head(station)
head(station2)

#write.csv(head(station), file = "station1_1.csv")
#write.csv(head(station2), file = "station2_1.csv")
# convert the data as data.tables and set a key on which we can merge them into a single dataset
setDT(station2)
setDT(station)
setkey(station2, date)
setkey(station, date)

master_dataset <- station2[station] #merge them into a single dataset

head(master_dataset)

#write.csv(head(master_dataset), file = "md_1.csv")

# function that reads the logger data, calculates a daily sum for each logger and gets the average for a fall line 
read_and_sum <- function(some_list, station_subset) {
  list_of_df <- list()
  
  for (x in some_list) {
    logger_name <- paste("logger", length(list_of_df) + 1, sep = "")
    column_name <- paste("logger", length(list_of_df) + 1, "_distance", sep = "")
    
    df <- read.csv(x, header = TRUE, sep = ";")
    df$date <- as.Date(df$Date, "%d.%m.%Y")
    setDT(df)  # we convert our data to data.tables
    
    list_of_df[[logger_name]] <- df[, list(column_name = sum(Distance)), by = date]  # sum the distance by date
  }
  # merge the logger and station datasets using the station dataset as a template
  setkey(station_subset, date)
  setkey(list_of_df$logger1, date)
  fall_line <- list_of_df$logger1[station_subset[,c("date")]]
  
  setkey(fall_line, date)
  for (x in list_of_df[2:length(list_of_df)]) {
    setkey(x, date)
    fall_line <- x[fall_line]
  }
  # the original data contained only datapoint during which gliding occured
  # since we merged the data and created datapoints for each day for the sake of homogeneity,
  # we get NA values for datapoints that we didn't have in the original logger fails
  # we know that no gliding occured for these datapoints so we convert NA values to 0
  for (i in 2:ncol(fall_line)) {
    col_name <- names(fall_line)[i]
    fall_line[is.na(get(col_name)), (col_name) := 0]
  }
  # we calculate the average of all loggers within a fall line
  fall_line$fall_line_mean <- rowMeans(fall_line[,2:ncol(fall_line)])
  fall_line_extract <- fall_line[, c("date","fall_line_mean")]
  
  return(fall_line_extract)
}


# create a list with the logger .csv files to be imported
list_of_loggers <- list("F1_15_16_043.csv",
                        "F1_15_16_192.csv",
                        "F1_15_16_199.csv",
                        "F1_15_16_203.csv",
                        "F1_15_16_330.csv")
# create a subset for the station data so we can have a homogenous data template
station_subset <- station %>% filter(date >= "2015-11-02" & date <= "2016-08-26")
# we load our data in the function and receive the average daily sum of loggers within a fall line 2015-16
fl1_15_16_mean <- read_and_sum(list_of_loggers, station_subset)

# we do the same for the other two fall lines of loggers
list_of_loggers <- list("F2_15_16_174.csv",
                        "F2_15_16_265.csv",
                        "F2_15_16_274.csv",
                        "F2_15_16_280.csv",
                        "F2_15_16_319.csv")

# fall line 2 mean 2015-16
fl2_15_16_mean <- read_and_sum(list_of_loggers, station_subset)

list_of_loggers <- list("F3_15_16_168.csv",
                        "F3_15_16_183.csv",
                        "F3_15_16_204.csv",
                        "F3_15_16_309.csv",
                        "F3_15_16_314.csv")

# fall line 3 mean 2015-16
fl3_15_16_mean <- read_and_sum(list_of_loggers, station_subset)


# create a subset for the station data for 2016-17
station_subset <- station %>% filter(date >= "2016-11-02" & date <= "2017-08-28")

# loggers for fall line 1 in 2016-17
list_of_loggers <- list("F1_16_17_330.csv",
                        "F1_16_17_301.csv",
                        "F1_16_17_183.csv",
                        "F1_16_17_091.csv",
                        "F1_16_17_103.csv",
                        "F1_16_17_295.csv")
# calculate the average daily sum for fall line 1 in 2016-17
fl1_16_17_mean <- read_and_sum(list_of_loggers, station_subset)

# loggers for fall line 2 in 2016-17
list_of_loggers <- list("F2_16_17_031.csv",
                        "F2_16_17_309.csv",
                        "F2_16_17_172.csv",
                        "F2_16_17_186.csv",
                        "F2_16_17_310.csv",
                        "F2_16_17_040.csv")
# calculate the average daily sum for fall line 2 in 2016-17
fl2_16_17_mean <- read_and_sum(list_of_loggers, station_subset)

# loggers for fall line 3 in 2016-17
list_of_loggers <- list("F3_16_17_294.csv",
                        "F3_16_17_102.csv",
                        "F3_16_17_167.csv",
                        "F3_16_17_184.csv",
                        "F3_16_17_278.csv")
# calculate the average daily sum for fall line 3 in 2016-17
fl3_16_17_mean <- read_and_sum(list_of_loggers, station_subset)


# create a subset for the station data for 2017-18
station_subset <- station %>% filter(date >= "2017-10-13" & date <= "2018-06-27")

# loggers for fall line 1 in 2017-18
list_of_loggers <- list("F1_17_18_167.csv",
                        "F1_17_18_186.csv",
                        "F1_17_18_031.csv",
                        "F1_17_18_091.csv",
                        "F1_17_18_294.csv")
# calculate the average daily sum for fall line 1 in 2017-18
fl1_17_18_mean <- read_and_sum(list_of_loggers, station_subset)

# loggers for fall line 2 in 2017-18
list_of_loggers <- list("F2_17_18_183.csv",
                        "F2_17_18_185.csv",
                        "F2_17_18_043.csv",
                        "F2_17_18_102.csv",
                        "F2_17_18_172.csv")
# calculate the average daily sum for fall line 2 in 2017-18
fl2_17_18_mean <- read_and_sum(list_of_loggers, station_subset)

# loggers for fall line 3 in 2017-18
list_of_loggers <- list("F3_17_18_174.csv",
                        "F3_17_18_330.csv",
                        "F3_17_18_103.csv",
                        "F3_17_18_195.csv")
# calculate the average daily sum for fall line 3 in 2017-18
fl3_17_18_mean <- read_and_sum(list_of_loggers, station_subset)


# create a subset for the station data for 2018-19
station_subset <- station %>% filter(date >= "2018-10-18" & date <= "2019-09-16")

# loggers for fall line 1 in 2018-19
list_of_loggers <- list("F1_18_19_199.csv",
                        "F1_18_19_192.csv",
                        "F1_18_19_274.csv",
                        "F1_18_19_314.csv")
# calculate the average daily sum for fall line 1 in 2018-19
fl1_18_19_mean <- read_and_sum(list_of_loggers, station_subset)

# loggers for fall line 2 in 2018-19
list_of_loggers <- list("F2_18_19_106.csv",
                        "F2_18_19_309.csv",
                        "F2_18_19_302.csv",
                        "F2_18_19_295.csv",
                        "F2_18_19_203.csv")
# calculate the average daily sum for fall line 2 in 2018-19
fl2_18_19_mean <- read_and_sum(list_of_loggers, station_subset)

# loggers for fall line 3 in 2018-19
list_of_loggers <- list("F3_18_19_278.csv",
                        "F3_18_19_294.csv",
                        "F3_18_19_184.csv",
                        "F3_18_19_102.csv",
                        "F3_18_19_319.csv")
# calculate the average daily sum for fall line 3 in 2018-19
fl3_18_19_mean <- read_and_sum(list_of_loggers, station_subset)

# merge the loggers by fall line 
fl1 <- rbind(fl1_15_16_mean, fl1_16_17_mean, fl1_17_18_mean, fl1_18_19_mean)
names(fl1) <- c("date", "fl1_mean")

fl2 <- rbind(fl2_15_16_mean, fl2_16_17_mean, fl2_17_18_mean, fl2_18_19_mean)
names(fl2) <- c("date", "fl2_mean")

fl3 <- rbind(fl3_15_16_mean, fl3_16_17_mean, fl3_17_18_mean, fl3_18_19_mean)
names(fl3) <- c("date", "fl3_mean")

#merge them into the big dataset
setkey(fl1, date)
setkey(fl2, date)
setkey(fl3, date)
setkey(master_dataset, date)

master_dataset <- fl1 [master_dataset]
master_dataset <- fl2 [master_dataset]
master_dataset <- fl3 [master_dataset]

# create the mean of means of the fall lines
master_dataset$fl_mean <- rowMeans(master_dataset[,c(2,3,4)])

#write.csv(slice(master_dataset, 1110:1120), file = "md_2.csv")


# Import the Soil Moisture and Temp data
brown15 <- read.csv("brown2015_agg.csv",header=TRUE, sep=",")
brown16 <- read.csv("brown2016_agg.csv",header=TRUE, sep=",")
brown17 <- read.csv("brown2017_agg.csv",header=TRUE, sep=",")
brown1718 <- read.csv("brown1718_agg.csv",header=TRUE, sep=",")
brown18ab <- read.csv("brown2018abbau_agg.csv",header=TRUE, sep=",")
brown18auf <- read.csv("brown2018aufbau_agg.csv",header=TRUE, sep=",")
brown <- rbind(brown15, brown16, brown17, brown1718, brown18auf, brown18ab)  # merge the yearly data
names(brown) <- c("X","date","ST5_mean_brown","ST1.5_mean_brown","ST0_mean_brown","ST10_mean_brown")
brown <- brown[-c(515, 608, 835), ]  # remove double measurements
brown <- select(brown, -X)
brown$date <- as.Date(brown$date, format = "%Y-%m-%d")

gelb15 <- read.csv("gelb2015_agg.csv",header=TRUE, sep=",")
gelb16 <- read.csv("gelb2016_agg.csv",header=TRUE, sep=",")
gelb17 <- read.csv("gelb2017_agg.csv",header=TRUE, sep=",")
gelb1718 <- read.csv("gelb1718_agg.csv",header=TRUE, sep=",")
gelb18ab <- read.csv("gelb2018abbau_agg.csv",header=TRUE, sep=",")
gelb18auf <- read.csv("gelb2018aufbau_agg.csv",header=TRUE, sep=",")
gelb <- rbind(gelb15, gelb16, gelb17, gelb1718, gelb18auf, gelb18ab)  # merge the yearly data
names(gelb) <- c("X","date","SWC1.5_mean_gelb","SWC0_mean_gelb","SWC10_mean_gelb","SWC5_mean_gelb")
gelb <- gelb[-c(515, 608, 843,979), ]  # remove double measurements
gelb <- select(gelb, -X)
gelb$date <- as.Date(gelb$date, format = "%Y-%m-%d")

orange15 <- read.csv("orange2015_agg.csv",header=TRUE, sep=",")
orange16 <- read.csv("orange2016_agg.csv",header=TRUE, sep=",")
orange17 <- read.csv("orange2017_agg.csv",header=TRUE, sep=",")
orange1718 <- read.csv("orange1718_agg.csv",header=TRUE, sep=",")
orange18ab <- read.csv("orange2018abbau_agg.csv",header=TRUE, sep=",")
orange18auf <- read.csv("orange2018aufbau_agg.csv",header=TRUE, sep=",")
orange <- rbind(orange15, orange16, orange17, orange1718, orange18auf, orange18ab)  # merge the yearly data
names(orange) <- c("X","date","SWC5_mean_orange","SWC1.5_mean_orange","SWC0_mean_orange","SWC10_mean_orange")
orange <-orange[-c(515, 608, 843,979), ]  # remove double measurements
orange <- select(orange, -X)
orange$date <- as.Date(orange$date, format = "%Y-%m-%d")

lila15 <- read.csv("lila2015_agg.csv",header=TRUE, sep=",")
lila16 <- read.csv("lila2016_agg.csv",header=TRUE, sep=",")
lila17 <- read.csv("lila2017_agg.csv",header=TRUE, sep=",")
lila1718 <- read.csv("lila1718_agg.csv",header=TRUE, sep=",")
lila18ab <- read.csv("lila2018abbau_agg.csv",header=TRUE, sep=",")
lila18auf <- read.csv("lila2018aufbau_agg.csv",header=TRUE, sep=",")
lila <- rbind(lila15, lila16, lila17, lila1718, lila18auf, lila18ab)  # merge the yearly data
names(lila) <- c("X","date","ST10_mean_lila","ST5_mean_lila","ST1.5_mean_lila","ST0_mean_lila")
lila <- lila[-c(515), ]  # remove double measurements
lila <- select(lila, -X )
lila$date <- as.Date(lila$date, format = "%Y-%m-%d")

# add the soil data to the master_dataset
setDT(brown)
setDT(gelb)
setDT(orange)
setDT(lila)

setkey(brown, date)
setkey(gelb, date)
setkey(orange, date)
setkey(lila, date)

master_dataset <- brown [master_dataset]
master_dataset <- gelb [master_dataset]
master_dataset <- orange [master_dataset]
master_dataset <- lila [master_dataset]

# leave out unimportant variables
master_dataset <- subset(master_dataset, select = -c(X,
                                                     Group.1,
                                                     i.X,
                                                     i.Group.1,
                                                     SH_max.x,
                                                     SH_min.x,
                                                     SH_sd.x,
                                                     SH_max.Max_snowheight,
                                                     SH_min.Min_snowheight,
                                                     SH_sd.SD_snowheight,
                                                     TS_0_mean.Mean_t_snow_0cm,
                                                     TS_0_max.Max_t_snow_0cm,
                                                     TS_0_min.Min_t_snow_0cm,
                                                     TS_0_sd.SD_t_snow_0cm,
                                                     TS_5_mean.Mean_t_snow_5cm,
                                                     TS_5_max.Max_t_snow_5cm,
                                                     TS_5_min.Min_t_snow_5cm,
                                                     TS_5_sd.SD_t_snow_5cm,
                                                     TS_50_mean.Mean_t_snow_50cm,
                                                     TS_50_max.Max_t_snow_50cm,
                                                     TS_50_min.Min_t_snow_50cm,
                                                     TS_50_sd.SD_t_snow_50cm,
                                                     TS_100_mean.Mean_t_snow_100cm,
                                                     TS_100_max.Max_t_snow_100cm,
                                                     TS_100_min.Min_t_snow_100cm,
                                                     TS_100_sd.SD_t_snow_100cm,
                                                     IC_mean.Mean_ice_content,
                                                     IC_max.Max_ice_content,
                                                     IC_min.Min_ice_content,
                                                     IC_sd.SD_ice_content,
                                                     SD_mean.Mean_snow_density,
                                                     SD_max.Max_snow_density,
                                                     SD_min.Min_snow_density,
                                                     SD_sd.SD_snow_density
))

# give variables meaningful names
names(master_dataset) <- c("date",
                           "ST10_mean_lila",
                           "ST5_mean_lila",
                           "ST1.5_mean_lila",
                           "ST0_mean_lila",
                           "SWC5_mean_orange",
                           "SWC1.5_mean_orange",
                           "SWC0_mean_orange",
                           "SWC10_mean_orange",
                           "SWC1.5_mean_gelb",
                           "SWC0_mean_gelb",
                           "SWC10_mean_gelb",
                           "SWC5_mean_gelb",
                           "ST5_mean_brown",
                           "ST1.5_mean_brown",
                           "ST0_mean_brown",
                           "ST10_mean_brown",
                           "fl3_mean",
                           "fl2_mean",
                           "fl1_mean",
                           "snowheight_mean_north",
                           "air_temperature_mean_north",
                           "air_temperature_max_north",
                           "air_temperature_min_north",
                           "air_temperature_sd_north",
                           "rad_mean_north",
                           "rad_max_north",
                           "rad_min_north",
                           "rad_sd_north",
                           "precipitation_mean_north",
                           "precipitation_max_north",
                           "precipitation_min_north",
                           "precipitation_sd_north",
                           "precipitation_sum_north",
                           "radiation_cum",
                           "snowheight_mean_sma",
                           "water_content_mean_sma",
                           "water_content_max_sma",
                           "water_content_min_sma",
                           "water_content_sd_sma",
                           "fl_mean"
)


# import precipitation data for the schmittenhoehe station (the precip data used in the analysis)

precipitation <- read.csv("Precipitation.csv",header=TRUE, sep=",")

# fix the date format
precipitation$datum1 = substr(precipitation$datum,1,nchar(precipitation$datum)-2)
precipitation$date <- as.Date(precipitation$datum1, "%Y%m%d")

as.numeric(as.character(precipitation$RSX))
# values of -8888 are erroneous, thus are converted to NA
precipitation[precipitation == -8888] <- NA

# convert the data to data.table
setDT(precipitation)

# create a daily average precipitation values and add it to the master_dataset
precipitation_mean <- precipitation[ ,.( precipitation_mean = mean(RSX, na.rm = T)), by = date]
setDT(precipitation_mean)
setkey(precipitation_mean, date)
master_dataset <- precipitation_mean[master_dataset]

# create a daily sum precipitation values and add it to the master_dataset
precipitation_sum <- precipitation[ ,.( precipitation_sum = sum(RSX, na.rm = T)), by = date]
setDT(precipitation_sum)
setkey(precipitation_sum, date)
master_dataset <- precipitation_sum[master_dataset]

# import the snow pillows data, calculate the daily average and sum and add it to the master_dataset
MyD <- read.csv("STA(created from original).csv",header=TRUE, sep=";")

MyD$date <- as.Date(MyD$Datetime, "%d.%m.%Y")

setDT(MyD)

snow_pillows_mean <- MyD[ ,.(schneekissen_mean = mean(Schneekissen, na.rm = T)), by = date]
setDT(snow_pillows_mean)
setkey(snow_pillows_mean, date)
master_dataset <- snow_pillows_mean[master_dataset]

snow_pillows_sum <- MyD[ ,.(schneekissen_sum = sum(Schneekissen, na.rm = T)), by = date]
setDT(snow_pillows_sum)
setkey(snow_pillows_sum, date)
master_dataset <- snow_pillows_sum[master_dataset]


# global radiation daily sum
sum_rad <- MyD[ ,.(sum_rad = sum(Globalstrahlung.refl., na.rm = T)), by = date]
setDT(sum_rad)
setkey(master_dataset, date)
setkey(sum_rad, date)
master_dataset <- sum_rad [master_dataset]
#write.csv(slice(master_dataset, 1110:1120), file = "md_2.csv")

# remove every object except the master_dataset from the environment
all_vars <- ls()
keep_var <- "master_dataset"
remove_vars <- setdiff(all_vars, keep_var)
rm(list = remove_vars)


# determine when permanent snow cover is established each season (14 consecutive days with > 10cm snow)
# run length encoding for a logical vector where everything above 10 is True.
runs <- rle(master_dataset$snowheight_mean_north > 10)

true_runs_indexes <- which(runs$values)  # find the indexes of all >10 (True) runs
row <- cumsum(runs$lengths)  # create cumulative sum of len to access the end position of every run

# find the start and end date of all >10 (True) runs
start <- master_dataset$date[row[true_runs_indexes] - runs$lengths[true_runs_indexes] + 1]
end <- master_dataset$date[row[true_runs_indexes]]

# create a output dataframe containing the gap of all true runs
output <- data.frame (start_row = row[true_runs_indexes] - runs$lengths[true_runs_indexes] + 1, 
                      end_row = row[true_runs_indexes],
                      start_time = start, 
                      end_time = end,
                      gap = (row[true_runs_indexes] - (row[true_runs_indexes] - runs$lengths[true_runs_indexes] + 1)) + 1)


output$start_time <- as.Date(output$start_time)  # Convert factor to Date

# create a vector that holds the start time of every winter season for the seasons to be analyzed
output <- output[which(output$gap >= 14 &
                         output$start_time > "2015-01-01" &
                         output$start_time < "2019-01-01"), "start_time"]