#### LIBRARIES ####
library(vcfR)
library(dplyr)
library(tidyr)
library(ggplot2)

#### READ DATA ####
dat <- read.vcfR("../data/Amm_ammgenome.var4.contiglist.1-1000.vcf")

#### GET GENOTYPES AND DEPTHS FOR SNPS ####
gts <- extract.gt(dat)
dpt <- extract.gt(dat,element="DP")

#### MODIFY DEPTH DF ####
#add columns to SNP depth df
scaffPos <- strsplit(rownames(dpt),"_")
dpt <- as.data.frame(dpt)

scaffNames <- vector("list",100000)
posNames <- vector("list",100000)

#fill lists
for(i in 1:nrow(dpt)){
  scaffNames[[i]] <- scaffPos[[i]][1]
  posNames[[i]] <- scaffPos[[i]][2]
}

#bind to df
dpt <- cbind(dpt,
             do.call(rbind,scaffNames),
             do.call(rbind,posNames))

colnames(dpt) <- c(colnames(dpt)[1:4],"scaffold","pos")

#convert to long
dptL <- gather(dpt,sample,depth,sample1:sample4)

#### SUBSET SCAFFOLDS AND PLOT ####

#get scaffolds which are represented by >30 SNPS
scaffSNPs <- table(as.factor(dpt$scaffold))
scaffList <- names(which(scaffSNPs >= 50))

for(i in 1:length(scaffList)){
  currScaff <- subset(dptL,scaffold==scaffList[i])
  
  currScaff <- currScaff %>%
    mutate(across(c(1:2,4),as.numeric))
  
  #make plot
  currScaffPlot <- ggplot(data=currScaff,aes(x=pos,y=depth))+
    geom_point(mapping=aes(color=currScaff$sample))+
    scale_color_viridis_d()+
    scale_y_continuous(name="Depth")+
    xlab("Position")+
    labs(color=scaffList[i])+
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background= element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.y = element_text(size = 10),
          axis.title = element_text(face = "bold",
                                    size = 10),
          legend.title = element_text(face = "bold",
                                      size = 10),
          plot.title = element_text(face = "bold",
                                    size = 17,
                                    hjust=0.5))
  
  plot(currScaffPlot)
}


currScaff <- subset(dptL,scaffold=="24334300")

#### LOOP THROUGH SCAFFOLDS AND DETERMINE CANDIDATE REGIONS OF INTROGRESSION ####
candIntroList <- vector("list",100000)

for(i in 1:length(scaffList)){
  for(j in 1:length(levels(factor(dptL$sample)))){
    #get current working df
    currScaff <- subset(dptL,scaffold==scaffList[i] & 
                          sample == levels(factor(dptL$sample))[j])
    
    #mutate
    currScaff <- currScaff %>%
      mutate(across(c(1:2,4),as.numeric))
    
    #set index variable
    index <- 2
    
    #move through current scaffold/individual
    while(index < nrow(currScaff)){
      if(currScaff$depth[index] >= 3*currScaff$depth[index-1]){
        indexInternal <- 1
        while(currScaff$depth[index + indexInternal] <= 
              3*currScaff$depth[index + indexInternal - 1])
      }
    }
  }
}


ggplot(data=currScaff,aes(x=sample,y=as.numeric(depth),fill=sample))+
  geom_violin()+
  #geom_jitter(alpha=0.5,size=0.75,position=position_jitterdodge())+
  scale_fill_viridis_d()+
  scale_y_continuous(name="Depth")+
  xlab("Position")+
  labs(color=scaffList[i])+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background= element_blank(),
        axis.line = element_line(colour = "black"),
        axis.text.y = element_text(size = 10),
        axis.title = element_text(face = "bold",
                                  size = 10),
        legend.title = element_text(face = "bold",
                                    size = 10),
        plot.title = element_text(face = "bold",
                                  size = 17,
                                  hjust=0.5))

