#### PACKAGES ####
#### LOAD IN DATA ####

#intervals
genomicIntervals <- read.table("../data/refGenome/PFo10kb.bed",
                               header = FALSE, 
                               sep="\t",stringsAsFactors=FALSE)

#introgressed regions
load("../outputs/gcnv/introgressList.RData")

#### GET LIST OF ALL SCAFFOLDS THAT HAVE BEEN INTROGRESSED ####
introgressScaffs <- c()

#use for loop to gather scaffold names
for(i in 1:length(introgressRegionsAll)){
  introgressScaffs <- c(introgressScaffs, introgressRegionsAll[[i]]$scaff)
}

#keep only those that are unique
introgressScaffs <- unique(introgressScaffs)

#### KEEP INTERVALS ASSOCIATED WITH SCAFFS ####
introScaffIntervals <- genomicIntervals[which(genomicIntervals[,1] %in% 
                                                introgressScaffs),]

#### SAVE BED ####
write.table(introScaffIntervals,"../data/refGenome/putIntro.bed",
            sep="\t",quote=F,row.names = F,col.names = F)
