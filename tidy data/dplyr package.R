## Managing data frames with dplyr package - Basic tools

# Step 1: download data and load data into R

library(dplyr)

# download data and load data into R
fileUrl <- "https://raw.github.com/DataScienceSpecialization/courses/master/03_GettingData/dplyr/chicago.rds"
if(!file.exists("./chicagoPol")) dir.create("./chicagoPol")
download.file(fileUrl, destfile = "./chicagoPol/chicago.rds", mode = "wb")
chicago <- readRDS("./chicagoPol/chicago.Rds")

# Step 2: Summary statistics
dim(chicago)
str(chicago)
names(chicago)

# Step 3: Select columns using select command.
head(select(chicago, city:dptp))
head(select(chicago, -(city:dptp)))

# Equivalent base R operation to produce same results as Step 3 requires more steps
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[, -(i:j)])

# Step 4: Select rows using filter command.
chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f, 3)
chic.f <- filter(chicago, pm25tmean2 >30 & tmpd > 80)
head(chic.f, 3)

# Step 5: Reorder data frame using arrange command.
chicago <- arrange(chicago, date)
head(chicago, 2)
tail(chicago, 2)

chicago <- arrange(chicago, desc(date)) # arrange in descending order
head(chicago, 2)
tail(chicago, 2)

# Step 6: Rename variables using rename command.
chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)
head(chicago, 3)

# Step 7: Adding new variable using mutate command.
chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(select(chicago, pm25, pm25detrend), 3)

# Step 8: group_by Generating summary statistics by stratum.
chicago <- mutate(chicago, tempcat = factor(1*(tmpd >80), labels = c("cold", "hot")))
hotcold <- group_by(chicago, tempcat)
head(hotcold)
summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago, year)
summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# .Step 9: Making chain command using %>% command.
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), mo2 = median(no2tmean2))
# =
summarize(group_by(mutate(chicago, month = as.POSIXlt(date)$mon+1), month), pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), mo2 = median(no2tmean2))


