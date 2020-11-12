# Léon Mercier
# 2020-11-12
# Script for data wrangling, week 3 courseworks; Data source: https://archive.ics.uci.edu/ml/machine-learning-databases/00320/

library(tidyverse)

mat <- read.csv("data/student-mat.csv", sep = ";")
por <- read.csv("data/student-por.csv", sep = ";")

str(mat)
dim(mat)
str(por)
dim(por)

join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

joint <- inner_join(mat, por, suffix = c("mat", "por"), by = join_by)
str(joint)
dim(joint)

# create a new data frame with only the joined columns
alc <- select(joint, all_of(join_by))

notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(joint, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

alc <- mutate(alc, alc_use = (Dalc + Walc) /2  )
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

write_csv(alc, "data/alc.csv")
