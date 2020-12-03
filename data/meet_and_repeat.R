library(tidyverse)

bprs <- read_delim("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", delim = " ")
rats <- read_delim("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", delim = "\t", col_types = "ciiiiiiiiiiiii", col_names = FALSE, skip = 1)
colnames(rats) <- c("WHAT?!", "ID",	"Group",	"WD1",	"WD8",	"WD15",	"WD22",	"WD29",	"WD36",	"WD43",	"WD44",	"WD50",	"WD57",	"WD64")
rats <- select(rats, !'WHAT?!')

bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)
rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)

# Convert to long form
bprsL <- gather(bprs, key = "Week", value = "Score", -treatment, -subject)
bprsL <- mutate(bprsL, week = as.integer(substr(Week, 5,5)))

ratsL <- gather(rats, key = "Time", value = "Weight", -ID, -Group)
ratsL <- mutate(ratsL, time = as.integer(substr(Time, 3,4)))

write_csv(bprs, "data/bprs.csv")
write_csv(rats, "data/rats.csv")