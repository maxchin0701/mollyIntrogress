#### PACKAGES ####
library(ggplot2)

#### LOAD LIST OF INTRGORESSED REGIONS ####
load("../outputs/gcnv/introgressList.RData")

#### SET INTERVAL SIZE  ####
intervalSize <- "10kb"
#### READ IN INTERVALS ####

#change this depending on if youre looking at 1kb vs 10kb intervals
intervals <- read.delim(paste0("../data/refGenome/PFo",intervalSize,".bed"),
                        sep="\t",row.names = NULL,header = F)
colnames(intervals) <- c("scaff","start","end")
intervals$scaff <- as.factor(intervals$scaff)

#### COLLECT SAMPLE NAMES ####
samps <- names(introgressRegionsAll)
sampIndices <- c(0,1,2,3,5,8,9,10)

#### GET LIST OF ALL SCAFFOLDS THAT HAVE BEEN INTROGRESSED ####
introgressScaffs <- c()

#use for loop to gather scaffold names
for(i in 1:length(introgressRegionsAll)){
  introgressScaffs <- c(introgressScaffs, introgressRegionsAll[[i]]$scaff)
}

#keep only those that are unique
introgressScaffs <- unique(introgressScaffs)

#gather scaffolds larger than 1Mb
mbScaffolds <- c()

for(i in levels(intervals$scaff)){
  scaffInts <- subset(intervals, scaff==i)
  if(max(scaffInts$end) >= 1000000){
    mbScaffolds <- c(mbScaffolds,i)
  }
}

#### PLOT ####

#loop through introgressed scaffolds (or scaffolds greater than 1Mb)
for(i in 1:length(introgressScaffs)){
  #### BUILD LONG FORMAT DATA FOR CURRENT SCAFFOLD ####
  #lists
  pos <- list()
  cn <- list()
  samp <- list()
  
  #loop through samples
  for(j in 1:length(samps)){
    
    #load data for current sample
    muDCR <- read.delim(paste0("../outputs/gcnv/rawCalls/",
                               intervalSize,
                               "/SAMPLE_",sampIndices[j],"/mu_denoised_copy_ratio_t.tsv"),
                        sep="\t",row.names = NULL)
    muDCR <- as.numeric(muDCR[4:nrow(muDCR),1])
    
    intervalCNVs <- cbind(intervals,muDCR)
    colnames(intervalCNVs) <- c("scaff","start","end","muDCR")
    
    #subset to scaffold of interest
    intervalCNVs <- subset(intervalCNVs,scaff==introgressScaffs[i])
    
    #extract position, copy number, and sample
    for(k in 1:nrow(intervalCNVs)){
      pos[[length(pos) + 1]] <- mean(c(intervalCNVs$start[k],
                                       intervalCNVs$end[k]))
      samp[[length(samp) + 1]] <- samps[j]
      cn[[length(cn) + 1]] <- intervalCNVs$muDCR[k]
    }
  }
  
  #bind lists
  dat <- as.data.frame(cbind(do.call(rbind,pos),
                      do.call(rbind,cn),
                      do.call(rbind,samp)),)
  colnames(dat) <- c("pos","cn","samp")
  dat$pos <- as.numeric(dat$pos)
  dat$cn <- as.numeric(dat$cn)
  dat$samp <- as.factor(dat$samp)
  
  #clean up
  rm(pos,samp,cn,intervalCNVs)
  
  #### PLOT ####
  
  #set xlims if necessary
  if(intervalSize == "1kb" &&
     max(dat$pos) >= 1000000){
    introgressRegionsDf <- data.frame()
    for(j in 1:length(introgressRegionsAll)){
      introgressRegionsDf <- rbind(introgressRegionsDf,introgressRegionsAll[[j]])
    }
    introgressRegionsDf <- subset(introgressRegionsDf,scaff==introgressScaffs[i])
    xmin <- min(as.numeric(introgressRegionsDf$start)) - 100000
    xmax <- max(as.numeric(introgressRegionsDf$end)) + 100000
    if(xmin < 0){
      xmin <- 0
    } 
    if(xmax > max(dat$pos)){
      xmax <- max(dat$pos)
    }
  } else {
    xmin <- 0
    xmax <- max(dat$pos)
  }
  
  if(intervalSize == "1kb"){
    curScaff <- ggplot(data=dat,aes(x=pos,y=cn))+
      geom_line(mapping=aes(color=dat$samp))+
      scale_color_viridis_d()+
      labs(color=introgressScaffs[i])+
      ylab("Copy number")+
      xlab("Position")+
      ylim(0,5)+
      xlim(xmin,xmax)+
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
  } else {
    curScaff <- ggplot(data=dat,aes(x=pos,y=cn))+
      geom_line(mapping=aes(color=dat$samp))+
      scale_color_viridis_d()+
      labs(color=introgressScaffs[i])+
      ylab("Copy number")+
      xlab("Position")+
      ylim(1,4)+
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
  }
  
  #### SAVE PLOT ####
  ggsave(curScaff,
         filename = paste0("../figures/introgressScaffolds/",
                           intervalSize,
                           "/",
                           introgressScaffs[i],
                           ".pdf"),
         width = 7.47,
         height = 4.90,
         units = "in")
  
}

#### PRETTY SCAFFOLD ####
ggplot(data=dat,aes(x=samp,y=cn))+
  geom_boxplot(mapping=aes(color=dat$samp))+
  scale_color_viridis_d()+
  labs(color=introgressScaffs[i])+
  ylab("Copy number")+
  xlab("Position")+
  ylim(1.5,4)+
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
