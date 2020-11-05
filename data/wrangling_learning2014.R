#2020-11-05
#Léon Mercier
#script to create the learning2014 dataset

#load the dplyr library (for select())
library(dplyr)

#learning2014 <- read.csv("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = TRUE, sep = "\t")

# dim() shows the dimensions of the data i.e. the number of rows and columns, which correspond in this case to subjects and variables
dim(learning2014)

# str() shows teh structure of the data i.e. the type of each variable with a little sample of the values
str(learning2014)

# create vectors containing the variable names of questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06", "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
# we need to use all_of() to get the variable names out of the character vector
# select() will also understand plain variable names, but this is more convenient
deep_columns <- select(learning2014, all_of(deep_questions))

# create column 'deep' by averaging, this ensures that the variables stay in the original scale
learning2014$deep <- rowMeans(deep_columns)

# then we do the same for surface learning and strategic learning
surface_columns <- select(learning2014, all_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)
strategic_columns <- select(learning2014, all_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

# we also need to scale some existing combination variables in the dataset
learning2014$attitude <- learning2014$Attitude / 10

#exclude subjects with zero points
learning2014 <- filter(learning2014, Points > 0)

#and finally we select the variables for our analysis
analysis_lrn2014 <- select(learning2014, gender, Age, attitude, deep, stra, surf, Points)

#and save the wrangled data in a file (by default write.csv creates row names)
write.csv(analysis_lrn2014, file = "data/learning2014.csv", row.names = FALSE)

#testing that we can read the data
test <- read.csv("data/learning2014.csv")
str(test)
#these commands give the same output, so we're OK
head(test)
head(analysis_lrn2014)
