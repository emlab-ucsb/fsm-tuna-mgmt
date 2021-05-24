##########################
## Paths to directories ##
##########################

# Check for OS
sys_path <- ifelse(Sys.info()["sysname"]=="Windows", 
                   "G:/",
                   "/Volumes/GoogleDrive/Shared\ drives/emlab/")
                   #"~/Google Drive File Stream/")

# Path to our emLab's data folder
# data_path <- paste0(sys_path,"Shared drives/emlab/data")

# Path to this project'sfolder
project_path <- paste0(sys_path,"projects/current-projects/fsm-tuna-mgmt")

# Directory to save the cleaned data files generated in this project
clean_dir <- file.path(project_path, "data", "edited")
if (dir.exists(clean_dir) == F) {
  dir.create(clean_dir, recursive = T)
} 

# Directory to save the visualization plots
vis_plot_dir <- here::here("results", "02-visualization/")
if (dir.exists(vis_plot_dir) == F) {
  dir.create(vis_plot_dir, recursive = T)
} 