## Please change the directory in setwd to the git repo/associated data. The output from the pairwise tests will be saved as a csv that you can open with excel or another program of your choosing

rm(list=ls())
library(effsize)
library(coin)


setwd("C:/Users/kimol/Documents/GitHub/KimOhmaeMedina")

# set up local function for checking the type of pairwise test to be run and returning the stats
runPairwise <- function(a,b, isPaired, tailsToUse){
  sOut <- shapiro.test(a-b)
  if (sOut[2]>0.05) {
    ttestOutput<-t.test(a, b, paired = isPaired, alternative = tailsToUse)
    tval <- as.numeric(ttestOutput[1])
    degf <- as.numeric(ttestOutput[2])
    pval <- as.numeric(ttestOutput[3])
    if (pval < 0.05) {
      d<-cohen.d(a, b,pooled=TRUE,paired=isPaired,
                 na.rm=FALSE, mu=0, hedges.correction=FALSE,
                 conf.level=0.95,noncentral=FALSE,within=TRUE, subject=NA)
    } else {
      d <- rep(NA,3)
    }
    
    test <- "ttest"
    statistic <- tval
    effsize <- as.numeric(d[3])
    
  } else {
    wilcoxOutput<-wilcox.test(a, b, paired=isPaired, alternative = tailsToUse)
    vval <- as.numeric(wilcoxOutput[1])
    pval <- as.numeric(wilcoxOutput[3])
    # need to check if paired and add the exact wilcox test
    if (isPaired==TRUE) {
      exactSignrankOutput<-wilcoxsign_test(a ~ b, distribution="exact", alternative = tailsToUse)
      zval <- as.numeric(exactSignrankOutput@statistic@teststatistic)
      pval <- as.numeric(exactSignrankOutput@distribution@pvalue(exactSignrankOutput@statistic@teststatistic))
      rval<-zval/sqrt(length(a))
      
      test <- "signrank"
      statistic <- zval
      effsize <- rval
    } else {
      test <- "ranksum"
      statistic <- vval
      effsize <- NaN
    }
    
    degf <- NaN
  }
  
  output<- data.frame(type = test,
                      statOut = statistic,
                      p = pval,
                      df = degf,
                      effectSize = effsize)
  return(output)
}

# pairwise test to check if there is spontaneous recovery in the ChR2 group @ the laser-during-puff manipulation
chr2SpontRecFiles <- list.files(path = ".", pattern = 'edfig5.*Las.*csv', all.files = FALSE,
                                full.names = FALSE, recursive = FALSE, ignore.case = FALSE,
                                include.dirs = FALSE, no.. = FALSE)
begsess <- as.numeric(unlist(read.csv(chr2SpontRecFiles[1], header = FALSE)))
endsess <- as.numeric(unlist(read.csv(chr2SpontRecFiles[2], header = FALSE)))
tailsToUse<-"two.sided"
pairwiseResult <- runPairwise(begsess,endsess,isPaired=TRUE,tailsToUse)
testResults <- data.frame(groupA = "beginningOfLaserSessions",
                          groupB = "endOfLaserSessions",
                          statistic = pairwiseResult[2],
                          df = pairwiseResult[4],
                          p = pairwiseResult[3],
                          effectsize = pairwiseResult[5],
                          test = pairwiseResult[1],
                          tails = tailsToUse)


wtSpontRecFiles <- list.files(path = ".", pattern = 'edfig5.*Ext.*csv', all.files = FALSE,
                                full.names = FALSE, recursive = FALSE, ignore.case = FALSE,
                                include.dirs = FALSE, no.. = FALSE)
begsess <- as.numeric(unlist(read.csv(wtSpontRecFiles[1], header = FALSE)))
endsess <- as.numeric(unlist(read.csv(wtSpontRecFiles[2], header = FALSE)))
tailsToUse<-"two.sided"
pairwiseResult <- runPairwise(begsess,endsess,isPaired=TRUE,tailsToUse)
tempFrame <- data.frame(groupA = "beginningOfExtinctionSessions",
                          groupB = "endOfExtinctionSessions",
                          statistic = pairwiseResult[2],
                          df = pairwiseResult[4],
                          p = pairwiseResult[3],
                          effectsize = pairwiseResult[5],
                          test = pairwiseResult[1],
                          tails = tailsToUse)
testResults <- rbind(testResults, tempFrame)

ChR2SavFiles <- list.files(path = ".", pattern = 'edfig5.*ChR2.*csv', all.files = FALSE,
                              full.names = FALSE, recursive = FALSE, ignore.case = FALSE,
                              include.dirs = FALSE, no.. = FALSE)
sess2Acq <- as.numeric(unlist(read.csv(ChR2SavFiles[1], header = FALSE)))
sess2Sav <- as.numeric(unlist(read.csv(ChR2SavFiles[2], header = FALSE)))
tailsToUse<-"greater"
pairwiseResult <- runPairwise(sess2Acq,sess2Sav,isPaired=TRUE,tailsToUse)
tempFrame <- data.frame(groupA = "ChR2MouseSessionsToLearn",
                        groupB = "ChR2MouseSessionsToRelearn",
                        statistic = pairwiseResult[2],
                        df = pairwiseResult[4],
                        p = pairwiseResult[3],
                        effectsize = pairwiseResult[5],
                        test = pairwiseResult[1],
                        tails = tailsToUse)
testResults <- rbind(testResults, tempFrame)


WTSavFiles <- list.files(path = ".", pattern = 'edfig5.*WT.*csv', all.files = FALSE,
                           full.names = FALSE, recursive = FALSE, ignore.case = FALSE,
                           include.dirs = FALSE, no.. = FALSE)

sess2Acq <- as.numeric(unlist(read.csv(WTSavFiles[1], header = FALSE)))
sess2Sav <- as.numeric(unlist(read.csv(WTSavFiles[2], header = FALSE)))
tailsToUse<-"greater"
pairwiseResult <- runPairwise(sess2Acq,sess2Sav,isPaired=TRUE,tailsToUse)
tempFrame <- data.frame(groupA = "WTMouseSessionsToLearn",
                        groupB = "WTMouseSessionsToRelearn",
                        statistic = pairwiseResult[2],
                        df = pairwiseResult[4],
                        p = pairwiseResult[3],
                        effectsize = pairwiseResult[5],
                        test = pairwiseResult[1],
                        tails = tailsToUse)
testResults <- rbind(testResults, tempFrame)

write.csv(testResults,"edfig5_pairwiseComparisons.csv", row.names = FALSE)
