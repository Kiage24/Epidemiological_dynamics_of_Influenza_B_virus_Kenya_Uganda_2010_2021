library(readr)
library(dplyr)
library(Biostrings)
library(phylotools)
library(tidyr)
library(readxl)

# Read in the results excel sheet
flub_df <- read_xlsx("~/Downloads/flub_facility.xlsx")
flub_df$sample_id <- gsub("A50115", "A50015", flub_df$sample_id)

#Read in the concatenated sequences

NA. <- readDNAStringSet("~/Desktop/Msc/flub_results/concatenated/NA_concat.fasta")
NA_df <- as.data.frame(NA.)
HA <- readDNAStringSet("~/Desktop/Msc/flub_results/concatenated/HA_concat.fasta")
HA_df <- as.data.frame(HA)
PB1 <- readDNAStringSet("~/Desktop/Msc/flub_results/concatenated/PB1_concat.fasta")
PB1_df <- as.data.frame(PB1)
PB2 <- readDNAStringSet("~/Desktop/Msc/flub_results/concatenated/PB2_concat.fasta")
PB2_df <- as.data.frame(PB2)
PA <- readDNAStringSet("~/Desktop/Msc/flub_results/concatenated/PA_concat.fasta")
PA_df <- as.data.frame(PA)
NP <- readDNAStringSet("~/Desktop/Msc/flub_results/concatenated/NP_concat.fasta")
NP_df <- as.data.frame(NP)
MP <- readDNAStringSet("~/Desktop/Msc/flub_results/concatenated/MP_concat.fasta")
MP_df <- as.data.frame(MP)
NS <- readDNAStringSet("~/Desktop/Msc/flub_results/concatenated/NS_concat.fasta")
NS_df <- as.data.frame(NS)


#Extract the names of sequences and generate a dataframe

NA_names <- names(NA.)
NA_names_df <- as.data.frame(NA_names)
HA_names <- names(HA)
HA_names_df <- as.data.frame(HA_names)
PB1_names <- names(PB1)
PB1_names_df <- as.data.frame(PB1_names)
PB2_names <- names(PB2)
PB2_names_df <- as.data.frame(PB2_names)
PA_names <- names(PA)
PA_names_df <- as.data.frame(PA_names)
NP_names <- names(NP)
NP_names_df <- as.data.frame(NP_names)
MP_names <- names(MP)
MP_names_df <- as.data.frame(MP_names)
NS_names <- names(NS)
NS_names_df <- as.data.frame(NS_names)

#Bind the two dataframes

NS_df1 <- cbind(NS_names_df, NS_df)
colnames(NS_df1) <- c("sample_id", "sequences")

#Left join the two dataframes

NS_df1 <- merge(NS_df1,flub_df %>% select('sample_id','facility_name',"Collection_date"), by="sample_id", all.x=TRUE)


# Select the complete genomes for further analysis

completeNS <- read.delim("~/Desktop/Msc/flub_results/completeNS.txt", header = FALSE)
colnames(completeNS) <- "sample_id"

complete <-  read.delim("~/Desktop/Msc/flub_results/complete.txt", header = FALSE)
colnames(complete) <- "sample_id"

NS_df1 <- subset(NS_df1, sample_id %in% completeNS$sample_id)
NS_df2 <- subset(NS_df1, !(sample_id %in% complete$sample_id))



#Unite the columns into the header

NS_df2 <- unite(NS_df2, phylogeny_name, c(sample_id,facility_name,Collection_date), sep = '|')

# Write the outputs to a fasta file

writeFasta<-function(data, filename){
  fastaLines = c()
  for (rowNum in 1:nrow(data)){
    fastaLines = c(fastaLines, as.character(paste(">", data[rowNum,"phylogeny_name"], sep = "")))
    fastaLines = c(fastaLines,as.character(data[rowNum,"sequences"]))
  }
  fileConn<-file(filename)
  writeLines(fastaLines, fileConn)
  close(fileConn)
}

writeFasta(NS_df2, '~/Desktop/Msc/flub_results/renamed/NS_renamed_complete.fa')

