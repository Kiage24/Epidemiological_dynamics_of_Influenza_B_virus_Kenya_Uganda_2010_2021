library(readxl)
library(dplyr)
library(tidyr)

run1_repeats <- read_excel("~/Downloads/run1_repeats.xlsx")
run3_all <- read_excel("~/Downloads/run_2_all.xlsx")

repeats3_df <- merge(x=run1_repeats,y=run3_all, 
             by=c("Sample_id"), all.x=TRUE)
repeats3_df <- repeats3_df %>% drop_na(`barcode number.y`)

repeats3_df$`barcode number.y` <- gsub("PB1_" , "", repeats3_df$`barcode number.y`)

write.csv(repeats3_df, "~/Desktop/Msc/data/repeats2.csv")

run23_nonrepeats <- read_excel("~/Downloads/run23_nonrepeats.xlsx")
run23_nonrepeats$`barcode number` <- gsub("_trimmed_sorted" , "", run23_nonrepeats$`barcode number`)
run3_nonrepeats <- run23_nonrepeats[80:102, ]

write.csv(run3_nonrepeats, "~/Desktop/Msc/data/run3_nonrepeats.csv")

