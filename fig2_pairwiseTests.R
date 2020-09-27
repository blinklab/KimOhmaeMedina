## Please change the directory in setwd to the git repo/associated data. The output from the pairwise tests will be saved as a csv that you can open with excel or another program of your choosing

rm(list=ls())
library(effsize)


setwd("C:/Users/kimol/Documents/GitHub/KimOhmaeMedina")

load("fig2_pairwiseCompData.Rda") # the data loaded into this dataframe are fairly self-explanatory (they are labeled in the data frame). CR amplitude data are the median CR Amplitudes from each specified session.

attach(fig2DataFrame)

# paired comparison between CR Amplitudes in the first retraining session and CR Amplitudes in the last baseline session (check if extinction effect persists through the retraining)
retrainFirstIdx <- session=="Retraining1" & measurement=="CRAmp"
cramp_retraining1 <- value[retrainFirstIdx]

lastBaselineCRAmpIdx <- session=="LastBaseline" & measurement=="CRAmp"
cramp_lastBaseline <- value[lastBaselineCRAmpIdx]

shapiroOut <- shapiro.test(cramp_lastBaseline-cramp_retraining1)

if (shapiroOut[2] > 0.05) { # if Shapiro-Wilk test is nonsignificant, then run the pairwise t-test
  ttestOutput<-t.test(cramp_lastBaseline, cramp_retraining1, paired = TRUE, alternative = "two.sided")
  tval <- as.numeric(ttestOutput[1])
  degf <- as.numeric(ttestOutput[2])
  pval <- as.numeric(ttestOutput[3])
  if (pval < 0.05) {
    d<-cohen.d(cramp_lastBaseline, cramp_retraining1,pooled=TRUE,paired=TRUE,
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
testResults <- data.frame(groupA = "CRAmp_lastBaseline",
                          groupB = "CRAmp_firstRetraining",
                          statistic = tval,
                          df = degf,
                          p = pval,
                          effectsize = as.numeric(d[3]),
                          test = "paired ttest",
                          tails = "two.sided")



# paired comparison between CR amplitudes in the last baseline session and the fourth retraining session (do animals relearn to the same level?)
retrainFourthIdx <- session=="Retraining4" & measurement=="CRAmp"
cramp_retraining4 <- value[retrainFourthIdx]

shapiroOut <- shapiro.test(cramp_lastBaseline-cramp_retraining4)

if (shapiroOut[2] > 0.05) { # if Shapiro-Wilk test is nonsignificant, then run the pairwise t-test
  ttestOutput<-t.test(cramp_lastBaseline, cramp_retraining4, paired = TRUE, alternative = "two.sided")
  tval <- as.numeric(ttestOutput[1])
  degf <- as.numeric(ttestOutput[2])
  pval <- as.numeric(ttestOutput[3])
  if (pval<0.05) {
    d<-cohen.d(cramp_lastBaseline, cramp_retraining4,pooled=TRUE,paired=TRUE,
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


tempFrame <- data.frame(groupA = "CRAmp_lastBaseline",
                        groupB = "CRAmp_Retraining4",
                        statistic = tval,
                        df = degf,
                        p = pval,
                        effectsize = as.numeric(d[3]),
                        test = "paired ttest",
                        tails = "two.sided")
testResults <- rbind(testResults, tempFrame)


write.csv(testResults,"fig2_pairwiseComparisons.csv", row.names = FALSE)

detach(fig2DataFrame)
