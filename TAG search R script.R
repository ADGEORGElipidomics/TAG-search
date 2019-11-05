# change this to the directory that has the files and scripts in
setwd("C:\\FILELOCATION")

files <- list.files()
(files <- files[grep(".csv",files)])
length(files)

	## read in raw files
	
dat.list <- lapply(files,function(file) {
	print(file); flush.console()
	read.csv(file,stringsAsFactor = FALSE)
})

	## check each file has same column names etc

sapply(dat.list,class)
sapply(dat.list,ncol)
do.call(rbind,lapply(dat.list,colnames))

	## row bind
	
dat <- do.call(rbind,dat.list)
colnames(dat) <- tolower(colnames(dat))
nrow(dat)
table(dat$kevid)

  ##script will read following TAG list

library(readxl)
dat2 <- as.data.frame(read_excel("HMTAGlist.xlsx"))
colnames(dat2) <- tolower(colnames(dat2))

	## For each of the 205 values in dat2 go through dat and identify individuals that are within +/- x% of the value for a certain TWO variable
	## Output for each of the 205 values the individuals that satisfy this criteria 
	## save tag and variable values for each test
	
tag.f <- function(var1,var2,var3, var1_perc,var2_perc, fixed_val2, fixed_val3) {
	inner <- lapply(1:nrow(dat2),function(rownum) {
	
			## check values of tag, ccs, and mz
			
		# print(dat2[rownum,]); flush.console()
		
			## extract values of ccs and mz we are looking at
		
		temp.ccs <- dat2$ccs[rownum]
		temp.mz <- dat2$mz[rownum]
		temp.rt<- dat2$rt[rownum]
		
			## calculate lower and upper percentage limits for var1 and var2 based on the user-input percentage
		
		(var1_limit_lower <- temp.ccs - var1_perc * temp.ccs)
		(var1_limit_upper <- temp.ccs + var1_perc * temp.ccs)
		
		## alex make a selection here dependent on whether var2 is percent or fixed val checked
		## for percent use the next two lines 
		## for fixed val use the two lines below
		
		#(var2_limit_lower <- temp.mz - var2_perc * temp.mz)
		#(var2_limit_upper <- temp.mz + var2_perc * temp.mz)

		(var2_limit_lower <- temp.mz-fixed_val2)
		(var2_limit_upper <- temp.mz+fixed_val2)
		
		
		(var3_limit_lower <- temp.rt-fixed_val3)
		(var3_limit_upper <- temp.rt+fixed_val3)
		
		
			## identify rows in dat which satisfy the criteria
	  ## THIS IS THE LINE WHERE YOU CAN CHANGE THE CRITERIA FOR EXAMPLE CHANGE THE 10 to 20 or the 600 to 800. 
	  
		temp <- dat[
			(dat[,var1] >= var1_limit_lower & dat[,var1] <= var1_limit_upper) & 	## restrict based on var1
			(dat[,var2] >= var2_limit_lower & dat[,var2] <= var2_limit_upper) & 	## restrict based on var2
		  (dat[,var3] >= var3_limit_lower & dat[,var3] <= var3_limit_upper) & 	## restrict based on var3
			(dat$x3d_rettime > 10 & dat$x3d_m_z > 600),] 						
			
		if (nrow(temp) > 0) {
			temp$ccs <- temp.ccs
			temp$mz <- temp.mz
		  temp$rt <- temp.rt
			temp$tag <- dat2$tag[rownum]
		}

		return(temp)
	})
	
		## row bind into big dataframe
	library(plyr)
	inner2 <- do.call(rbind.fill,inner)
	
		## check if any rows were output, return error if zero
			
	if (nrow(inner2) == 0) {
		stop("sorry, no rows satisfying these constraints :(")
	}
	
		## return output from function 
	return(inner2)
}
