# Load graphics
library(ggplot2)
library("readxl")

rsvb <- read_excel("rsvb_assembled_whole_genome_data-25-03-2023.xlsx")

str(rsvb)

# CT values vs concentration

bestfit <- geom_smooth(
  method = "lm", 
  se = FALSE, 
  colour = alpha("red", 0.5),
  linewidth = 2
)
ggplot(data=rsvb, aes(x=CT_Values, y=Original_sample_conc, colour=Site)) +
      geom_point() +
      bestfit
ggsave('cv_vs_concentration.png', dpi = 600)



# CT values vs Genome completness
bestfit <- geom_smooth(
  method = "lm", 
  se = FALSE, 
  colour = alpha("red", 0.5),
  linewidth = 2
)

ggplot(data=rsvb, aes(x=CT_Values, y=Genome_completeness, colour=Site)) +
  geom_point() +
  bestfit
ggsave('ct_vs_genome_completeness.png', dpi = 600)


# Distribution of CT values
ggplot(data=rsvb, aes(x=CT_Values)) +
  geom_histogram(binwidth = 0.5)
ggsave('ct_values_distribution.png', dpi = 600)


# Sample Distribution per year (2017 - 2020)
ggplot(data=rsvb, aes(x=Date_Sampled)) +
  geom_histogram(fill = "darkred") + 
  #geom_col(width = 1, fill = "darkred") +
  facet_wrap(~Site) +
  labs(
    title = "Number of Samples Per Site",
    y = 'Number of samples',
    x = "Year sampled"
  ) + theme_bw()
ggsave('Sample_distribution.png', dpi = 600)

# Samples per site
ggplot(data=rsvb, aes(x=Site)) +
  geom_histogram(stat="count")
ggsave('Samples_per_site.png', dpi = 600)

# Genome completeness
#aes(x = reorder(Colors, -Qty, sum), y = Qty)
# Arrange from largest to smallest
# ggplot(data = rsvb, aes(reorder(Sample_id, -Genome_completeness), Genome_completeness))
ggplot(data = rsvb, aes(Sample_id, Genome_completeness)) +
  geom_bar(stat = "identity", fill='#008ECC') +
  # Removing the default grey background
  theme_classic() +
  # The title, x and y labels
  labs( 
    title = 'RSVB Genome Covarage',
    x = 'Sample ID',
    y = 'Genome Coverage (nuleotides)',
    fill = 'white'
    ) +
    theme(
      # Tilting the x-axis labels to align at 90 degrees
      axis.text.x = element_text(angle = -90, vjust = 0.5),
      # Bold, centre, fontsize and color of title
      plot.title = element_text(face = "bold", hjust = 0.5, size = 15, color = 'red'),
      axis.title.x = element_text(size = 12, face = 'bold'),
      axis.title.y = element_text(size = 12, face = 'bold')
      ) +
    # Adding the vertical line to denote 75%
    geom_hline(yintercept=0.7*15216,linetype=2) +
    # Adding the vertical to mark the end of the reference genome
    geom_hline(yintercept=15216,linetype=2) +
    # Labeling the reference sequence mark
    annotate("text", x=8, y=15450, label="Ref Sequence 15.2kb") +
    # Removing the space between the bars and the x-axis
    scale_y_continuous(expand = expansion(mult = c(0, .1)))
    # Saving the plot to local disk
ggsave(filename = 'genome_completeness.png', dpi = 600, width = 14,
       height = 7) 

# Coverage and Concentration 
bestfit <- geom_smooth(
  method = "lm", 
  se = FALSE, 
  colour = alpha("red", 0.5),
  linewidth = 2
)
ggplot(data=rsvb, aes(x=Original_sample_conc, y=Genome_completeness, colour=Site)) +
  geom_point(alpha = 0.5) +
  bestfit +
  xlab("Sample Concentration (ng/Ul)") +
  ylab("Genome Coverage") +
  theme_classic()
ggsave('genome_coverage_vs_concentration.png', dpi = 600)

map(database = "world", regions = 'Uganda')

