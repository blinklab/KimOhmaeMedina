## Please change the directory in setwd to the git repo/associated data. Please view output in the R console.

# For more information on the nparLD test, check out the R documentation. Additional information is available in Noguchi et al., 2012;
# "nparLD: An R Software Package for the Nonparametric Analysis of Longitudinal Data in Factorial Experiments" Journal of Statistical
# Software, Vol 50 Issue 12

rm(list=ls())

library(nparLD)

setwd("C:/Users/kimol/Documents/GitHub/KimOhmaeMedina")

# each row of the table contains CR probability data for a single session. The mouse (identifier according to the same key as in Extended Data Fig. 3, and group) and session are specified.
# session       manipulation day
#   1             last pre-laser or pre-extinction baseline
#   2-5           sessions 1-4 of the laser manipulation or the extinction manipulation (depending on group)
#   6-7           last 2 sessions of the laser manipulation or the extinction manipulation (depending on group)
T<-read.csv("fig2_nparLDData.csv", header = TRUE)

boxplot(cr_prob ~ group * session, data = T, names = FALSE,  col = c("cyan", "darkgrey"), lwd = 2, ylim = c(0,1))
axis(1, at = 1.5, labels = "Baseline", font = 2, cex = 2)
axis(1, at = 3.5, labels = "Laser 1", font = 2, cex = 2)
axis(1, at = 5.5, labels = "Laser 2", font = 2, cex = 2)
axis(1, at = 7.5, labels = "Laser 3", font = 2, cex = 2)
axis(1, at = 9.5, labels = "Laser 4", font = 2, cex = 2)
axis(1, at = 11.5, labels = "Laser L-1", font = 2, cex = 2)
axis(1, at = 13.5, labels = "Last Laser", font = 2, cex = 2)
legend(1, 0.2, c("ChR2", "WT"), lwd = c(3, 3, 3),   col = c("cyan", "darkgrey"), cex = 1)
ex.f1f1np <- nparLD(cr_prob ~ group * session, data = T,  subject = "mouse", description = FALSE)
summary(ex.f1f1np)


