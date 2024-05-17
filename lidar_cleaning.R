# Preprocessing lidar 2020

# load required libraries
library("rlas")
# setwd('/Users/13193/OneDrive - The University of South Dakota/Desktop/lidar/Gavins/las2020/')

# Prompting the user for the working directory
working_dir <- readline(prompt = "Please enter the working directory path: ")

# Set the working directory
setwd(working_dir)

# select * = any character before dot, $=indicates end of the las file
# list.files function to select only the las files from the folder
file_list=list.files(path = '.',pattern = '*.las$')

# to remove outliers from the point cloud
# we use 5SD as upper bound and 3SD as lowerbound

for (i in 1:length(file_list)){
  print(file_list[i])
  data_las=read.las(file_list[i], select = "*", filter = "")
  # calculating thresholds_upbound and lowbound
  upbound = mean(data_las$Z) + 5*sd(data_las$Z)
  lowbound = mean(data_las$Z) - 3*sd(data_las$Z)
  # making las subset with upbound and lowbound
  subset_las1=subset(data_las, Z<upbound)
  subset_las2=subset(subset_las1, Z>lowbound)
  # creating corrected las data
  lasheader = header_create(subset_las2)
   output_file <- file.path(working_dir, "outputdir", paste("cor_", file_list[i], sep = ""))
  
  # Ensure the output directory exists
  if (!dir.exists(file.path(working_dir, "outputdir"))) {
    dir.create(file.path(working_dir, "outputdir"))
  }
  
  cor_subset <- write.las(output_file, lasheader, subset_las2)
}

print("Processing complete.")


