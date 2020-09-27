%%% Load data and plot figures for Kim, Ohmae, & Medina (2019 initial
%%% submission Nature Neuroscience). 
%%% extended data figure 4
%%% This function will also fun the Monte Carlo analysis for detecting 
%%% whether a cell shows a complex spike rebound after its pause. The
%%% Monte Carlo analysis is commented out right now, because it takes a
%%% long time to run. Please uncomment lines 123-157 to run the Monte Carlo
%%% analysis.
%%%
%%% NOTE: the timestamp labels correspond to the bin centers, but, in the 
%%% paper, the x-axis labels are on the bin edges. I wasn't sure how to get
%%% the bin edges labelled in matlab, so I just used the bin centers and
%%% corrected things in FyPlot.
%%%
%%% Data/information will be loaded in from "edfig4_matlabVariables.mat"
%%% Description of variables imported from this file:
%%%     VARIABLE NAME           DESCRIPTION
%%%     bincenters              time at the center of bins containing
%%%                             histogram data. The end of the pause is at
%%%                             time 0 (0 not represented here because
%%%                             these are the bin CENTERS). units are ms.
%%%     DCNChR2_50msBinnedCSpkFR array containing the average CSpk FR
%%%                             (normalized by Hz/Hz at baseline) in 50 ms
%%%                             bins around the time of the pause. each
%%%                             row shows data from a different neuron and
%%%                             each column shows data from a different
%%%                             bin. bin timing corresponds to the bin
%%%                             centers in bincenters. Data are from mice
%%%                             with ChR2 in the DCN that received laser +
%%%                             puff trials.
%%%     DCNChR2_baselineNormFR  cell array with binned CSpk FR data (50 ms
%%%                             bins) from the pre-stimulus period on each
%%%                             trial. each cell contains an array that
%%%                             shows the trial-by-trial binned FRs from
%%%                             each Purkinje cell. Rows correspond to
%%%                             trials, and each column corresponds to a
%%%                             different 50 ms bin (in chronological
%%%                             order). Contains data from mice with ChR2
%%%                             in the DCN that recevied laser + puff
%%%                             trials.
%%%     DCNChR2_reboundLogical  1 if the corresponding cell from
%%%                             DCNChR2_baselineNormFR and
%%%                             DCNChR2_50msBinnedCSpkFR showed a rebound.
%%%                             0 if not. Data are from mice
%%%                             with ChR2 in the DCN that received laser +
%%%                             puff trials.
%%%     DCNChR2_reboundNormFR   array with the CSpk FR in the 50 ms bin
%%%                             after a laser induced pause. The end of the
%%%                             pause was defined as the last 50 ms bin in
%%%                             which a cell was silent across all trials. 
%%%                             Data are from mice with ChR2 in the DCN
%%%                             that received laser + puff trials.
%%%     dcnchr2histvals         Normalized firing rate histogram, averaged
%%%                             across neurons from mice with ChR2 in the
%%%                             DCN. Timing corresponds to timing in
%%%                             bincenters.
%%%     WT_baselineNormFR       as DCNChR2_baselineNormFR, but for WT mice
%%%                             that were not puffed on trials with big CRs
%%%     WT_reboundLogical       as DCNChR2_reboundLogical, but for WT mice
%%%                             that were not puffed on trials with big CRs
%%%     WT_reboundNormFR        as DCNChR2_reboundNormFR, but for WT mice
%%%                             that were not puffed on trials with big CRs
%%%     wthistvals              as dcnchr2histvals, but for WT mice
%%%                             that were not puffed on trials with big CRs

clear all
close all

cd('C:\Users\kimol\Documents\GitHub\KimOhmaeMedina')

load('edfig4_matlabVariables.mat');

% DCN ChR2 heat plot
figure
subplot(2,7,[8 9])
heatmap(binCenters, 1:size(DCNChR2_50msBinnedCSpkFR,1), DCNChR2_50msBinnedCSpkFR, 'colormap', hotmap)
caxis([0 8])
%title('normalized heatmap for DCN ChR2 mice, 50 ms bins')
xlabel('bin center time relative to pause end')
ylabel('CSpk FR (norm Hz)')

% WT mouse heat plot
subplot(2,7,[11 12])
heatmap(binCenters, 1:size(WT_50msBinnedCSpkFR,1), WT_50msBinnedCSpkFR, 'colormap', hotmap)
%title('normalized heatmap for Shogo mice, 50 s bins')
caxis([0 8])
xlabel('bin center time relative to pause end')

% DCN-ChR2 histogram
subplot(2,7,[1 2])
bar(binCenters, dcnchr2histvals, 'BarWidth', 1, 'FaceColor', [0 0.75 1], 'EdgeColor', [0 0.75 1])
xlim([-300, 200])
ylim([0 3])
ylabel('CSpk FR (norm Hz)')
title('CN_IO Stimulation')

% WT histogram
subplot(2,7,[4 5])
bar(binCenters, wthistvals, 'BarWidth', 1, 'FaceColor', [0 0 0], 'EdgeColor', [0 0 0])
xlim([-300, 200])
ylim([0 3])
title('Extinction')

% boxplots
% these data are the output from my initial run through the bootstrapping analysis
subplot(2,7,[7 14])
plot([0.5 2.5], [1 1], 'Color', [0 0 0], 'LineStyle', '--')
meanBoxplot(DCNChR2_reboundNormFR,1,0.5,[0 0 1])
scatter(ones(sum(DCNChR2_reboundLogical),1), DCNChR2_reboundNormFR(DCNChR2_reboundLogical==1), 20, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
scatter(ones(length(DCNChR2_reboundLogical)-sum(DCNChR2_reboundLogical),1), DCNChR2_reboundNormFR(DCNChR2_reboundLogical==0), 20, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [1 1 1])
text(1, 6.75, [num2str(sum(DCNChR2_reboundLogical)),'/',num2str(length(DCNChR2_reboundLogical))])
% WT box and dot plot
meanBoxplot(WT_reboundNormFR,2,0.5,[0 0 0])
scatter(ones(sum(WT_reboundLogical),1)*2, WT_reboundNormFR(WT_reboundLogical==1), 20, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
scatter(ones(length(WT_reboundLogical)-sum(WT_reboundLogical),1)*2, WT_reboundNormFR(WT_reboundLogical==0), 20, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [1 1 1])
text(2, 7.75, [num2str(sum(WT_reboundLogical)),'/',num2str(length(WT_reboundLogical))])
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'DCNChR2', 'WT'})
ylabel('Rebound FR/Baseline FR')



%% bootstrapping analysis with Monte Carlo algorithm
% the following part of the code is commented out, because it takes a very
% long time to run and I didn't want a user to be surprised by this script
% locking up their computer for a while
% to run the Monte Carlo algorithm described in the paper on thses data,
% simply highlight all lines past 98 and hit Ctrl+T to uncomment
% the right stuff
% 
% NOTE: the ouputs of this section vary from run to run, since the
% bootstrap distribution is randomly sampled

% binedges = [0:0.1:20]; % bin size for plotting output hists
% plotOutput = 0; % don't plot output. set to 1 to plot bootstrap distributions as they are made. makes code slower.
% [exceeds99PctBootstrap_DCN] = monteCarlo(binedges, DCNChR2_baselineNormFR, DCNChR2_reboundNormFR, plotOutput);
% [exceeds99PctBootstrap_WT] = monteCarlo(binedges, WT_baselineNormFR, WT_reboundNormFR, plotOutput);
% 
% 
% figure
% % boxplots are mean +/- SEM with whiskers to min and max of distribution
% meanBoxplot(DCNChR2_reboundNormFR,1,0.5,[0 0.75 1])
% scatter(ones(sum(exceeds99PctBootstrap_DCN(:,2)),1), DCNChR2_reboundNormFR(exceeds99PctBootstrap_DCN(:,2)==1), 20, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
% scatter(ones(length(exceeds99PctBootstrap_DCN(:,2))-sum(exceeds99PctBootstrap_DCN(:,2)),1), DCNChR2_reboundNormFR(exceeds99PctBootstrap_DCN(:,2)==0), 20, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [1 1 1])
% text(0.75, 7.75, [num2str(sum(exceeds99PctBootstrap_DCN(:,2))),'/',...
%     num2str(length(exceeds99PctBootstrap_DCN(:,2))),' cells']) % number of cells that show higher FRs in the rebound window than 99% of the bootstrapped distribution
% 
% meanBoxplot(WT_reboundNormFR,2,0.5,[0 0 0])
% scatter(ones(sum(exceeds99PctBootstrap_WT(:,2)),1)*2, WT_reboundNormFR(exceeds99PctBootstrap_WT(:,2)==1), 20, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
% scatter((ones(length(exceeds99PctBootstrap_WT(:,2))-sum(exceeds99PctBootstrap_WT(:,2)),1))*2, WT_reboundNormFR(exceeds99PctBootstrap_WT(:,2)==0), 20, 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [1 1 1])
% text(1.75, 7.75, [num2str(sum(exceeds99PctBootstrap_WT(:,2))),'/',...
%     num2str(length(exceeds99PctBootstrap_WT(:,2))),' cells']) % number of cells that show higher FRs in the rebound window than 99% of the bootstrapped distribution
% 
% xlim([0.5 2.5])
% ylabel('Rebound FR/Baseline FR')
% xticks([1,2])
% xticklabels({'ChR2', 'WT'})
% title('Filled = cell with rebound compared to bootstrapped distribution')



    
    