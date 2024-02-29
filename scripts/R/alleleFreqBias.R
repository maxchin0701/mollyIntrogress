#### PACKAGES ####
library(vcfR)
library(ggplot2)

#### LOAD IN DATA ####
#sprcify variable or fixed ploidy analysis
ploidy <- "Var"

#variants
dat <-  read.vcfR(paste0("../outputs/variantCalls/allIntrogress",ploidy,"Filt.vcf.gz"))

#introgressed regions
load(paste0("../outputs/gcnv/introgressList",ploidy,".RData"))

#### EXTRACT ALLELE DEPTH ####
allDepths <- extract.gt(dat,element="AD")

#add columns to SNP depth df
scaffPos <- strsplit(rownames(allDepths),"_")
allDepths <- as.data.frame(allDepths)

scaffNames <- list()
posNames <- list()

#fill lists
for(i in 1:nrow(allDepths)){
  scaffNames[[i]] <- paste(scaffPos[[i]][1],scaffPos[[i]][2],sep="_")
  posNames[[i]] <- scaffPos[[i]][3]
}

#bind to df
allDepths <- cbind(allDepths,
             do.call(rbind,scaffNames),
             do.call(rbind,posNames))
colnames(allDepths)[c(9,10)] <- c("scaff","pos")
rownames(allDepths) <- NULL

#### GET REF ALLELE FREQUENCY ####
refFreq <- vector("list",2000000)
samps <- vector("list",2000000)
index <- 1

for(i in 1:8){
  curSamp <- colnames(allDepths)[i]
  for(j in 1:nrow(allDepths)){
    refDepth <- as.numeric(strsplit(allDepths[j,i],split=",")[[1]][1])
    totalDepth <- as.numeric(strsplit(allDepths[j,i],split=",")[[1]][1]) + 
      as.numeric(strsplit(allDepths[j,i],split=",")[[1]][2])
    
    refFreq[[index]] <- refDepth/totalDepth
    samps[[index]] <- curSamp
    index <- index+1
  }
}

allFreqs <- cbind(allDepths[,c(9,10)],
                   do.call(rbind,refFreq),
                   do.call(rbind,samps))

colnames(allFreqs)[c(3,4)] <- c("freq","sample")
allFreqs$pos <- as.numeric(allFreqs$pos)
allFreqs <- subset(allFreqs,freq!=0 & freq!=1)


#### LOOP THROUGH SCAFFOLDS AND PLOT####

#get list of scaffolds
introgressScaffs <- levels(factor(allFreqs$scaff))

for(i in 1:length(introgressScaffs)){
  #determine start and end points
  introgressRegionsDf <- data.frame()
  for(j in 1:length(introgressRegionsAll)){
    introgressRegionsDf <- rbind(introgressRegionsDf,introgressRegionsAll[[j]])
  }
  introgressRegionsDf <- subset(introgressRegionsDf,scaff==introgressScaffs[i])
  posMin <- min(as.numeric(introgressRegionsDf$start))
  posMax <- max(as.numeric(introgressRegionsDf$end))
  
  #subset allele frequencies
  subsetFreqs <- subset(allFreqs,scaff==introgressScaffs[i] & 
                        pos >= posMin &
                        pos <= posMax)
  
  curScaffPlot <- ggplot(data=subsetFreqs,aes(x=freq))+
    geom_density(mapping=aes(fill=subsetFreqs$sample),alpha=0.4)+
    scale_fill_viridis_d()+
    labs(fill=paste0(introgressScaffs[i],"\n",posMin," - ",posMax))+
    ylab("Density")+
    xlab("Reference allele frequency")+
    xlim(0,1)+
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background= element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.y = element_text(size = 10),
          axis.title = element_text(face = "bold",
                                    size = 10),
          legend.title = element_text(face = "bold",
                                      size = 10),
          legend.key=element_blank(),
          plot.title = element_text(face = "bold",
                                    size = 17,
                                    hjust=0.5))
  
  #save plot
  ggsave(curScaffPlot,
         filename = paste0("../figures/alleleBias/",
                           tolower(ploidy),"/",
                           introgressScaffs[i],
                           ".pdf"),
         width = 7.47,
         height = 4.90,
         units = "in")
}

