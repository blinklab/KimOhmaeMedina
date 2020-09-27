## Please change the directory in setwd to the git repo/associated data. The output from the pairwise tests will be saved as a csv that you can open with excel or another program of your choosing

rm(list=ls())
library(effsize)
library(coin)
library(nlme)
library(ggpubr)
library(rstatix)



setwd("C:/Users/kimol/Documents/GitHub/KimOhmaeMedina")

# check normality for friedman tests
T<-read.csv("NormCRProbxURDurData.csv", header = TRUE)
#ggboxplot(T, x = "session", y = "ur_dur", add = "point")
shapiroOut <- shapiro_test(mean(T$ur_dur, na.rm=TRUE)-T$ur_dur)
if (shapiroOut[3] > 0.05) {
  T$sessnum <- as.factor(T$session)
  T$mouseid <- as.factor(T$mouse)
  res.aov <- anova_test(cr_prob ~ session, data = T, dv = "cr_prob", wid = mouseid, within = session) # need to return here to format data output
  vals <- get_anova_table(res.aov)
}

#ggboxplot(T, x = "session", y = "cr_prob", add = "point")
shapiroOut <- shapiro_test(mean(T$cr_prob)-T$cr_prob)
if (shapiroOut[3] > 0.05) {
  T$sessnum <- as.factor(T$session)
  T$mouseid <- as.factor(T$mouse)
  res.aov <- anova_test(cr_prob ~ session, data = T, dv = "cr_prob", wid = mouseid, within = session)
  vals <- get_anova_table(res.aov)
}


# set up local function for checking the type of pairwise test to be run and returning the stats
runPairwise <- function(a,b, isPaired, tailsToUse){
  sOut <- shapiro.test(a-b)
  
  ttestOutput<-t.test(a, b, paired = isPaired, na.rm=TRUE, alternative = tailsToUse)
  tval <- as.numeric(ttestOutput[1])
  degf <- as.numeric(ttestOutput[2])
  pval <- as.numeric(ttestOutput[3])
  if (pval < 0.05) {
    d<-cohen.d(a, b,pooled=TRUE,paired=isPaired,
               na.rm=TRUE, mu=0, hedges.correction=FALSE,
               conf.level=0.95,noncentral=FALSE,within=TRUE, subject=NA)
  } else {
    d <- rep(NA,3)
  }
  
  test <- "ttest"
  statistic <- tval
  effsize <- as.numeric(d[3])
  
  
  output<- data.frame(type = test,
                      statOut = statistic,
                      p = pval,
                      df = degf,
                      effectSize = effsize)
  return(output)
}


# pairwise test to check if there is spontaneous recovery in the ChR2 group @ the laser-during-puff manipulation
urAmpFiles <- list.files(path = ".", pattern = 'edfig6.*Amp.*csv', all.files = FALSE,
                                full.names = FALSE, recursive = FALSE, ignore.case = FALSE,
                                include.dirs = FALSE, no.. = FALSE)
urAmpNoLaser <- as.numeric(unlist(read.csv(urAmpFiles[1], header = FALSE)))
urAmpWithLaser <- as.numeric(unlist(read.csv(urAmpFiles[2], header = FALSE)))
tailsToUse<-"two.sided"
pairwiseResult <- runPairwise(urAmpNoLaser,urAmpWithLaser,isPaired=TRUE,tailsToUse)
testResults <- data.frame(groupA = "urAmpNoLaser",
                          groupB = "urAmpWithLaser",
                          statistic = pairwiseResult[2],
                          df = pairwiseResult[4],
                          p = pairwiseResult[3],
                          effectsize = pairwiseResult[5],
                          test = pairwiseResult[1],
                          tails = tailsToUse)

urDurFiles <- list.files(path = ".", pattern = 'edfig6.*Dur.*csv', all.files = FALSE,
                         full.names = FALSE, recursive = FALSE, ignore.case = FALSE,
                         include.dirs = FALSE, no.. = FALSE)
urDurNoLaser <- as.numeric(unlist(read.csv(urDurFiles[1], header = FALSE)))
urDurWithLaser <- as.numeric(unlist(read.csv(urDurFiles[2], header = FALSE)))
tailsToUse<-"two.sided"
pairwiseResult <- runPairwise(urDurNoLaser,urDurWithLaser,isPaired=TRUE,tailsToUse)
tempFrame <- data.frame(groupA = "urDurNoLaser",
                          groupB = "urDurWithLaser",
                          statistic = pairwiseResult[2],
                          df = pairwiseResult[4],
                          p = pairwiseResult[3],
                          effectsize = pairwiseResult[5],
                          test = pairwiseResult[1],
                          tails = tailsToUse)
testResults <- rbind(testResults, tempFrame)

write.csv(testResults,"edfig6_pairwiseComparisons.csv", row.names = FALSE)
