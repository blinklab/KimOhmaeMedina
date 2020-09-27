%%% Load and plot the electrophysiology data for Kim, Ohmae, Medina 2020
%%% Nature Neuroscience, figure 1
%%% 
%%% NOTE: Please enter the directory where you have saved the data files
%%% and the functions included with this Git repo in the lines indicated
%%% with, " % *** YOUR DATA DIRECTORY *** "
%%%
%%% Data/information will be loaded in from "fig1_matlabVariables.mat"
%%% Description of variables imported from this file:
%%%     VARIABLE NAME           DESCRIPTION
%%%     bincenters              time at the center of bins containing
%%%                             histogram data
%%%     cspkinfo                struct containing information about each 
%%%                             recording including:
%%%                                 FIELD               DESCRIPTION
%%%                                 mouseDateRecord     the source mouse/date of recording/
%%%                                                     recording taken that day
%%%                                 blcspk              baseline complex spike (CSpk)
%%%                                                     firing rate (FR) in Hz
%%%                                 puffcspk            CSpk FR in response to a periocular
%%%                                                     puff
%%%                                 puffcspk_norm       normalized CSpk FR in response to a
%%%                                                     periocular puff (puffcspk/blcspk)
%%%                                 laserpuffcspk       CSpk FR in response to a periocular
%%%                                                     puff concurrently presented with
%%%                                                     laser stimulation
%%%                                 laserpuffcspk_norm  normalized CSpk FR in response to a periocular
%%%                                                     puff concurrently presented with
%%%                                                     laser stimulation (laserpuffcspk/blcspk)                   
%%%     frs_lp                  binned firing rate (10 ms bins) of exemplar
%%%                             Purkinje Cell CSpks in response to a
%%%                             periocular airpuff concurrently presented
%%%                             with laser stimulation
%%%     frs_p                   binned firing rate (10 ms bins) of exemplar
%%%                             Purkinje Cell CSpks in response to a
%%%                             periocular airpuff
%%%     laserpuffRaster         cell array. Each cell contains a vector of
%%%                             timestamps (in ms) for CSpks that occurred
%%%                             on a single trial. Time 0 is the time that
%%%                             the puff is triggered. For these trials,
%%%                             the laser came on for 200 ms starting at
%%%                             -20 ms. Data are from the exemplar cell
%%%                             whose data is contained in frs_lp and
%%%                             frs_p.
%%%     puffRaster              cell array. Each cell contains a vector of
%%%                             timestamps (in ms) for CSpks that occurred
%%%                             on a single trial. Time 0 is the time that
%%%                             the puff is triggered. The laser was not
%%%                             presented on these trials. Data are from 
%%%                             the exemplar cell whose data is contained 
%%%                             in frs_lp and frs_p.
%%%     ymax                    maximum y limit for the example cell
%%%                             histogram plot


%% set up the workspace
clear all
close all

% tell MATLAB where you have saved the data and helper functions
datadir = "C:\Users\kimol\Documents\GitHub\KimOhmaeMedina"; % *** YOUR DATA DIRECTORY ***
cd(datadir)

load('fig1_matlabVariables.mat') % load the data associated with figure 1

%% plot figure

figure

% panel i
subplot(5,1,1)
title('puff trials')
hold on
plot([0 0], [0.5 length(puffRaster)+0.5], 'Color', [0 0 0])
for i = 1:length(puffRaster)
    for s = 1:length(puffRaster{i,1})
        plot([puffRaster{i,1}(s) puffRaster{i,1}(s)], ...
            [i-0.25 i+0.25], 'Color', [0 0 0])
    end
end
ylim([0.5 length(puffRaster)+0.5])
xlim([-100 300])
ylabel('trial')

% panel j
subplot(5,1,2)
title('laser + puff trials')
rectangle('Position',[-20 0 200 30], 'FaceColor', [0 0.75 1], 'EdgeColor', [0 0.75 1])
hold on
plot([0 0], [0.5 length(laserpuffRaster)+0.5], 'Color', [0 0 0])
for i = 1:length(laserpuffRaster)
    for s = 1:length(laserpuffRaster{i,1})
        plot([laserpuffRaster{i,1}(s) laserpuffRaster{i,1}(s)], ...
            [i-0.25 i+0.25], 'Color', [0 0 0])
    end
end
ylim([0.5 length(laserpuffRaster)+0.5])
xlim([-100 300])
ylabel('trial')

% panel k
subplot(5, 1, [3 4])
hold on
plot([0 0], [0 ymax*1.1], 'Color', [1 0 0])
bar(bincenters, frs_p, 'k')
rectangle('Position',[-20 57 200 3], 'FaceColor', [0 0.75 1], 'EdgeColor', [0 0.75 1])
plot([0 0], [0 ymax*1.1], 'Color', [1 0 0])
bar(bincenters, frs_lp, 'c') % want to center bars in the window of that bin
xlim([-100 300])
ylim([0 ymax*1.1])
set(gca, 'TickDir', 'out')
ylabel('% Trials with CSpk')
xlabel('time (ms)')

% panel l
subplot(5,1,5)
hold on
jitter = [0,0.01,-0.02,0.02,-0.01,0,0.03,0,0,-0.03,0.04];
tempdiffs = [];
baselineVals = [];
puffcspkVals = [];
laserpuffcspkVals = [];
for c = 1:length(cspkinfo)
    plot([cspkinfo(c,1).puffcspk_norm, cspkinfo(c,1).laserpuffcspk_norm],...
        [2+jitter(c),1+jitter(c)], '-o', 'Color', [0 0 0],...
        'MarkerFaceColor', [1 1 1])
end
plot([1 1], [0 3], 'Color', [0 0 0], 'LineStyle', '--')
xlim([0 25])
ylim([0 3])
set(gca, 'TickDir', 'out')
yticks([1 2])
yticklabels({'laser + puff', 'puff',''})
xlabel('Normalized FR (Hz)')
text(0, 3, 'baseline')

%% please go to fig1_pairwiseTests.R for the t-test in this figure