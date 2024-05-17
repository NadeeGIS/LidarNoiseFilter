
library("rlas") # this will read las files
library("ggplot2") # for plotting box plots
library("gridExtra") # to organize multiple plots
library("pdftools") # saving pdf files

# Prompting the user for the working directory. This is where the las files are expected.
working_dir <- readline(prompt = "Please enter the working directory path: ")

# Set the working directory
setwd(working_dir)

# List files function to select only the las files from the folder
file_list <- list.files(path = '.', pattern = '*.las$')

# Create data_las objects and extract Z values to create box plots
plot_list <- list()
for (i in 1:length(file_list)) {
  print(file_list[i])
  data_las <- read.las(file_list[i], select = "*", filter = "")
  Z_values <- data_las$Z
  plot_list[[i]] <- ggplot(data.frame(Z = Z_values), aes(x = factor(1), y = Z)) +
    geom_boxplot() +
    labs(title = file_list[i], x = "", y = "Z values") +
    theme_minimal()
}

# Save box plots in PDF files with at most ten plots per file
pdf_dir <- file.path(working_dir, "boxplot_pdfs")
if (!dir.exists(pdf_dir)) {
  dir.create(pdf_dir)
}

num_plots_per_pdf <- 10
num_pdfs <- ceiling(length(plot_list) / num_plots_per_pdf)
pdf_files <- vector("character", num_pdfs)

for (i in 1:num_pdfs) {
  start_idx <- (i - 1) * num_plots_per_pdf + 1
  end_idx <- min(i * num_plots_per_pdf, length(plot_list))
  pdf_file <- file.path(pdf_dir, paste("boxplots_part", i, ".pdf", sep = ""))
  pdf(pdf_file, width = 8, height = 11)
  grid.arrange(grobs = plot_list[start_idx:end_idx], ncol = 2)
  dev.off()
  pdf_files[i] <- pdf_file
}

# Merge all the individual PDFs into one final PDF
final_pdf_file <- file.path(working_dir, "all_boxplots.pdf")
pdf_combine(input = pdf_files, output = final_pdf_file)

# Preprocessing and saving corrected las files
for (i in 1:length(file_list)) {
  print(file_list[i])
  data_las <- read.las(file_list[i], select = "*", filter = "")
  # Calculating thresholds_upbound and lowbound
  upbound <- mean(data_las$Z) + 5 * sd(data_las$Z)
  lowbound <- mean(data_las$Z) - 3 * sd(data_las$Z)
  # Making las subset with upbound and lowbound
  subset_las1 <- subset(data_las, Z < upbound)
  subset_las2 <- subset(subset_las1, Z > lowbound)
  # Creating corrected las data
  lasheader <- header_create(subset_las2)
  output_file <- file.path(working_dir, "outputdir", paste("cor_", file_list[i], sep = ""))
  
  # Ensure the output directory exists
  if (!dir.exists(file.path(working_dir, "outputdir"))) {
    dir.create(file.path(working_dir, "outputdir"))
  }
  
  cor_subset <- write.las(output_file, lasheader, subset_las2)
}

print("LidarNoiseFilter - Processing complete.")
