%%% Load data, plot, and run repeated measures analyses for Kim, Ohmae, & 
%%% Medina (2019 initial submission Nature Neuroscience)
%%% extended data figure 7. 
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
%%% Data/information will be loaded in from "edfig7_matlabVariables.mat"
%%% Description of variables imported from this file:
%%%     VARIABLE NAME           DESCRIPTION
%%%     bstartAmp               each row has data from one mouse. each
%%%                             column has data from one session. column 1
%%%                             has data from the last baseline session
%%%                             before the laser-during-CR manipulation.
%%%                             column 2-5 has data from the first 4 days
%%%                             of the manipulation. column 6-7 hacs data
%%%                             from the last 2 days of the manipulation.
%%%                             this data format is to deal with missing
%%%                             data from a mouse. data are in units of
%%%                             FEC.
%%%     bstartamps              each row has data from one mouse. each
%%%                             column has data from one session. column 1
%%%                             has data from the last baseline session
%%%                             before the laser-during-CR manipulation.
%%%                             column 2-11 have data from all 10 days of
%%%                             the manipulation, with NaNs where there are
%%%                             missing data. data are in units of FEC.
%%%     bstartLatency           as bastartAmp, but data are latency to beta
%%%                             startle (only on trials with a beta startle
%%%                             present). unit is s.
%%%     bstartlats              as bstartamps, but data are latency to beta
%%%                             startle (only on trials with a beta startle
%%%                             present). unit is s.
%%%     chr2crprobmad           median absolute deviation of group's cr
%%%                             probability across sessions. column 1 is
%%%                             the last baseline session, columns 2-11 are
%%%                             the 10 days of the manipulation
%%%     chr2croprobmed          median of the group's cr probability across
%%%                             sessions. sessions organized as in
%%%                             chr2crprobmad.
%%%     crampAllTrials          each row contains data from a single mouse.
%%%                             each column contains data from a single
%%%                             session (col 1 is last baseline session,
%%%                             cols 2-5 are sessions 1-4 of the
%%%                             manipulation, cols 6-7 are the last 2
%%%                             sessions of the manipulation). data are
%%%                             median cr amplitudes across all trials on a
%%%                             session.
%%%     crampHits               each row has data from a single mouse. each
%%%                             column has data from a single session (col
%%%                             1 is the last baeline session, cols 2-11
%%%                             are sessions 1-10 of the manipulation). data
%%%                             are median cr amplitudes across trials that
%%%                             have a cr on individual sessions
%%%     crampHitTrials          data are organized as crampAllTrials. data
%%%                             are median cr amplitudes across trials that
%%%                             have a cr on individual sessions
%%%     cramps                  data are organized as in crampHits. data
%%%                             are median cr amplitudes across trials that
%%%                             have a cr on individual sessions
%%%     crprobs                 each row has data from a single mouse. each
%%%                             column has data from a single session (col
%%%                             1 is the last baeline session, cols 2-11
%%%                             are sessions 1-10 of the manipulation).
%%%                             data are cr probabilities on individual
%%%                             sessions.
%%%     eyetraces_pos           eyelid position (fraction eyelid closure -
%%%                             mean fraction eyelid closure in the 200 ms
%%%                             before the tone is presented) traces for
%%%                             each mouse on sessions shown in figure 
%%%                             panel g. each trace is the mean of all
%%%                             eyelid traces for the session at hand,
%%%                             excluding trails with movement in the
%%%                             pre-stimulus baseline period. Each row in
%%%                             this array shows data for a single mouse.
%%%                             Each column shows data from a single time
%%%                             bin (timestamps of bins specified in the
%%%                             timeVector variable). Each unit of the
%%%                             third dimension of the matrix specifies a
%%%                             particular day. So, data from the first day
%%%                             shown in this figure (the last day before
%%%                             the laser manipulation) can be examined using
%%%                             the command: eyetraces_pos(:,:,1)
%%%     eyetraces_vel           as eyetraces_pos, except showing the
%%%                             velocity of the eyelid (derivative of
%%%                             position)
%%%     mousenums               unique identifiers for the ChR2 mice that
%%%                             contributed data for this figure. using the
%%%                             same identifying number shown for the 
%%%                             corresponding histology in the ChR2 panels
%%%                             shown in extended data figure 3.  Data in
%%%                             all the arrays in this file are organized
%%%                             in the order specified here.
%%%     postm
%%%     rmidcs                  indices for the sessions used for the
%%%                             Friedman ANOVA for the ChR2 mice (deals
%%%                             with missing data for 1 mouse in the ChR2
%%%                             and WT groups)
%%%     sfig7_eyetraces
%%%     sfig7_eyetracesHit
%%%     timeVector              timestamps (s) for eyelid position sampling
%%%                             times. the tone starts playing at 0 s.
%%%     veltm                   timestamps (s) for derivative of eyelid
%%%                             position. the tone starts playing at 0 s.


%% set up the workspace
clear all
close all

% tell MATLAB where you have saved the data and helper functions
datadir = "C:\Users\kimol\Documents\GitHub\KimOhmaeMedina"; % *** YOUR DATA DIRECTORY ***
cd(datadir)

% default is to not plot legends because they obscure the data
plotLegends = 0;

load('edfig7_matlabVariables.mat')


%% Plot the behavior data
% panel b: ChR2 mice CR probability from 'early' laser
% manipulation
figure
subplot(3,4,[1:2])
a = errorbar(chr2crprobmed, chr2crprobmad, '.', 'LineStyle', 'none', 'Color', 'r');
set(a, 'CapSize', 0)
hold on
c = plot([2.5 2.5], [0 1], 'LineStyle', '--', 'Color', [0 0 0]);
xlim([0.5 11.5])
ylim([0 1])
ylabel('CR Probability')
xlabel('Session')

% panel d: ChR2 mice eyelid traces from the 'early' phase
% of the manipulation (baseline, laser 1, laser 3, last laser)
subplot(3,4,[5])
[A,B,C,D]=plotEyelidTraces(timeVector, sfig7_eyetraces, [1 0 0], 0.5);
xlim([0 0.235])
ylim([0 0.8])
xlabel('Time from tone (s)')
title('all trials')
ylabel('Eyelid Position (FEC)')
if plotLegends == 1
    legend([A,B,C,D], 'TLast', '1', '2', '10', 'Location', 'NorthWest')
end

% eyetraces hit trials only
subplot(3,4,[6])
[A,B,C,D]=plotEyelidTraces(timeVector, sfig7_eyetracesHit, [1 0 0], 0.5);
xlim([0 0.235])
ylim([0 0.8])
xlabel('Time from tone (s)')
title('hit trials')
if plotLegends == 1
    legend([A,B,C,D], 'TLast', '1', '2', '10', 'Location', 'NorthWest')
end

% figure 6, panel e: ChR2 mice CR amplitude from the 'early' laser
% manipulation (baseline, laser 1, laser 3, last laser) (bar plot)
subplot(3,4,[9])
plotBoxplot(crampAllTrials, [1 0 0], 1, [0 0 0])
ylabel('CR Amplitude')
title('all trials')

% CR amplitude on CR trials only
subplot(3,4,[10])
plotBoxplot(crampHitTrials, [1 0 0], 1, [0 0 0])
ylabel('CR Amplitude')
title('hit trials only')

% FEC at 75 ms on B startle trials
subplot(3,4,[11])
plotBoxplot(bstartAmp, [1 0 0], 0.4, [0 0 0])
ylabel('B Startle Amp (FEC)')
title('B Startle')

subplot(3,4,[12])
plotBoxplot(bstartLatency, [1 0 0], 0.4, [0 0 0])
ylim([49 115])
xlim([0.5 7.5])
ylabel('Latency (ms)')
title('Latency to Beta Startle')

% plotting eyelid position and velocity traces
meansmoothedveltraces = nan(7,199);
meantraces_pos = nan(7,200);
for d = 1:7
    % average across mice for each session
    % d = 1 indicates baseline day, the other days are manipulation days
    meansmoothedveltraces(d,:) = mean(eyetraces_vel(:,:,d));
    meantraces_pos(d,:) = mean(eyetraces_pos(:,:,d));
end
figure
plotiter= 1;
for i = 1:7
    
    plotme = meantraces_pos(i,:);
    subplot(7,2,plotiter)
    rectangle('Position', [0 -0.05 ...
        0.22 0.8+0.05], 'FaceColor', [0 1 1], 'EdgeColor', [0 1 1])
    hold on
    rectangle('Position', [0.05 -0.05 ...
        0.065 0.8+0.05], 'FaceColor', [0.85 0.85 0.85], 'EdgeColor', [0.85 0.85 0.85])
    plot(postm,plotme,'Color',[0 0 0])
    xlim([-0.025 0.22])
    ylim([-0.05 0.5])
    switch i
        case 1
            ylabel('baseline')
        case 2
            ylabel('laser 1')
        case 3
            ylabel('laser 2')
        case 4
            ylabel('laser 3')
        case 5
            ylabel('laser 4')
        case 6
            ylabel('laser n-1')
        case 7
            ylabel('last laser')
            xlabel('time from trial start (s)')
    end
    
    
    plotme = meansmoothedveltraces(i,:);
    subplot(7,2,plotiter+1)
    rectangle('Position', [0 -2 ...
        0.22 10], 'FaceColor', [0 1 1], 'EdgeColor', [0 1 1])
    hold on
    rectangle('Position', [0.05 -2 ...
        0.065 10], 'FaceColor', [0.85 0.85 0.85], 'EdgeColor', [0.85 0.85 0.85])
    plot(veltm,plotme,'Color',[0 0 0])
    xlim([-0.025 0.22])
    ylim([-2 6])
    if i == 7
        xlabel('time from trial start (s)')
    end
    plotiter = plotiter+2;
end

%% Run statistics: repeated measures ANOVA-type tests
% Check whether the data satisfy the sphericity and normality assumptions
% for an ANOVA (spoiler: none of the data satisfy the sphericity assumption
% according to Mauchly's test, so I didn't bother checking for normality),
% and then run the Friedman's ANOVA if not

% set up cells for writing stats outputs later
rmSummaryHeaders = {'group', 'phase', 'measurement', 'ChiSq', 'df', 'n', 'p', 'W'};
rmGroup = {};
rmPhase = {};
rmMeas = {};
rmChi = [];
rmdf = [];
rmn = [];
rmp = [];
rmW = [];
  
% CR Probability across the laser during CR manipulation for the ChR2
% group
[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(crprobs, mousenums, rmidcs, 0.05, ...
    'ChR2', 'Early', 'CRProb', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(cramps, mousenums, rmidcs, 0.05, ...
    'ChR2', 'Early', 'CRAmp', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(crampHits, mousenums, rmidcs, 0.05, ...
    'ChR2', 'Early', 'CRAmpHit', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(bstartamps, mousenums, rmidcs, 0.05, ...
    'ChR2', 'Early', 'BStartleAmp', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(bstartlats*1000, mousenums, rmidcs, 0.05, ...
    'ChR2', 'Early', 'BStartleLatency', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

% write the repeated measures test results
stringcols = [rmGroup, rmPhase, rmMeas];
numcols = [rmChi, rmdf, rmn, rmp, rmW];
tbldata = [stringcols, num2cell(numcols)];
tempcsv = [rmSummaryHeaders;tbldata];
pause(2)
xlswrite('edfig7_repeatedMeasuresOutput.xls', tempcsv)