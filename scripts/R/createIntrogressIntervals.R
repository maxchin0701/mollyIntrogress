#### PACKAGES ####
library(stringr)
#### LOAD IN DATA ####

#intervals
genomicIntervals <- read.table("../data/refGenome/PFo1kb.bed",
                               header = FALSE, 
                               sep="\t",stringsAsFactors=FALSE)

#introgressed regions
ploidy <- "fix"
load(paste0("../outputs/gcnv/introgressList",ploidy,".RData"))

#### GET LIST OF ALL SCAFFOLDS THAT HAVE BEEN INTROGRESSED ####
introgressScaffs <- c()
introgressStart <- c()
introgressEnd <- c()

#use for loop to gather scaffold names
for(i in 1:length(introgressRegionsAll)){
  introgressScaffs <- c(introgressScaffs, introgressRegionsAll[[i]]$scaff)
  introgressStart <- c(introgressStart, introgressRegionsAll[[i]]$start)
  introgressEnd <- c(introgressEnd, introgressRegionsAll[[i]]$end)
}

#keep only those that are unique
introgressDf <- as.data.frame(cbind(introgressScaffs,introgressStart,introgressEnd))
introgressDf$introgressScaffs <- as.factor(introgressDf$introgressScaffs)

#### KEEP INTERVALS ASSOCIATED WITH SCAFFS ####
introScaffIntervals <- as.data.frame(matrix(NA,ncol=3,nrow=0))
for(i in levels(introgressDf$introgressScaffs)){
  scaffMin <- as.numeric(min(introgressDf[which(introgressDf$introgressScaffs == i),2]))
  scaffMax <- as.numeric(max(introgressDf[which(introgressDf$introgressScaffs == i),3]))
  introScaffIntervals <- rbind(introScaffIntervals,
                               genomicIntervals[which(genomicIntervals[,1]  == i &
                                                genomicIntervals[,2] >= scaffMin-1 &
                                                genomicIntervals[,3] <= scaffMax),])
}

#### SAVE BED ####
write.table(introScaffIntervals,paste0("../data/refGenome/putIntro",str_to_title(ploidy),".bed"),
            sep="\t",quote=F,row.names = F,col.names = F)
