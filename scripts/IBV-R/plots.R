library(readr)
library(ggplot2)
library(dplyr)
library(readxl)

assembly <- cbind(PB1$sample_ct, PB1$V2, PB2$V2, PA$V2, HA$V2, NA.$V2, NP$V2, M1$V2, NS1$V2)
assembly <- as.data.frame(assembly)
assembly <- assembly %>% mutate(genome_length=V1+V2+V3+V4+V5+V6+V7+V8) %>%
  mutate(genome_coverage=round(genome_length/14648 * 100, 2))

write.csv(assembly, '~/Desktop/Msc/results/recovery.csv')

sample_id <- read_excel('~/Downloads/nanopore_run1 (3).xlsx')
sample_ct1 <- sample_id %>% unite(sample_ct, c('Sample_id', 'ct_value'), sep = '_')

NS1<- cbind(NS1, sample_ct1)

NS1$sample_ct<- factor(NS1$sample_ct, levels=NS1$sample_ct)

NS1 <- NS1 %>% mutate(label=as.character(V2),
                      label=if_else(as.character(V2) < 1000, paste(''),label))

p8 <-ggplot(data=NS1, aes(x=sample_ct, y=V2)) +
  geom_bar(stat="identity", fill="steelblue", alpha=.6, width=.7) +
  geom_hline(yintercept =753,linetype='dashed') +
  geom_text(aes(label=label), angle=90, hjust=1.6, color="black", size=3.5) +
  labs(title= 'NS1 segment', y='segment length') +
  theme(axis.text.x = element_text(angle = 90), plot.title = element_text(hjust = 0.5))
p8

jpeg(filename = '~/Desktop/Msc/plots/seg5-8.jpeg', width=800, height=800)
grid.arrange(p5,p6,p7,p8, ncol=2,nrow=2)
dev.off()
grid.arrange()




#read in the file
run1_data<-read_csv('~/Downloads/flub_nanopore_run1_16_02_23 - 57_selection_list (6).csv')
location_count<-run1_data %>% group_by(Location, Segments) %>%  summarise(count= n())
summary(run1_data$Qubit_concentration)

run2_data <- read_excel("~/Downloads/run2_info.xlsx")
concat_data <- read_excel("~/Downloads/flub_recovered.xlsx")
concat_data <- concat_data[1:151, ]
typeof()

#Plot segment recovery per location

seg_recovery <- ggplot(data=concat_data, aes(x=Segments,fill = Study)) + 
geom_histogram(binwidth = .5) + 
ggtitle('Segment distribution per location', ) + 
theme_bw()+
scale_x_continuous(labels=concat_data$Segments,breaks=concat_data$Segments)+
theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 12, color = 'black'),
      axis.line = element_line(colour = "black"),
      axis.text.x = element_text(colour = 'black'),
      axis.text.y = element_text(colour = 'black'),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      axis.title.x = element_text(size = 12, face = 'bold'),
      axis.title.y = element_text(size = 12, face = 'bold')) 


seg_recovery + scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"))

ggplot(data=concat_data, aes(x=Segments,fill = Study)) + 
  geom_histogram(binwidth = .5) +
  ggtitle('Segment distribution per location', ) +
  theme_bw()+
  scale_x_continuous(labels=concat_data$Segments,breaks=concat_data$Segments) +
  scale_y_continuous(limits=c(0, 30), breaks = seq(0, 30, 5))
  
  


#Plot ct value distribution

ggplot(data=run2_data, aes(x=Study, y=ct_value, colour=Study)) +
  geom_boxplot() +
  ggtitle('ct value distribution')+
  labs(x = "Location", y = "cycle threshold (ct) value") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 12, color = 'black'),
        axis.line = element_line(colour = "black"),
        axis.text.x = element_text(colour = 'black'),
        axis.text.y = element_text(colour = 'black'),
        axis.title.x = element_text(size = 12, face = 'bold'),
        axis.title.y = element_text(size = 12, face = 'bold'), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) 
ggsave('~/Desktop/Msc/plots/run2_ctdis.png', dpi = 600)


#Plot qubit concentration distribution

ggplot(data=run2_data, aes(x=Study, y=round(as.numeric(`qubit concentration`, 1)), colour=Study)) +
  geom_boxplot() +
  ggtitle('Qubit concentration distribution')+
  labs(y='qubit concentration (ng/ul)', x= 'Location') +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 12, color = 'black'),
        axis.line = element_line(colour = "black"),
        axis.text.x = element_text(colour = 'black'),
        axis.text.y = element_text(colour = 'black'),
        axis.title.x = element_text(size = 12, face = 'bold'),
        axis.title.y = element_text(size = 12, face = 'bold'), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) 


#plot relationship between ct value and qubit concentration

bestfit <- geom_smooth(
  method = "lm", 
  se = FALSE, 
  colour = alpha("black", alpha = 0.5),
  linewidth = .5
)
ct_qubit<- ggplot(data=run1_data, aes(x=ct_value, y=Qubit_concentration, colour=Location)) +
  geom_point() +
  ggtitle('Ct value versus Qubit concentration')+
  bestfit +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10, color = 'black'),
        axis.line = element_line(colour = "black"),
        axis.text.x = element_text(colour = 'black'),
        axis.text.y = element_text(colour = 'black'),
        axis.title.x = element_text(size = 10, face = 'bold'),
        axis.title.y = element_text(size = 10, face = 'bold'), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) 
ct_qubit + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9"))
ggsave('~/Desktop/Msc/plots/ct_qubit.png', dpi = 600)

#Plot ct vs segment recovery

bestfit <- geom_smooth(
  method = "lm", 
  se = FALSE, 
  colour = alpha("black", alpha = 0.5),
  linewidth = .5
)
ggplot(data=run1_data, aes(x=Location, y=Nanodrop, colour=Location)) +
  geom_boxplot() +
  ggtitle('Nanodrop')+
  ylab('RNA concentration (ng/ul)')+
  scale_y_continuous(limits=c(0, 10), breaks = seq(0, 10, 2)) + 
  theme(plot.title = element_text(hjust = 0.5),
        axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) 



#Plot ct value vs genome recovery

bestfit <- geom_smooth(
  method = "lm", 
  se = FALSE, 
  colour = alpha("black", alpha = 0.5),
  linewidth = .5
)
qubit_genome<-ggplot(data=run1_data, aes(x=Qubit_concentration, y=genome_length, colour=Location)) +
  geom_point() +
  ggtitle('Qubit concentration versus genome length')+
  bestfit +
  ylab('genome length (bp)')+
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10, color = 'black'),
        axis.line = element_line(colour = "black"),
        axis.text.x = element_text(colour = 'black'),
        axis.text.y = element_text(colour = 'black'),
        axis.title.x = element_text(size = 10, face = 'bold'),
        axis.title.y = element_text(size = 10, face = 'bold'), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) 
qubit_genome + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9"))
ggsave('~/Desktop/Msc/plots/qubit_length.png', dpi = 600)

#Plot ct value vs genome recovery

bestfit <- geom_smooth(
  method = "lm", 
  se = FALSE, 
  colour = alpha("black", alpha = 0.5),
  linewidth = .5
)
ct_genome<-ggplot(data=run1_data, aes(x=ct_value, y=genome_length, colour=Location)) +
  geom_point() +
  ggtitle('ct value versus genome length')+
  bestfit +
  ylab('genome length (bp)')+
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10, color = 'black'),
        axis.line = element_line(colour = "black"),
        axis.text.x = element_text(colour = 'black'),
        axis.text.y = element_text(colour = 'black'),
        axis.title.x = element_text(size = 10, face = 'bold'),
        axis.title.y = element_text(size = 10, face = 'bold'), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) 
ct_genome + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9"))
ggsave('~/Desktop/Msc/plots/ct_length.png', dpi = 600)



#Genome length distribution

# Genome completeness
#aes(x = reorder(Colors, -Qty, sum), y = Qty)
# Arrange from largest to smallest
# ggplot(data = rsvb, aes(reorder(Sample_id, -Genome_completeness), Genome_completeness))
ggplot(data = run1_data, aes(Sample_id, genome_length)) +
  geom_bar(stat = "identity", fill='steelblue') +
  # Removing the default grey background
  theme_classic() +
  # The title, x and y labels
  labs( 
    title = 'Influenza B Genome Coverage',
    x = 'Sample ID',
    y = 'Genome Coverage (nucleotides)',
    fill = 'white'
  ) +
  theme(
    # Tilting the x-axis labels to align at 90 degrees
    axis.text.x = element_text(angle = -90, vjust = 0.5),
    # Bold, centre, fontsize and color of title
    plot.title = element_text(face = "bold", hjust = 0.5, size = 15, color = 'black'),
    axis.title.x = element_text(size = 12, face = 'bold'),
    axis.title.y = element_text(size = 12, face = 'bold')
  ) +
  # Adding the vertical line to denote 75%
  geom_hline(yintercept=0.7*14648,linetype=2) +
  # Adding the vertical to mark the end of the reference genome
  geom_hline(yintercept=14648,linetype=2) +
  # Labeling the reference sequence mark
  annotate("text", x=8, y=14648, label="Ref Sequence 14.6kb") +
  # Removing the space between the bars and the x-axis
  scale_y_continuous(expand = expansion(mult = c(0, .1)))


  


