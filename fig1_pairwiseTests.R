## Please change the directory in setwd to the git repo/associated data. The output from the pairwise tests will be saved as a csv that you can open with excel or another program of your choosing

rm(list=ls())
library(effsize)


setwd("C:/Users/kimol/Documents/GitHub/KimOhmaeMedina") # CHANGE THIS TO YOUR DATA DIRECTORY

# data in the follwing two .csv files is organized so that data from the same mouse will be imported with the same index
puff <- as.numeric(unlist(read.csv("fig1_normCSpkToPuff.csv", header = FALSE))) # CSpk response of each cell in the 50 ms after the puff on trials without laser stimulation, in units of normalized firing rate (response/baseline firing rate)
laserpuff <- as.numeric(unlist(read.csv("fig1_normCSpkToLaserAndPuff.csv", header = FALSE))) # CSpk response of each cell in the 50 ms after the puff on trials with laser stimulation, in units of normalized firing rate (response/baseline firing rate)

shapiroOut<- shapiro.test(puff-laserpuff)

if (shapiroOut[2] > 0.05) { # if Shapiro-Wilk test is nonsignificant, then run the pairwise t-test
  ttestOutput<-t.test(puff, laserpuff, paired = TRUE, alternative = "two.sided")
  tval <- as.numeric(ttestOutput[1])
  degf <- as.numeric(ttestOutput[2])
  pval <- as.numeric(ttestOutput[3])
  if (pval < 0.05) {
    d<-cohen.d(puff, laserpuff,pooled=TRUE,paired=TRUE,
             na.rm=FALSE, mu=0, hedges.correction=FALSE,
             conf.level=0.95,noncentral=FALSE,within=TRUE, subject=NA)
  } else {
    d <- rep(NA,3)
  }
} else {
  tval <- nan
  degf <- nan
  pval <- nan
  d <- nan
}
testResults <- data.frame(groupA = "NormCSpkFRToPuff",
                          groupB = "NormCSpkToLaserAndPuff",
                          statistic = tval,
                          df = degf,
                          p = pval,
                          effectsize = as.numeric(d[3]),
                          test = "paired ttest",
                          tails = "two.sided")

write.csv(testResults,"fig1_pairwiseComparisons.csv", row.names = FALSE)
