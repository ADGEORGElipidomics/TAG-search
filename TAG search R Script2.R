# set working directory("/")
setwd("C:\\FILELOCATION")

source("TAG search R script.r")

# var perc is the percentage value as a fraction and ranges from 0 to 1 with 0.01 being 1 percent. 
#out <- tag.f(
#	var1 = "x3d_omegad",
#	var2 <- "x3d_m_z",
#	var1_perc = 0.0001,
#	var2_perc = 0.0001)

#1 is CCS % difference, 2 is mz value difference, 3 is RT value difference. Set CCS to 0.01 (which is 1%).
#var 1 set to 0.01, so + or - 1%; var 2 set to 0.1; var 3 set to 0.15 [this will say no rows satisfying these constraints if calibration was not done correctly!]

 out <- tag.f(
  var1 = "x3d_omegad",
  var2 <- "x3d_m_z",
  var3 <- "x3d_rettime",
  var1_perc = 0.01,
  fixed_val2=0.1, 
  fixed_val3=0.15)

 

## some checks and visuals

nrow(out)
table(out$tag) ## not every tag will be represented, only those which had at least one row in dat which satisfied the input constraints


## write to CSV, don't forget to rename output file!

write.csv(out,file = "output\\FILENAME.csv")
