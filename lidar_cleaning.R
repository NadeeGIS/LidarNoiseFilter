# Preprocessing lidar 2020

# load required libraries
library("rlas")
setwd('/Users/13193/OneDrive - The University of South Dakota/Desktop/lidar/Gavins/las2020/')

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
  cor_subset=write.las(paste('/Users/13193/OneDrive - The University of South Dakota/Desktop/lidar/Gavins/las2020/cor_las2020',paste("cor_",file_list[i], sep = ""),sep=""),lasheader, subset_las2)
  #Sys.sleep(1)
}



