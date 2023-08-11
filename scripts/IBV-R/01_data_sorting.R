if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.16")

BiocManager::install("Biostrings")

library(Biostrings)
library(dplyr)
library(tidyr)

#Read in fasta file
GISAID_data <- readDNAStringSet("../../data/data/GISAID/Africa/gisaid_epiflu_sequence.fasta")
GISAID_data

#Create a dataframe containing the sequences
GISAID_df <- as.data.frame(GISAID_data)

#Extract the names of sequences and generate a dataframe
GISAID_names <- names(GISAID_data)
GISAID_names_df <- as.data.frame(GISAID_names)

#Bind the two dataframes together
GISAID_df <- cbind(GISAID_names_df,GISAID_df)
colnames(GISAID_df) <- c('GISAID_names','sequences')

#Remove duplicated entries
GISAID_df <- GISAID_df %>% distinct(GISAID_names, .keep_all = TRUE)

#Split the GISAID_names column
library(dplyr)
library(tidyr)

GISAID_df <- GISAID_df%>% separate(GISAID_names, c('isolate_name','isolate_id', 'collection_date', 'segment','lineage'), sep = '\\|')

#Read in the metadata
library(readxl)
GISAID_metadata <- read_xls('../../data/metadata/GISAID_metadata/Africa/Africa_gisaid_epiflu_isolates.xls')
colnames(GISAID_metadata) <- gsub('Isolate_Id', 'isolate_id', colnames(GISAID_metadata))

#subset the location column to obtain country 
gisaid_location <- GISAID_metadata$Location
gisaid_location <- as.data.frame(gisaid_location)
gisaid_location <- gisaid_location %>% separate(gisaid_location, c('continent', 'country'), sep = '/')

#Join the two dataframes
Country <- gisaid_location$country
GISAID_df <- cbind(Country,GISAID_df)

#Combine the columns to obtain the header
gisaid_combined <- unite(GISAID_df, gisaid_combined, c(isolate_id, Country, collection_date, segment,lineage), sep = '|')

#Remove sequences for influenza A 
gisaid_combined <- gisaid_combined %>% filter(grepl('^B', isolate_name))
unique(gisaid_combined$isolate_name)
gisaid_combined <- subset(gisaid_combined, select=c(-isolate_name))

#Convert back to fasta format
mtcars %>%
  group_by(cyl, vs) %>%
  summarise(cyl_n = n()) %>%
  group_vars()


