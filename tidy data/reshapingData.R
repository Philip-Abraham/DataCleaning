## reshapingData

# Start with reshaping
library(reshape2)
head(mtcars)

# Melting data frames
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars=c("mpg","hp"))
head(carMelt,n=3)
tail(carMelt,n=3)

# Casting data frames
cylData <- dcast(carMelt, cyl ~ variable) ## the "variable" in the output counts the number of measures of rach row
cylData

cylData <- dcast(carMelt, cyl ~ variable,mean)
cylData

##Another dataset - InsectSprays
# Averaging values
head(InsectSprays)

tapply(InsectSprays$count,InsectSprays$spray,sum)

#Another way - split - U get a list
spIns =  split(InsectSprays$count,InsectSprays$spray)
spIns

#Another way - apply
sprCount = lapply(spIns,sum)
sprCount
#Another way - combine
unlist(sprCount)
#Or
sapply(spIns,sum)

# Another way - plyr package
library(plyr)
## ddply: Split data frame, apply function, and return results in a data frame.
ddply(InsectSprays, .(spray), plyr::summarize, sum = sum(count))

#Creating a new variable
spraySums <- ddply(InsectSprays,.(spray),plyr::summarize,sum=ave(count,FUN=sum))
dim(spraySums)
head(spraySums)
