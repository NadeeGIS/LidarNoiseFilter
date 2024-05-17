# LidarNoiseFilter

This repository contains an R script designed to preprocess and clean LiDAR (Light Detection and Ranging) LAS files. I used it to clean LAS files from the year 2020. The main focus of the script is to remove outliers from the point cloud data using statistical thresholds. The process involves reading LAS files, creating box plots based on Z-values, calculating upper and lower bounds based on standard deviations, and generating a corrected dataset without outliers. This script is useful for researchers and practitioners working with LiDAR data who need to ensure the quality and reliability of their datasets.

## Input Data

The user will be prompted to input the working directory. The script expects las files to be in there.
* las files

## Output Data
* cleaned las files
* pdf file with box plots of Z-values

## Environment

Better to have conda environment created with following R packages installed.
* rlas
* ggplot2
* gridExtra
* pdftools
  
```
# Bash
conda create -n lidar_env r-essentials r-base
conda activate lidar_env
conda install -c conda-forge r-ggplot2 r-gridextra r-pdftools
R
```

```
# in R
install.packages("devtools")  # if you don't have devtools already
devtools::install_github("Jean-Romain/rlas")
install.packages("rlas")  # Attempt to install normally, or use devtools if it fails
install.packages("remotes")
remotes::install_github("ropensci/lidR")
quit()
```


## How to Run
```
# in Bash
Rscript  LidarNoiseFilter.R
```
