rm(list=ls())
# Script for global subset of B.5.8 genotype

setwd("~/Desktop/time_scale_phylogeny_tree_time/")

# Install artyfarty via github
devtools::install_github('datarootsio/artyfarty')

# Check whether pacman is available, if not install
if (!require("pacman")) install.packages("pacman")

# Install or load the required packages
pacman::p_load(
  lubridate,
  tidyverse,
  janitor,
  artyfarty,
  ggalluvial,
  ggrepel,
  ggtree,
  tidytree,
  treeio,
  wesanderson,
  ggpubr,
  phylotools,
  patchwork,
  scales
)

#color_global=c("blue","orange","darkseagreen","forestgreen","cadetblue","wheat","purple4","tan4","red","darkolivegreen4","magenta","tan3", "firebrick4", "lightsalmon","yellowgreen","firebrick4","mediumorchid1","chartreuse","wheat","blue","darkgray","darkblue","#FFFF00","#3E2723","#00FF00","#008000")

#color_global=c("orange","darkseagreen","cadetblue","purple4","tan4","darkolivegreen4","tan3","firebrick4","darkgray","#3E2723")

#color_global=c("darkseagreen","cyan","blue","red","purple4","cadetblue4","tan4",
#               "magenta","darkgreen","tomato1","#800000","#FFFF00","#3E2723",
#               "#00FF00","#008000", "#00FFFF","#FFA500","#0000FF","#CCCCFF",
#              "#55ACEE","#FA8072","#CD853F","#0F4D92")

#color_global <- c("darkseagreen","black","tan4","purple","purple4","cadetblue4","cyan")

rsv_genotypes <- c("#ff0000", "#00a08a", "#f2ad00", "#f98400", "#5bbcd6", "#000000", 
                "#d8b70a", "#02401b", "#a2a475", "#81a88d", "#f2f2f2",
                "#00a600", "#972d15", "#f0e68c", "#c4c4c4", "#ccff00")

#continent_colors <- c("tomato3", "#02401b", "#5bbcd6", "#00a600", "#a2a475", 
#                  "tan4", "gold"
#                  )

#################### Genotyping sequences 622 RSV-B ############################
meta_dta <- read.csv("global_subset_10_for_treetime_metadata.csv") 
meta_dta$date <- as.Date(meta_dta$collection_date)

# Have a look at your csv file
glimpse(meta_dta)

recent_date <-meta_dta%>%filter(!is.na(date))%>%pull(date)%>%max()
recent_date


#####################################Time tree.....#################################
tree<-read.nexus("global_subset_10_for_timetree.nexus")


p <- ggtree(tree, mrsd=recent_date,as.Date=TRUE,color='grey40',size=0.2) + 
  theme_tree2()+
  expand_limits(y = 2500)+
  scale_x_date(date_labels = "%Y",date_breaks = "5 year", minor_breaks = "5 year")+
  theme(axis.text.x = element_text(size=10,angle=0))
p

plot_1 <-  p%<+% meta_dta+ 
  geom_tippoint(aes(subset=(genotype!=""), color=genotype), size=2)+
  scale_shape_manual(values=c(15, 16, 18, 17, 12, 13, 14))+
  #scale_color_manual(values=c(wes_palette(5, name = "Darjeeling1", type = "discrete"),"black",wes_palette(5, name = "Cavalcanti1", type = "discrete"),terrain.colors(2),"khaki","gray77",rainbow(10)[c(-1,-2,-4)],as.character(wes_palette(4, name = "Royal1", type = "discrete")),as.character(wes_palette(5, name = "Zissou1", type = "discrete")),"pink","gray32","tomato1", color_global))+
  scale_color_manual(values = rsv_genotypes) +
  #scale_fill_manual(values = color_global[c(-3, -5)])+
  theme_scientific() +
  # labs(tag="A")+
  scale_y_continuous(limits=c(0,2500), minor_breaks = seq(0,2500,500), breaks = seq(0,2500,500))+
  theme(axis.title.x = element_text(size = 14, face = "bold"),
        axis.title.y =  element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 12), # angle = 45, hjust = 1
        axis.text.y= element_text(size = 14),
        legend.position = "right",
        #legend.position = c(0.22, 0.87),
        legend.key.size = unit(0.2, "cm"),
        legend.spacing.x = unit(0.2, 'cm'),
        legend.spacing.y = unit(0.2, 'cm'),
        legend.text = element_text(size = 14),
        legend.title =element_text(size = 14),
        legend.background = element_rect(fill="#FFFFFF", color = NA),
        #panel.grid = element_line(size=0.0, color="white"),
        legend.box.background = element_blank())+
  guides(shape=guide_legend(ncol=1, title = "", title.position = "top", title.theme = element_text(size=12, face="bold"), order=1, override.aes = list(shape = "square")),
         color=guide_legend(ncol=1, title = "RSV-B Lineages", title.position = "top", title.theme = element_text(size=12, face="bold"))) +
  
  # Add x-axis and y-axis labels
  labs(x = "Time (year)", y = "Number of sequences")

pdf("global_dataset_tree-treetime.pdf", width = 10, height = 12)
print(plot_1)
dev.off()
plot_1
