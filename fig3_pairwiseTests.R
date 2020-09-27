## Please change the directory in setwd to the git repo/associated data. The output from the pairwise tests will be saved as a csv that you can open with excel or another program of your choosing

rm(list=ls())
library(effsize)


setwd("C:/Users/kimol/Documents/GitHub/KimOhmaeMedina")

# data in the following 2 .csv's are listed in the same order as sspkinfo in the fig3_plotAndRMTests.mat
first <- as.numeric(unlist(read.csv("fig3_laserAfterTrial_sspkFRBeginningOfSession.csv", header = FALSE))) # the SSpk FR in the first 10% of the session for each cell
last <- as.numeric(unlist(read.csv("fig3_laserAfterTrial_sspkFREndOfSession.csv", header = FALSE))) # the SSpk FR in the last 10% of the session for each cell

shapiroOut<- shapiro.test(last-first)

if (shapiroOut[2] > 0.05) { # if Shapiro-Wilk test is nonsignificant, then run the pairwise t-test
  ttestOutput<-t.test(first, last, paired = TRUE, alternative = "two.sided")
  tval <- as.numeric(ttestOutput[1])
  degf <- as.numeric(ttestOutput[2])
  pval <- as.numeric(ttestOutput[3])
  if (pval < 0.05) {
    d<-cohen.d(first, last,pooled=TRUE,paired=TRUE,
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
testResults <- data.frame(groupA = "SSpkFR_earlyInSession",
                          groupB = "SSpkFR_lateInSession",
                          statistic = tval,
                          df = degf,
                          p = pval,
                          effectsize = as.numeric(d[3]),
                          test = "paired ttest",
                          tails = "two.sided")

write.csv(testResults,"fig3_pairwiseComparisons.csv", row.names = FALSE)
