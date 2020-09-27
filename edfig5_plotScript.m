%%% Load data and plot figures for Kim, Ohmae, & Medina (2019 initial
%%% submission Nature Neuroscience)
%%% extended data figure 5 
%%%
%%% NOTE 1: Please enter the directory where you have saved the data files
%%% and the functions included with this Git repo in the lines indicated
%%% with, " % *** YOUR DATA DIRECTORY *** "\
%%%
%%% NOTE 2: I have the figure legends turned off right now, because they
%%% hide some of the data. If you want to see the figure legends, run this
%%% script again but change the plotLegends variable to 1. Set this
%%% variable to anything else if you want to turn legends off.
%%%
%%% Data/information will be loaded in from "fig3_matlabVariables.mat"
%%% Description of variables imported from this file:
%%%     VARIABLE NAME           DESCRIPTION
%%%     crProb_ChR2Acq          each row has data for 1 mouse in the ChR2
%%%                             group, each column has data for a different
%%%                             session. each value is CR probability on a
%%%                             given session (session 1:cols of
%%%                             initial training) for a given mouse. For
%%%                             this variable and all other variables, mice
%%%                             are in the same order as in fig 1 data.
%%%     crProb_ChR2Sav          as crProb_ChR2Acq but contains data from
%%%                             session 1:cols of retraining for a mouse
%%%     crProb_WTAcq            as crProb_ChR2Acq but contains data from
%%%                             session 1:cols of training for a mouse in
%%%                             the WT group
%%%     crProb_WTSav            as crProb_ChR2Acq but contains data from
%%%                             session 1:cols of retraining for a mouse in
%%%                             the WT group
%%%     daysToAcqChR2           each row has data for 1 mouse in the ChR2
%%%                             group. each value is the number of days it
%%%                             took that mouse to reach >50% CRs during
%%%                             initial training
%%%     daysToAcqWT             as daysToAcqChR2 but for the WT group
%%%     daysToSavChR2           as daysToAcqChR2 but for retraining
%%%     daysToSavWT             as daysToAcqChR2 but for retraining in the
%%%                             WT group
%%%     dcnchr2_begsessPerf     each row has data for 1 mouse. mean CR
%%%                             probability in the first block of 10 trials
%%%                             on the 2nd-5th sessions with laser
%%%                             stimulation during the puff in the ChR2
%%%                             group
%%%     dcnchr2_dailyBlockData  each cell shows data for one session.
%%%                             session in col 1 = last baseline session
%%%                             col 2:11 = sessions 1:10 of the laser
%%%                             manipulation
%%%                             each cell contains an array. each row of
%%%                             the array has data from a single mouse.
%%%                             each column of the array has data from a
%%%                             block of 20 trials.
%%%                             data come from mice in the ChR2 group
%%%     dcnchr2_endSessPerf     each row has data for 1 mouse. mean CR
%%%                             probability in the last block of 10 trials
%%%                             on the 1st-4th sessions with laser
%%%                             stimulation during the puff in the ChR2
%%%                             group
%%%     wt_begsessPerf          as dcnchr2_begsessPerf but for WT mice
%%%                             going through extinction
%%%     wt_dailyBlockData       as dcnchr2_dailyBlockData but for WT mice
%%%     wt_endSessPerf          as dcnchr2_endSessPerf but for WT mice
%%%                             going through extinction

%% set up the workspace
clear all
close all

% tell MATLAB where you have saved the data and helper functions
datadir = "C:\Users\kimol\Documents\GitHub\KimOhmaeMedina"; % *** YOUR DATA DIRECTORY ***
cd(datadir)

% default is to not plot legends because they obscure the data
plotLegends = 0;

load('edfig5_matlabVariables.mat')


%% Summary statistics
% rate of task acquisition and reacquisition
disp(['sessions to learn (WT mice): ' num2str(mean(daysToAcqWT)), ...
    ' +/- ', num2str(std(daysToAcqWT)./sqrt(length(daysToAcqWT)))]);
disp(['sessions to relearn (WT mice): ' num2str(mean(daysToSavWT)), ...
    ' +/- ', num2str(std(daysToSavWT)./sqrt(length(daysToSavWT)))]);
disp(['sessions to learn (ChR2 mice): ' num2str(mean(daysToAcqChR2)), ...
    ' +/- ', num2str(std(daysToAcqChR2)./sqrt(length(daysToAcqChR2)))]);
disp(['sessions to learn (ChR2 mice): ' num2str(mean(daysToSavChR2)), ...
    ' +/- ', num2str(std(daysToSavChR2)./sqrt(length(daysToSavChR2)))]);

% performance on first day of savings
disp(['performance in first savings session (ChR2 mice): ' ...
    num2str(mean(CRsBlk1Ret_ChR2)), ' +/- ', ...
    num2str(std(CRsBlk1Ret_ChR2)./sqrt(length(CRsBlk1Ret_ChR2)))]);

%% Plotting data
colordef white

figure

% panel a
% block CR Probs, block 20, DCNChR2 mice
subplot(2,7,[1,2])
hold on
for i = 2:12
    medians = nanmedian(dcnchr2_dailyBlockData{1,i-1});
    bars = mad(dcnchr2_dailyBlockData{1,i-1},1);
    a=errorbar([(i-1)*5-4:(i-1)*5], medians, bars, 'Color', [0 0.75 1], 'LineStyle', 'none');
    set(a, 'CapSize', 0)
    scatter([(i-1)*5-4:(i-1)*5], medians, 5, 'MarkerFaceColor', [0 0.75 1], 'MarkerEdgeColor', [0 0.75 1])
    plot([(i-1)*5+0.5 (i-1)*5+0.5], [0 1], 'LineStyle', '--', 'Color', [0.5 0.5 0.5])
    
    % add the linear fit
    coeffs = polyfit([(i-1)*5-4:(i-1)*5], medians, 1);
    fittedX = linspace((i-1)*5-4, (i-1)*5, 200);
    fittedY = polyval(coeffs, fittedX);
    % Plot the fitted line
    plot(fittedX, fittedY, 'k-');
end
ylim([0 1])
xlim([0.5 55.5])
set(gca,'TickDir','out', 'box', 'off')
ylabel('CR Prob')
title('CN_I_O stimulation n=6')

% panel b
subplot(2,7,3) % spontaneous recovery for ChR2
hold on
meanBoxplot2Groups_jitterDot(dcnchr2_endSessPerf,dcnchr2_begsessPerf, [0 0.75 1], [1 0 0])
set(gca,'TickDir','out')
ylim([0 1])
xlim([0 3])
[h,p,ci,stats] = ttest(dcnchr2_endSessPerf,dcnchr2_begsessPerf);
ylabel('CR Probability')
set(gca, 'XTickLabel', {'','Last','First',''})

% panel c
subplot(2,7,[5,6])
hold on
for i = 2:12
    medians = nanmedian(wt_dailyBlockData{1,i-1});
    bars = mad(wt_dailyBlockData{1,i-1},1);
    a=errorbar([(i-1)*5-4:(i-1)*5], medians, bars, 'Color', [0 0 0], 'LineStyle', 'none');
    set(a, 'CapSize', 0)
    scatter([(i-1)*5-4:(i-1)*5], medians, 5, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
    plot([(i-1)*5+0.5 (i-1)*5+0.5], [0 1], 'LineStyle', '--', 'Color', [0.5 0.5 0.5])
    
    % add the linear fit
    coeffs = polyfit([(i-1)*5-4:(i-1)*5], medians, 1);
    fittedX = linspace((i-1)*5-4, (i-1)*5, 200);
    fittedY = polyval(coeffs, fittedX);
    % Plot the fitted line
    plot(fittedX, fittedY, 'k-', 'LineWidth', 2);
end
ylim([0 1])
xlim([0.5 55.5])
ylabel('CR Prob')
title('Extinction n = 5')
xlabel('Session')
set(gca,'TickDir','out')


% panel d
subplot(2,7,7) % spontaneous recovery for WT
hold on
meanBoxplot2Groups_jitterDot(wt_endSessPerf, wt_begsessPerf, [0 0 0], [1 0 0])
set(gca,'TickDir','out')
ylim([0 1])
xlim([0 3])
ylabel('CR Probability')
set(gca, 'XTickLabel', {'','','Last','','First','',''})

% panel e
subplot(2,7,[8,9])
hold on
a = errorbar([1:13],nanmedian(crProb_ChR2Acq), mad(crProb_ChR2Acq,1), '.', 'LineStyle', 'none', 'Color', [0 0.75 1]);
set(a,'CapSize',0,'MarkerSize',10)
b = errorbar([1:6],nanmedian(crProb_ChR2Sav), mad(crProb_ChR2Sav,1), 's', 'LineStyle', 'none', 'Color', [0 0.75 1]);
set(b,'CapSize',0,'MarkerSize',4)
xlim([0.5 10.5])
ylim([0 0.85])
xlabel('session')
ylabel('CR Probability')
if plotLegends == 1
    legend('Acquisition, ChR2', 'Savings, ChR2', 'Location', 'NorthEast')
end

% panel f
subplot(2,7,10)
meanBoxplot2Groups_jitterDot(daysToAcqChR2, daysToSavChR2, [0 0.75 1], [1 0 0])
ylabel(['Sessions to Reach Criterion'])
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'Acq','Sav'})
ylim([0 15])

% panel g
subplot(2,7,[12,13])
hold on
e =  errorbar([1:13],nanmedian(crProb_WTAcq), mad(crProb_WTAcq,1), '.', 'LineStyle', 'none', 'Color', [0 0 0]);
set(e,'CapSize',0,'MarkerSize',10)
f =  errorbar([1:5],nanmedian(crProb_WTSav), mad(crProb_WTSav,1), 's', 'LineStyle', 'none', 'Color', [0 0 0]);
set(f,'CapSize',0,'MarkerSize',4)
xlim([0.5 10.5])
xlabel('session')
ylabel('CR Probability')
if plotLegends == 1
    legend('Acquisition, WT', 'Savings, WT', 'Location', 'NorthEast')
end
ylim([0 0.85])

% panel h
subplot(2,7,14)
meanBoxplot2Groups_jitterDot(daysToAcqWT, daysToSavWT, [0 0 0], [1 0 0])
ylim([0 15])
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'Acq','Sav'})

