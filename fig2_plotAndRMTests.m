%%% Load and plot data for Kim, Ohmae, Medina (2019 initial submission
%%% to Nature Neuroscience)
%%% figure 2
%%% Saves repeated measures test output as a spreadsheet.
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
%%%
%%% Data/information will be loaded in from "fig2_matlabVariables.mat"
%%% Description of variables imported from this file:
%%%     VARIABLE NAME           DESCRIPTION
%%%     chr2mousenums           unique identifiers for the ChR2 mice that
%%%                             contributed data for this figure. using the
%%%                             same identifying number shown for the 
%%%                             corresponding histology in the ChR2 panels
%%%                             shown in extended data figure 3.  Data in
%%%                             all the arrays in this file are organized
%%%                             in the order specified here.
%%%     chr2rmidcs              indices for the sessions used for the
%%%                             Friedman ANOVA for the ChR2 mice (deals
%%%                             with missing data for 1 mouse in the ChR2
%%%                             and WT groups)
%%%     crprob_chr2             cr probabilities for each mouse in the ChR2
%%%                             group on the sessions shown in the figure.
%%%                             Each row shows data for one animal. Columns
%%%                             1 through 4 contain cr probability across
%%%                             training days. Columns 5 and 6 contain cr
%%%                             probability during the
%%%                             pre-laser-manipulation baseline period.
%%%                             Columns 7 through 16 contain cr probability
%%%                             during the laser manipulation period.
%%%                             Columns 17 through 20 contain cr
%%%                             probability during the
%%%                             post-laser-manipulation retraining sessions
%%%     crprob_eyfp             cr probabilities for each mouse in the EYFP
%%%                             group on the sessions shown in the figure.
%%%                             Each row shows data for one animal. Columns
%%%                             1 through 4 contain cr probability across
%%%                             training days. Columns 5 and 6 contain cr
%%%                             probability during the
%%%                             pre-laser-manipulation baseline period.
%%%                             Columns 7 through 16 contain cr probability
%%%                             during the laser manipulation period.
%%%                             Columns 17 through 20 contain cr
%%%                             probability during the
%%%                             post-laser-manipulation retraining sessions
%%%     crprob_wt               cr probabilities for each mouse in the WT
%%%                             group on the sessions shown in the figure.
%%%                             Each row shows data for one animal. Columns
%%%                             1 through 4 contain cr probability across
%%%                             training days. Columns 5 and 6 contain cr
%%%                             probability during the
%%%                             pre-extinction baseline period. Columns 7
%%%                             through 16 contain cr probability during
%%%                             the extinction period. Columns 17 through
%%%                             20 contain cr probability during the
%%%                             post-extinction retraining sessions
%%%     eyfpmousenums           unique identifiers for the EYFP mice that
%%%                             contributed data for this figure. using the
%%%                             same identifying number shown for the 
%%%                             corresponding histology in the EYFP panels
%%%                             shown in extended data figure 3.
%%%     eyfprmidcs              indices for the sessions used for the
%%%                             Friedman ANOVA for the EYFP mice (to be
%%%                             to be consistent with number of days used
%%%                             for the ChR2 and WT groups)
%%%     fig2_chr2DuringCRAmps   cr amplitudes displayed in figure panel d for
%%%                             each mouse in the ChR2 group. each row
%%%                             shows data for one mouse. each column has
%%%                             data for one session. Column 1 has data
%%%                             from the last pre-laser-manipulation
%%%                             baseline session, columns 2-5 have data from
%%%                             the first 4 sessions of the manipulation,
%%%                             columns 6-7 have data from the last 2
%%%                             sessions of the manipulation. data have been
%%%                             computed as the median cr amplitude on each
%%%                             session.
%%%     fig2_chr2DuringTraces   eyelid position (fraction eyelid closure -
%%%                             mean fraction eyelid closure in the 200 ms
%%%                             before the tone is presented) traces for
%%%                             each mouse on sessions shown in figure 
%%%                             panel c. each trace is the mean of all
%%%                             eyelid traces for the session at hand,
%%%                             excluding trails with movement in the
%%%                             pre-stimulus baseline period. Each row in
%%%                             this array shows data for a single mouse.
%%%                             Each column shows data from a single time
%%%                             bin (timestamps of bins specified in the
%%%                             timeVector variable). Each unit of the
%%%                             third dimension of the matrix specifies a
%%%                             particular day. So, data from the first day
%%%                             shown in this figure (the last baseline day
%%%                             before the manipulation) can be examined
%%%                             using the command:
%%%                             fig2_chr2DuringTraces(:,:,1)
%%%     fig2_chr2ReacqCRAmps    cr amplitudes from the retraining phase for
%%%                             each mouse in the ChR2 group. each row
%%%                             shows data for one mouse. each column has
%%%                             data for one session. Column 1 has data
%%%                             from the last laser-manipulation
%%%                             session, columns 2-4 have data from
%%%                             the first 3 sessions of the retrainnig,
%%%                             column 5 has data from the last retraining
%%%                             session. data have been computed as the
%%%                             median cr amplitude on each session. Note
%%%                             that data from the first column in this
%%%                             array are not plotted in panel h of the
%%%                             figure, because the salient comparison here
%%%                             is with the last day of the pre-laser
%%%                             baseline session
%%%     fig2_chr2SavingsTraces  eyelid position (fraction eyelid closure -
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
%%%                             shown in this figure (the last day of the
%%%                             laser manipulation) can be examined using
%%%                             the command: fig2_chr2SavingsTraces(:,:,1)
%%%     fig2_wtExtCRAmps        cr amplitudes displayed in figure panel f for
%%%                             each mouse in the WT group. each row
%%%                             shows data for one mouse. each column has
%%%                             data for one session. Column 1 has data
%%%                             from the last pre-extinction baseline
%%%                             session, columns 2-5 have data from the
%%%                             first 4 sessions of extinction, columns 6-7
%%%                             have data from the last 2 sessions of
%%%                             extinction. data have been computed as the
%%%                             median cr amplitude on each session
%%%     fig2_wtExtTraces        eyelid position (fraction eyelid closure -
%%%                             mean fraction eyelid closure in the 200 ms
%%%                             before the tone is presented) traces for
%%%                             each mouse on sessions shown in figure 
%%%                             panel e. each trace is the mean of all
%%%                             eyelid traces for the session at hand,
%%%                             excluding trails with movement in the
%%%                             pre-stimulus baseline period. Each row in
%%%                             this array shows data for a single mouse.
%%%                             Each column shows data from a single time
%%%                             bin (timestamps of bins specified in the
%%%                             timeVector variable). Each unit of the
%%%                             third dimension of the matrix specifies a
%%%                             particular day. So, data from the first day
%%%                             shown in this figure (the last day of the
%%%                             pre-extinction baseline) can be examined w/
%%%                             the command: fig2_wtExtTraces(:,:,1)
%%%     timeVector              timestamps (s) for eyelid position sampling
%%%                             times. the tone starts playing at 0 s.
%%%     wtmousenums             unique identifiers for the ChR2 mice that
%%%                             contributed data for this figure. using the
%%%                             same identifying number that corresponds to
%%%                             data from the same mice in extended data
%%%                             figure 5
%%%     wtrmidcs                indices for the sessions used for the
%%%                             Friedman ANOVA for the WT mice (deals
%%%                             with missing data for 1 mouse in the ChR2
%%%                             and WT groups)

%% set up the workspace
clear all
close all

% tell MATLAB where you have saved the data and helper functions
datadir = "C:\Users\kimol\Documents\GitHub\KimOhmaeMedina"; % *** YOUR DATA DIRECTORY ***
cd(datadir)

% default is to not plot legends because they obscure the data
plotLegends = 0;

load('fig2_matlabVariables.mat')

%% make figure 
colordef white
figure
% panel b
subplot(4,3,[1,2,3,4,5,6])
title('Figure 2')
plot([6.5 6.5], [0 1], 'LineStyle', '--', 'Color', [0 0 0])
hold on
plot([16.5 16.5], [0 1], 'LineStyle', '--', 'Color', [0 0 0])
eyfpplot = errorbar(1:20, nanmedian(crprob_eyfp), mad(crprob_eyfp,1), '.', 'LineStyle', 'none');
set(eyfpplot, 'CapSize', 0, 'MarkerSize', 12, 'Color', [1 0 0])
chr2plot = errorbar(1:20, nanmedian(crprob_chr2), mad(crprob_chr2,1), '.', 'LineStyle', 'none');
set(chr2plot, 'CapSize', 0, 'MarkerSize', 12, 'Color', [0 0.75 1])
wtplot = errorbar(1:20, nanmedian(crprob_wt), mad(crprob_wt,1), '.', 'LineStyle', 'none');
set(wtplot, 'CapSize', 0, 'MarkerSize', 12, 'Color', [0 0 0])
ylim([0 0.85])
xlim([0.5 20.5])
xticks([1:20])
xticklabels({'T1','T3','T5','T7','TLast-1','TLast','1','2','3','4','5','6',...
    '7','8','9','10','R1','R2','R3','RLast'})
set(gca,'box','off','TickDir','out')
xlabel('Session (100 trials/session)')
ylabel('CR Probability')
if plotLegends == 1
    legend([eyfpplot, wtplot, chr2plot], 'control','wt','chr2','Location','NorthWest')
end

% panel d
subplot(4,3,7)
[A,B,C,D]=plotEyelidTraces(timeVector, fig2_chr2DuringTraces, [0 0.75 1], 0.55);
ylabel('Eyelid Position (FEC)')
title('ChR2, Laser')
if plotLegends == 1
    legend([A,B,C,D], 'TLast', '1', '2', '10', 'Location', 'NorthWest')
end

% panel e
subplot(4,3,8)
[A,B,C,D]=plotEyelidTraces(timeVector, fig2_wtExtTraces, [0 0 0], 0.55);
title('WT, Extinction')
if plotLegends == 1
    legend([A,B,C,D], 'TLast', '1', '2', '10', 'Location', 'NorthWest')
end

% panel f
subplot(4,3,9)
[A,B,C,D]=plotEyelidTraces(timeVector, fig2_chr2SavingsTraces, [0 0.75 1], 0.55);
title('ChR2, Retraining')
if plotLegends == 1
    legend([A,B,C,D], '10', 'R1', 'R2', 'RLast', 'Location', 'NorthWest')
end

% panel g
subplot(4,3,10)
plotBoxplot(fig2_chr2DuringCRAmps, [0 0.75 1], 0.65, [1 0 0])
% plot([1 1], [0.585 0.4245], 'Color', [0 0 0])
% plot([1 4.5], [0.585 0.585], 'Color', [0 0 0])
% plot([4.5 4.5], [0.585 0.3575], 'Color', [0 0 0])
% plot([2 7], [0.3575 0.3575], 'Color', [0 0 0])
% plot([2 2], [0.338 0.3575], 'Color', [0 0 0])
% plot([7 7], [0.338 0.3575], 'Color', [0 0 0])
% text(2,0.6,'***')

% panel h
subplot(4,3,11)
plotBoxplot(fig2_wtExtCRAmps, [0 0 0], 0.65, [1 0 0])

% panel i
subplot(4,3,12)
plotBoxplot([fig2_chr2DuringCRAmps(:,1), fig2_chr2ReacqCRAmps(:,2:end)], [0 0.75 1], 0.65, [1 0 0])
xlim([0.5 5.5])
xticks([1:5])
xticklabels({'TLast', 'R1','R2','R3','RLast'})

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
  
% CR Probability across the laser during puff manipulation for the ChR2
% group
[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(crprob_chr2, chr2mousenums, chr2rmidcs, 0.05, ...
    'ChR2', 'laserDuringPuff', 'CRProb', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);


% CR Amplitude across the laser during puff manipulation for the ChR2
% group
[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(fig2_chr2DuringCRAmps, chr2mousenums, [], 0.05, ...
    'ChR2', 'laserDuringPuff', 'CRAmp', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

% CR Probability across the unpaired extinction manipulation for the WT
% group. This one is not reported in the paper because of space
% constraints.
 [rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
     checkSpherAndRunFANOVA(crprob_wt, wtmousenums, wtrmidcs, 0.05, ...
     'WT', 'unpairedExtinction', 'CRProb', ...
     rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

% CR Amplitude across the unpaired extinction manipulation for the WT
% group
[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(fig2_wtExtCRAmps, wtmousenums, [], 0.05, ...
    'WT', 'unpairedExtinction', 'CRAmp', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

% CR Probability across the laser during puff manipulation for the control
% group
[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(crprob_eyfp, eyfpmousenums, eyfprmidcs, 0.05, ...
    'Control', 'laserDuringPuff', 'CRProb', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

% write the repeated measures test results
stringcols = [rmGroup, rmPhase, rmMeas];
numcols = [rmChi, rmdf, rmn, rmp, rmW];
tbldata = [stringcols, num2cell(numcols)];
tempcsv = [rmSummaryHeaders;tbldata];
pause(2)
xlswrite('fig2_repeatedMeasuresOutput.xls', tempcsv)

% go to the R file fig2_nparLDTest.R for the nparLD statistics test

%% Run statistics: pairwise tests
% go to the R file "fig2_pairwiseTests.R" for corresponding Shapiro-Wilk tests for
% normality and the subsequent pairwise tests
