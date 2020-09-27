%%% Load and plot data for Kim, Ohmae, & Medina (2019 initial
%%% submission Nature Neuroscience). 
%%% extended data figure 1
%%%
%%% NOTE: Please enter the directory where you have saved the data files
%%% and the functions included with this Git repo in the lines indicated
%%% with, " % *** YOUR DATA DIRECTORY *** "
%%%
%%% NOTE 2: I have the figure legends turned off right now, because they
%%% hide some of the data. If you want to see the figure legends, run this
%%% script again but change the plotLegends variable to 1. Set this
%%% variable to anything else if you want to turn legends off.
%%%
%%% Data/information will be loaded in from "edfig1_matlabVariables.mat"
%%% Description of variables imported from this file:
%%%     VARIABLE NAME           DESCRIPTION
%%%     virusmicePerformance    each columnn shows data from one mouse
%%%                             injected with AAV1/9-?CaMKII-Arch-GFP. NaN
%%%                             means data could not be collected on that
%%%                             day. each cell shows CR probability on a
%%%                             session, with each row corresponding to one
%%%                             session.
%%%     virusmouseeyetracedaykey days that get plotted in the eyetrace
%%%                             graph for these virus mice
%%%     virusMouseEyetraces     mean eyelid traces for the virus mouse that
%%%                             made it through the most training days,
%%%                             sesions indicated in
%%%                             virusmouseeyetracedaykey. Each column
%%%                             holds data from one sessiona and each row
%%%                             holds data from one 5-ms bin
%%%     virusMouseTimeVector    timetamps for eyelidtrace data bins
%%%     wteyetracedaykey        days that get plotted in the eyetrace graph
%%%                             for these WT mice
%%%     wtmiceMeanEyetraces     mean eyelid traces for the WT mice shown in
%%%                             the figure. Each column holds data from one
%%%                             session, and each row holds data from one
%%%                             5-ms bin. sessions specified in
%%%                             wteyetracedaykey.
%%%     wtmiceMean              mean of cr probabilities for WT mouse
%%%                             performance shown in the figure
%%%     wtmicePerformance       cr probabilities for individual mice
%%%                             (columns) on training days (rows) 
%%%     wtMouseTimeVector       timetamps for eyelidtrace data bins


%% set up the workspace
clear all
close all

% tell MATLAB where you have saved the data and helper functions
datadir = "C:\Users\kimol\Documents\GitHub\KimOhmaeMedina"; % *** YOUR DATA DIRECTORY ***
cd(datadir)

load('edfig1_matlabVariables.mat') % load the data associated with figure 1

% default is to not plot legends because they obscure the data
plotLegends = 0;

%% plot figure
% panel g
figure
subplot(1,3,1)
plot(wtmicePerformance, 'Color', [0.45 0.45 0.45])
hold on
plot(wtmiceMean(:,1), 'Color', [0 0 0], 'LineWidth', 2)
plot(virusmicePerformance(:,3), 'Color', [0 0.75 0])
plot(virusmicePerformance(:,2), 'Color', [0 0.75 1])
plot(virusmicePerformance(:,1), 'Color', [1 0 1])
ylabel('CR Probability')
xlabel('Days of Training')
title('grey = WT mice, color = WT mice with virus')
set(gca, 'Box', 'off', 'TickDir', 'out')

% panel h
subplot(1,3,2)
plot([250 250], [0 1], 'Color', [0 0 0])
hold on
plot(wtmiceMeanEyetraces)
ylim([0 1])
xlim([0 300])
ylabel('FEC')
xlabel('Time from CS onset (ms)')
if plotLegends == 1
    legend({'puff time', 'Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 8', 'Day 14'}, 'Location', 'NorthWest')
end
title('WT mice, no virus')

% panel i
subplot(1,3,3)
plot([250 250], [0 1], 'Color', [0 0 0])
hold on
plot(virusMouseTimeVector, virusMouseEyetraces)
ylim([0 1])
xlim([0 300])
ylabel('FEC')
xlabel('Time from CS onset (ms)')
if plotLegends == 1
    legend({'puff time', 'Day 7', 'Day 8', 'Day 9', 'Day 10', 'Day 11', 'Day 12', 'Day 13'}, 'Location', 'NorthWest')
end
title('WT mouse, virus')