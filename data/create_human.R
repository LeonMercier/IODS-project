# Léon Mercier
# 2020-11-26
# Original source of dataset: http://hdr.undp.org/en/content/human-development-index-hdi


#load libraries
library(tidyverse)

#read the data from the web
human <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt")

# This dataset created by the UN combines several indicators of human development. 
# The cases or rows represent countries or larger regions. Nearly all of the world's countries are represented. 
dim(human)
str(human)
summary(human)
# The columns represent the following measures
# HDI.Rank: 
# HDI: The Human Development Index; please see the original data source for more information
# Life.Exp: average life expencancy at birth in years
# Edu.Exp: Expected length of schooling in years
# Edu.Mean
# GNI: Gross National Income per capita         
# GNI.Minus.Rank
# GII.Rank
# GII
# Mat.Mor: Maternal mortality ratio
# Ado.Birth: Adolescent birth rate
# Parli.F: Proportion of Female representatives in parliament as percentage
# Edu2.F: Proportion of females with at least secondary education       
# Edu2.M: Proportion of males with at least secondary education
# Labo.F: Proportion of females in the labour force
# Labo.M: Proportion of males in the labour force
# Edu2.FM: Ratio of females to males having at least secondary education
# Labo.FM: Ratio of females to males in hte labour force

# GNI has been encoded with comma as thousands separator unlike other variables. 
# So it has been imported as a character string. We use str_replace() to change commas to nothing, effectively removing them.
# We then pass the result to as.nueric(), which converts it from character to numeric. 
# Finally we assign it to the GNI column of the data frame, overwriting the original data. 
human$GNI <- as.numeric(str_replace(human$GNI, pattern = ",", replacement = ""))

# We create a list of the columns that we want to keep for further analysis
colKeep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
# We use dplyr::select() with the all_of() helper function to select only the desired columns and overwrite human with them. 
human <- dplyr::select(human, all_of(colKeep))

# Then we remove incomplete cases. filter() is used to select rows. complete.cases() returns a vetor of logical values,
# where each TRUE value represents a row that has no missing data. filter() expects a logical expression so this works out. 
human <- filter(human, complete.cases(human))

# Conveniently, the observations we want to exclude (regions) are situated at the last indices of the data frame
# calculate the number of rows from the start that we want to keep
# literally number of rows in the data frame minus 7
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]

# add countries as rownames and then remove the Country column
# !c("Country") means "all variables except country"
# the minus sign used in DataCamp is not in the documentation of dplyr::select()
rownames(human) <- human$Country
human <- dplyr::select(human, !c("Country"))

write_csv(human, "data/human.csv")
