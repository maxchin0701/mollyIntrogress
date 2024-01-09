#### PACKAGES ####
#### READ IN INTERVALS ####
intervals <- read.delim("../data/refGenome/PFo10kb.bed",sep="\t",row.names = NULL,header = F)

#### MAKE OBJECTS TO STORE ####
introgressRegionsAll <- list()

#### COLLECT SAMPLE NAMES ####
samps <- c()
sampDirs <- list.dirs(path='../outputs/gcnv')[-1]

for(i in 1:length(sampDirs)){
  if(strsplit(sampDirs[i],split="/")[[1]][4] == "rawCalls"){
    next()
  }
  samps <- c(samps,strsplit(sampDirs[i],split="/")[[1]][4])
}

rm(sampDirs,i)

#remove poor sequencing/duplicate samples
 
#### LOOP THROUGH SAMPLES ####
for(i in 1:length(samps)){
  
  #### READ IN COPY COUNTS FOR CURRENT SAMPLE ####
  #read in raw copy counts
  rawCNV <- read.delim(paste0("../outputs/gcnv/rawCalls/10kb/SAMPLE_",i-1,"/baseline_copy_number_t.tsv"),sep="\t",row.names = NULL)
  rawCNV <- as.numeric(rawCNV[4:nrow(rawCNV),1])
  
  #read in mean denoised copy ratios
  muDCR <- read.delim(paste0("../outputs/gcnv/rawCalls/10kb/SAMPLE_",i-1,"/mu_denoised_copy_ratio_t.tsv"),sep="\t",row.names = NULL)
  muDCR <- as.numeric(muDCR[4:nrow(muDCR),1])
  
  #bind raw CNV to intervals
  intervalCNVs <- cbind(intervals,rawCNV,muDCR)
  colnames(intervalCNVs) <- c("scaff","start","end","CN","muDCR")
  
  #### INITIALIZE OBJECTS TO STORE ####

  #lists
  scaff <- list()
  start <- list()
  end <- list()
  
  #### MOVE THROUGH INTERVALS ####
  
  #initialize indexing variable
  index <- 1
  
  #use while loop to iterate
  while(index <= nrow(intervalCNVs)){
    #if statement to check if current interval has copy number three
    if(intervalCNVs[index,5] >= 2.25 && 
       intervalCNVs[index,5] <= 3.5){
      
      #record beginning of introgressed region
      introgressBegin <- index
      
      #use internal index to keep track of how many overrepresented intervals in a row
      indexInternal <- 0
      
      #keep moving until we reach the next diploid interval
      while((intervalCNVs[index+indexInternal,5] >= 2.25 || 
             intervalCNVs[index+indexInternal,5] <= 0) &&
            intervalCNVs[index + indexInternal,1] == intervalCNVs[index,1]){
        indexInternal <- indexInternal + 1
      }
      
      #record end of introgressed region
      introgressEnd <- index + indexInternal - 1
      
      if(indexInternal >= 11){
        
        #append each to respective lists
        scaff[[length(scaff) + 1]] <- intervalCNVs[introgressBegin,1]
        start[[length(start) + 1]] <- intervalCNVs[introgressBegin,2]+1
        end[[length(end) + 1]] <- intervalCNVs[introgressEnd,3]+1
      }
      
      #get new index to continue from
      index <- index + indexInternal
    
    } else {
      index <- index + 1
    }
  }
  
  #### BIND ALL TO DF AND ADD TO LIST ####
  #combine vectors into df
  introgressRegions <- as.data.frame(cbind(do.call(rbind,scaff),
                             do.call(rbind,start),
                             do.call(rbind,end)),)
  if(ncol(introgressRegions) == 3){
    colnames(introgressRegions) <- c("scaff","start","end")
  }
  
  #add df into list
  introgressRegionsAll[[i]] <- introgressRegions
  names(introgressRegionsAll)[i] <- samps[i]
  
}

#remove poor sequencing/duplicate samples
introgressRegionsAll <- introgressRegionsAll[-c(5,7,8)]

#### SAVE R OBJECT ####
save(introgressRegionsAll,file="../outputs/gcnv/introgressList.RData")
