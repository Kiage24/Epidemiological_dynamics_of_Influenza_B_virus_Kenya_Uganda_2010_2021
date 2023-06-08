library(ggtree)

library(ape)

library(ggplot2)

library(dplyr)

library(tidyr)

library(phylotools)

library(dendextend)

library(phangorn)

library(dplyr)

library(treeio)

library(phytools)

library(dendextend)

library(cowplot)

# Read in the tree from file

HA_tree <- read.tree("~/Desktop/Msc/results/IRMA/iqtree_clean/HA_tree.nwk")

#Create a metadata file with the year and location column

metadata <- HA_tree$tip.label
metadata_df <- as.data.frame(metadata)
rownames(metadata_df) <- metadata

reference <- metadata_df[grepl("B/", metadata_df$metadata), ]
sample <- metadata_df <- metadata_df[!grepl("B/", metadata_df$metadata), ]

ref_df <- as.data.frame(reference)
colnames(ref_df) <- "sample"
sample_df <- as.data.frame(sample)
labels <- rbind(ref_df, sample_df)

references <- metadata_df[grepl("B/", metadata_df$metadata), ]
ref_df <- as.data.frame(references)
ref_df$references <- gsub("'", "", ref_df$references)
ref_df <- ref_df %>% separate(references, c("sample_id","Lineage", "segment", "clade","collection_date"), sep = "\\|")
ref_df <- ref_df %>% separate(collection_date, c("year", "month", "date"), sep = "-")
rownames(ref_df) <- references

samples <- metadata_df[!grepl("B/", metadata_df$metadata), ]
sample_df <- as.data.frame(samples)
sample_df$samples <- gsub("'", "", sample_df$samples)
sample_df <- sample_df %>% separate(samples, c("sample_id", "Location","collection_date"), sep = "\\|")
sample_df <- sample_df %>% separate(collection_date, c("year", "month", "date"), sep = "-")
rownames(sample_df) <- samples
 

mdata <- bind_rows(ref_df, sample_df)
mdata <- mdata[rownames(metadata_df), ]
mdata$label <- rownames(metadata_df)
mdata$Location <- ifelse(is.na(mdata$Location), "Unknown", mdata$Location)
mdata$Location <- as.factor(mdata$Location)

# Create the tree visualization with tip labels and color specific tips

HA_treeplot <- ggtree(HA_tree)
HA_treeplot <- HA_treeplot %<+% mdata +
               geom_tippoint(aes(color=Location), size=1) +
               scale_color_manual(values=c("skyblue1", "red2", "darkorchid3","olivedrab4","coral4","khaki3","maroon3","turquoise3","black")) # set the colors for each level of Location

HA_treeplot


HA_treeplot <- ggtree(HA_tree, size = 0.1) +

  geom_tippoint(size = 1, aes(color = ifelse(grepl("KCH", label), "KCH",
                                             
                                             ifelse(grepl("Matsangoni", label), "Matsangoni",
                                                    
                                                    ifelse(grepl("Ngerenya", label), "Ngerenya",
                                                           
                                                           ifelse(grepl("Mavueni", label), "Mavueni",   
                                                                  
                                                                  ifelse(grepl("Mtondia", label), "Mtondia",
                                                                         
                                                                         ifelse(grepl("Pingilikani", label), "Pingilikani",
                                                                                
                                                                                ifelse(grepl("Jinja", label), "Jinja",
                                                                                       
                                                                                       ifelse(grepl("Soroti", label), "Soroti",
                                                                                              
                                                                                              ifelse(grepl("Mbale", label), "Mbale", "Reference"))))))))))) +
  
  
  scale_color_manual(name = "Location",
                     
                     values = c("KCH" = "skyblue1", "Matsangoni" = "red2", "Mavueni"= "darkorchid3", "Mtondia" = "olivedrab4", "Pingilikani" = "coral4", "Jinja" = "khaki3", "Soroti" = "maroon3", "Mbale" = "orange")) 
  
  ggtitle("Phylogenetic tree of Influenza B HA segment") +
  
  theme(
    legend.title = element_text(    # defines font size and format of the legend title
      face = "bold",
      size = 16),  
    legend.key.size = unit(12, "pt"),
    legend.text=element_text(       # defines font size and format of the legend text
      face = "bold",
      size = 8),
    plot.title = element_text(      # defines font size and format of the plot title
      size = 12,
      face = "bold",
      hjust = 0.5),  
    legend.position = "right",     # defines placement of the legend
    legend.box = "vertical",        # defines placement of the legend
    legend.margin = margin())
  
HA_treeplot + theme_tree2()














HA_treeplot

HAtree_plot_data <- merge(mdata, data.frame(label = HA_tree$tip.label), by = "label")

# create the heatmap plot
heatmap_plot <- ggplot(HAtree_plot_data, aes(x = 1, y = label)) +
  geom_tile(aes(fill = year), width = 0.2, height = 0.6) + 
  #scale_fill_gradient(low = "white", high = "red") +
  theme_void()

# plot the tree and heatmap side by side
cowplot::plot_grid(HA_treeplot, heatmap_plot, ncol = 2, align = "v", rel_widths = c(2, 1))


HA_treeplot + geom_facet(panel = "year", data = mdata, geom = geom_col, 
                         aes(x = year, color = location, 
                             fill = location), orientation = 'y', width = .6) 
              
gheatmap(HA_treeplot, mdata, offset=8, width=0.6, 
         colnames=FALSE, legend_title="genotype") +
  scale_x_ggtree() + 
  scale_y_continuous(expand=c(0, 0.3))














HA_treeplot
gheatmap(HA_treeplot, c(ifelse(grepl("2010", HA_tree$label), "2010",
                             
                             ifelse(grepl("2011", HA_tree$label), "2011",
                                    
                                    ifelse(grepl("2012", HA_tree$label), "2012",
                                           
                                           ifelse(grepl("2013", HA_tree$label), "2013",   
                                                  
                                                  ifelse(grepl("2014", HA_tree$label), "2014",
                                                         
                                                         ifelse(grepl("2015", HA_tree$label), "2015",
                                                                
                                                                ifelse(grepl("2016", HA_tree$label), "2016",
                                                                       
                                                                       ifelse(grepl("2017", HA_tree$label), "2017",   
                                                                              
                                                                              ifelse(grepl("2018", HA_tree$label), "2018",
                                                                                     
                                                                                     ifelse(grepl("2019", HA_tree$label), "2019",
                                                                                            
                                                                                            ifelse(grepl("2020", HA_tree$label), "2020",
                                                                                                   
                                                                                                   ifelse(grepl("2021", HA_tree$label), "2021",   
                                                                                                          
                                                                                                          ifelse(grepl("2022", HA_tree$label), "2022", "NA")))))))))))))), offset=8, width=0.6,legend_title="genotype")

?geom_treescale
HA_treeplot
?geom_tree()
# Save the image to your local computer

ggsave("~/Desktop/Msc/plots/ns_tree.png",
       
       plot = NP_treeplot,
       
       dpi = 600,
       
       width = 14,
       
       height = 7)

#Plot tanglegrams of various trees

# Read in the tree from file

HA_tree <- read.tree("~/Desktop/Msc/results/IRMA/iqtree/HA_tree.nwk")
HA_tree$edge.length[HA_tree$edge.length<0] <-0 
HA_tree$edge.length
NS_tree <- read.tree("~/Desktop/Msc/results/IRMA/iqtree/NS3.nwk")


# Convert tree to ultrametric tree
leaf_distances <- cophenetic(HA_tree)
node_distances <- node.depth(HA_tree)
for (i in 1:HA_tree$Nnode) {
  if (!isTip(HA_tree, i)) {
    left_child <- HA_tree$edge[i,1]
    right_child <- HA_tree$edge[i,2]
    left_length <- leaf_distances[left_child] - node_distances[i]
    right_length <- leaf_distances[right_child] - node_distances[i]
    new_length <- mean(c(left_length, right_length))
    HA_tree$edge[i,3] <- node_distances[i] + new_length
  }
}

# Convert tree to ultrametric tree
leaf_distances <- cophenetic(NS_tree)
node_distances <- node.depth(NS_tree)
for (i in 1:NS_tree$Nnode) {
  if (!isTip(NS_tree, i)) {
    left_child <- NS_tree$edge[i,1]
    right_child <- NS_tree$edge[i,2]
    left_length <- leaf_distances[left_child] - node_distances[i]
    right_length <- leaf_distances[right_child] - node_distances[i]
    new_length <- mean(c(left_length, right_length))
    NS_tree$edge[i,3] <- node_distances[i] + new_length
  }
}

# Convert ultrametric tree to hclust object
HA_tree <- force.ultrametric(HA_tree)
#HA_labels <- HA_tree$tip.label
#HA_labels_df <- as.data.frame(HA_labels)
#HA_labels_df <- HA_labels_df %>% separate(HA_labels, c("id", "location"), sep="_") %>% 
                          # unite(HA_labels, c("id", "location"), sep="_")
#HA_tree$tip.label <- HA_labels_df$HA_labels
HA_hclust_tree <- as.hclust.phylo(HA_tree)
HA_hclust_tree$height


NS_tree <- force.ultrametric(NS_tree)
#NP_labels <- NP_tree$tip.label
#NP_labels_df <- as.data.frame(NP_labels)
#NP_labels_df <- NP_labels_df %>% separate(NP_labels, c("id", "location"), sep="_") %>% 
                          # unite(NP_labels, c("id", "location"), sep="_")
#NP_tree$tip.label <- NP_labels_df$NP_labels
NS_hclust_tree <- as.hclust.phylo(NS_tree, method= "complete")
NS_hclust_tree$labels



#Construct the dendogram
HA_dendro <- as.dendrogram(HA_hclust_tree)
NS_dendro <- as.dendrogram(NS_hclust_tree)



tanglegram(HA_dendro, NS_dendro,
                   highlight_distinct_edges = FALSE, # Turn-off dashed lines
                   common_subtrees_color_lines = FALSE, # Turn-off line colors
                   common_subtrees_color_branches = TRUE,
                   lwd = 1,
                   lty = 2,
                   edge.lwd = 2,
                   lab.cex = 0.4,
                   label_offset = 0.5,
                   seg.len = 0.5,
                   k_branches = 2,
                   main_left = "HA",
                   main_right = "NS",
                   cex_main_left = 2,
                   cex_main_right = 2
)


# Create the tree visualization with tip labels and color specific tips

HA_tree <- read.nexus("~/Desktop/Msc/results/IRMA/iqtree_clean/HA_tree.nex")
HA_tree$label
ggtree(HA_tree) +

geom_tippoint(size = 2, aes(color = ifelse(grepl("KCH", label), "KCH",
                                           
                                           ifelse(grepl("Matsangoni", label), "Matsangoni",
                                                  
                                                  ifelse(grepl("Ngerenya", label), "Ngerenya",
                                                         
                                                         ifelse(grepl("Mavueni", label), "Mavueni",   
                                                                
                                                                ifelse(grepl("Mtondia", label), "Mtondia",
                                                                       
                                                                       ifelse(grepl("Pingilikani", label), "Pingilikani",
                                                                              
                                                                              ifelse(grepl("Jinja", label), "Jinja",
                                                                                     
                                                                                     ifelse(grepl("Soroti", label), "Soroti",
                                                                                            
                                                                                            ifelse(grepl("Mbale", label), "Mbale", "Reference"))))))))))) +
  

  scale_color_manual(name = "Location",
                     
                     values = c("KCH" = "skyblue1", "Matsangoni" = "red2", "Mavueni"= "darkorchid3", "Mtondia" = "olivedrab4", "Pingilikani" = "coral4", "Jinja" = "khaki3", "Soroti" = "maroon3", "Mbale" = "turquoise3")) +
  
  geom_treescale(fontsize = 2) +
  
  ggtitle("Phylogenetic timetree of Influenza B HA segment") +
  
  theme(
    legend.title = element_text(    # defines font size and format of the legend title
      face = "bold",
      size = 16),  
    legend.key.size = unit(18, "pt"),
    legend.text=element_text(       # defines font size and format of the legend text
      face = "bold",
      size = 10),
    plot.title = element_text(      # defines font size and format of the plot title
      size = 12,
      face = "bold",
      hjust = 0.5),  
    legend.position = "right",     # defines placement of the legend
    legend.box = "vertical",        # defines placement of the legend
    legend.margin = margin())

geom_tiplab(size = 1.5, fontface=2, aes(color = ifelse(grepl("KCH", label), "KCH",
                                                       
                                                       ifelse(grepl("Matsangoni", label), "Matsangoni",
                                                              
                                                              ifelse(grepl("Ngerenya", label), "Ngerenya",
                                                                     
                                                                     ifelse(grepl("Mavueni", label), "Mavueni",   
                                                                            
                                                                            ifelse(grepl("Mtondia", label), "Mtondia",
                                                                                   
                                                                                   ifelse(grepl("Pingilikani", label), "Pingilikani",
                                                                                          
                                                                                          ifelse(grepl("Jinja", label), "Jinja",
                                                                                                 
                                                                                                 ifelse(grepl("Soroti", label), "Soroti",
                                                                                                        
                                                                                                        ifelse(grepl("Mbale", label), "Mbale",
                                                                                                               
                                                                                                               ifelse(grepl("B/Victoria/02/1987", label), "Victoria Lineage",
                                                                                                                      
                                                                                                                      ifelse(grepl("B/Yamagata/16/88", label), "Yamagata Lineage", "Reference"))))))))))))) +
  
  
  colour=ifelse(grepl("2010", label), "2010",
                
                ifelse(grepl("2011", label), "2011",
                       
                       ifelse(grepl("2012", label), "2012",
                              
                              ifelse(grepl("2013", label), "2013",   
                                     
                                     ifelse(grepl("2014", label), "2014",
                                            
                                            ifelse(grepl("2015", label), "2015",
                                                   
                                                   ifelse(grepl("2016", label), "2016",
                                                          
                                                          ifelse(grepl("2017", label), "2017",   
                                                                 
                                                                 ifelse(grepl("2018", label), "2018",
                                                                        
                                                                        ifelse(grepl("2019", label), "2019",
                                                                               
                                                                               ifelse(grepl("2020", label), "2020",
                                                                                      
                                                                                      ifelse(grepl("2021", label), "2021",   
                                                                                             
                                                                                             ifelse(grepl("2022", label), "2022", "NA"))))))))))))), 
shape = ifelse(grepl("KCH", label), "21",
               
               ifelse(grepl("Matsangoni", label), "22",
                      
                      ifelse(grepl("Ngerenya", label), "23",
                             
                             ifelse(grepl("Mavueni", label), "24",   
                                    
                                    ifelse(grepl("Mtondia", label), "25",
                                           
                                           ifelse(grepl("Pingilikani", label), "14",
                                                  
                                                  ifelse(grepl("Jinja", label), "9",
                                                         
                                                         ifelse(grepl("Soroti", label), "12",
                                                                
                                                                ifelse(grepl("Mbale", label), "10", "Reference"))))))))))) +
  scale_color_manual(name = "Location",
                     
                     
                  #Create a metadata file with the year and location column
                     
                     metadata <- HA_tree$tip.label
                     metadata_df <- as.data.frame(metadata)
                     
                     references <- metadata_df[grepl("B/", metadata_df$metadata), ]
                     ref_df <- as.data.frame(references)
                     ref_df$references <- gsub("'", "", ref_df$references)
                     ref_df <- ref_df %>% separate(references, c("sample_id", "Lineage", "segment", "clade","collection_date"), sep = "\\|")
                     ref_df <- ref_df %>% separate(collection_date, c("year", "month", "date"), sep = "-")
                     rownames(ref_df) <- references
                     
                     samples <- metadata_df <- metadata_df[!grepl("B/", metadata_df$metadata), ]
                     sample_df <- as.data.frame(samples)
                     sample_df$samples <- gsub("'", "", sample_df$samples)
                     sample_df <- sample_df %>% separate(samples, c("sample_id", "Location","collection_date"), sep = "\\|")
                     sample_df <- sample_df %>% separate(collection_date, c("year", "month", "date"), sep = "-")
                     rownames(sample_df) <- samples 
                     
                     mdata <- bind_rows(ref_df, sample_df)
                     mdata$Location <- ifelse(is.na(mdata$Location), "Unknown", mdata$Location)
                     as.factor(mdata$Location)
 