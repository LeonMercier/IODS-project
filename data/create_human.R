# Léon Mercier
# 2020-11-26

library(tidyverse)

human <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt")

dim(human)
str(human)
summary(human)

human$GNI <- as.numeric(str_replace(human$GNI, pattern = ",", replacement = ""))

colKeep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

human <- dplyr::select(human, all_of(colKeep))

human <- filter(human, complete.cases(human))

#conveniently, the observations we want to exclude (regions) are situated at the last indices of the data frame
# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]

# add countries as rownames
rownames(human) <- human$Country
human <- select(human, -Country)

write_csv(human, "data/human.csv")
