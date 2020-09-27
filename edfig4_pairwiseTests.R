## Please change the directory in setwd to the git repo/associated data. The output from the pairwise tests will be saved as a csv that you can open with excel or another program of your choosing

rm(list=ls())
library(effsize)
library(coin)


setwd("C:/Users/kimol/Documents/GitHub/KimOhmaeMedina") # CHANGE THIS TO THE DIRECTORY YOU DOWNLOADED THE REPOSITORY TO

DCNChR2ReboundFR <- as.numeric(unlist(read.csv("edfig4_normReboundFR_DCNChR2.csv", header = FALSE))) # normalized FR during the rebound bin in cells from ChR2 mice on trials with laser and puff stimulation
WTReboundFR <- as.numeric(unlist(read.csv("edfig4_normReboundFR_WT.csv", header = FALSE))) # normalized FR during the rebound bin in cells from the WT mice on extinction trials

shapiroOut<- shapiro.test(c(DCNChR2ReboundFR,WTReboundFR))

if (shapiroOut[2] > 0.05) { # if Shapiro-Wilk test is nonsignificant, then run the pairwise t-test
  ttestOutput<-t.test(DCNChR2ReboundFR, WTReboundFR, paired = FALSE, alternative = "two.sided")
  tval <- as.numeric(ttestOutput[1])
  degf <- as.numeric(ttestOutput[2])
  pval <- as.numeric(ttestOutput[3])
  if (pval < 0.05) {
    d<-cohen.d(DCNChR2ReboundFR, WTReboundFR,pooled=TRUE,paired=FALSE,
             na.rm=FALSE, mu=0, hedges.correction=FALSE,
             conf.level=0.95,noncentral=FALSE,within=TRUE, subject=NA)
  } else {
    d <- rep(NA,3)
  }
  testResults <- data.frame(groupA = "DCNChR2_reboundNormFR",
                            groupB = "WT_reboundNormFR",
                            statistic = tval,
                            df = degf,
                            p = pval,
                            effectsize = as.numeric(d[3]),
                            test = "2 sample ttest",
                            tails = "two.sided")
} else {
  # ranksum for non-paired test
  ranksumOutput<-wilcox.test(DCNChR2ReboundFR, WTReboundFR, paired=FALSE, alternative = "two.sided") # tail specified is that first group is greater than second group
  vval <- as.numeric(ranksumOutput[1])
  pval <- as.numeric(ranksumOutput[3])

 
  testResults <- data.frame(groupA = "DCNChR2_reboundNormFR",
                            groupB = "WT_reboundNormFR",
                            statistic = vval,
                            p = pval,
                            test = "ranksum",
                            tails = "two.sided")
  
}


write.csv(testResults,"edfig4_pairwiseComparisons.csv", row.names = FALSE)
