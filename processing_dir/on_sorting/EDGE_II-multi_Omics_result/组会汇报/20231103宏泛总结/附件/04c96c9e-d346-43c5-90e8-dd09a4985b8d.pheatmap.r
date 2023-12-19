#!/usr/bin/env Rscript



data = "/home/Cloud_Platform/Cloud_Platform/public/user/4976_YuanzhouWang/Freq_t.txt"
display_numbers = "NULL"
outputprefix = "/home/Cloud_Platform/Cloud_Platform/public/user/4976_YuanzhouWang/result_output/Pretty_heatmap62023_11_04_19_05_50_155626/04c96c9e-d346-43c5-90e8-dd09a4985b8d"
outputpictype = "pdf"
renameDuplicateRowNames = TRUE
logv = "NULL"
log_add = 0
scale = "none"
top_n = 1
statistical_value_type = "mad"
annotation_row = "/home/Cloud_Platform/Cloud_Platform/public/user/4976_YuanzhouWang/Ortho_Group.txt"
annotation_col = "/home/Cloud_Platform/Cloud_Platform/public/user/4976_YuanzhouWang/str_clade.txt"
cluster_rows = TRUE
cluster_cols = TRUE
clustering_method = "complete"
clustering_distance_rows = "spearman"
clustering_distance_cols = "spearman"
breaks = "NA"
breaks_mid = NULL
breaks_digits = 2
correlation_plot = "col"
maximum = Inf
minimum = -Inf
xtics_angle = 45
manual_color_vector = "NULL"
fontsize = 2
manual_annotation_colors_sidebar = "NULL"
cutree_cols = NA
cutree_rows = NA
kclu = NA
ytics = TRUE
xtics = TRUE
title = ""
anno_cutree_rows = FALSE
anno_cutree_cols = FALSE 

label_row_cluster_boundary = FALSE
label_col_cluster_boundary = FALSE
label_every_n_rowitems = 1
label_every_n_colitems = 1

width = 10
height = 10
debug = FALSE
cluster_cols_variable = "NULL"
cluster_rows_variable = "NULL"
remove_cluster_cols_variable_in_annocol = FALSE
remove_cluster_rows_variable_in_annorow = FALSE
saveppt = TRUE


if (data == "") {
  script = sub(".*=", "", commandArgs()[4])
  #print(script)
  system(paste(script, "-h"))
  stop("At least -f is required!")
}


# For all users
# devtools::install_github("Tong-Chen/ImageGP")
# For chinese users
# devtools::install_git("https://gitee.com/ct5869/ImageGP.git")
library(ImageGP)
library(pheatmap)
library(RColorBrewer)
library(grid)
library(vegan)
library(dplyr)
library(stringr)


if (outputprefix == ""){
	outputprefix = data
}
filename = paste0(outputprefix,  '.pheatmap.', outputpictype)

if(breaks == 'NA'){
	breaks = NA
}else if(breaks != "quantile"){
	breaks = as.numeric(sp_string2vector(breaks))
}





manual_color_vector = sp_string2vector(manual_color_vector)
# sp_string2vector

#sink("s.log", append=TRUE, split=TRUE)

cat(sp_current_time(), "Starting...\n")

sp_pheatmap(
  data = data,
  filename = filename,
  renameDuplicateRowNames = renameDuplicateRowNames,
  logv = logv,
  top_n = top_n,
  statistical_value_type = statistical_value_type,
  log_add = log_add,
  scale = scale,
  annotation_row = annotation_row,
  annotation_col = annotation_col,
  cluster_rows = cluster_rows,
  cluster_cols = cluster_cols,
  clustering_method = clustering_method,
  clustering_distance_rows = clustering_distance_rows,
  clustering_distance_cols = clustering_distance_cols,
  breaks = breaks,
  breaks_mid = breaks_mid,
  breaks_digits = breaks_digits,
  correlation_plot = correlation_plot,
  maximum = maximum,
  minimum = minimum,
  xtics_angle = xtics_angle,
  manual_color_vector = manual_color_vector,
  fontsize = fontsize,
  manual_annotation_colors_sidebar = manual_annotation_colors_sidebar,
  cutree_cols = cutree_cols,
  cutree_rows = cutree_rows,
  anno_cutree_rows = anno_cutree_rows,
  anno_cutree_cols = anno_cutree_cols,
  label_row_cluster_boundary = label_row_cluster_boundary,
  label_col_cluster_boundary = label_col_cluster_boundary,
  label_every_n_rowitems = label_every_n_rowitems,
  label_every_n_colitems = label_every_n_colitems,
  kclu = kclu,
  ytics = ytics,
  xtics = xtics,
  width = width,
  height = height,
  title = title,
  cluster_cols_variable=cluster_cols_variable,
  cluster_rows_variable=cluster_rows_variable,
  remove_cluster_cols_variable_in_annocol=remove_cluster_cols_variable_in_annocol,
  remove_cluster_rows_variable_in_annorow=remove_cluster_rows_variable_in_annorow,
  debug = debug,
  display_numbers = display_numbers,
  saveppt = saveppt
  )
cat(sp_current_time(), "Success.\n")
#sink()

