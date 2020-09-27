%%% Load data, plot, and run repeated measures analyses for Kim, Ohmae, & 
%%% Medina (2019 initial submission Nature Neuroscience)
%%% extended data figure 6. 
%%%
%%% Please contact the corresponding author (Javier F. Medina,
%%% jfmedina@bcm.edu) if you have any questions
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
%%% Variable descriptions:
%%%     mousenums       unique identifiers for the ChR2 mice that
%%%                     contributed data for this figure. using the same
%%%                     identifying number shown for the corresponding
%%%                     histology in the ChR2 panels shown in extended data
%%%                     figure 3. Data in all of the arrays in this file
%%%                     are organized in the order specified here.
%%%     noLaserURs      Cell array, where each row of the cell corresponds to
%%%                     one mouse. Each cell contains an array of UR traces
%%%                     from each of the baseline sessions around the laser
%%%                     sessions. Each row of the array is a session-
%%%                     averaged eyelid trace. Not every mouse contributed
%%%                     an eyetrace on each day -- trials with movement 
%%%                     before the UR were thrown out (eyelid closure before 
%%%                     the UR would confound measurement of the reflex 
%%%                     response to the experienced puff), and some mice 
%%%                     with a lot of movement didn't have any usable UR 
%%%                     traces on some sessions. The places for these 
%%%                     sessions are held by NaNs.
%%%     normCRProb      each row has data from one mouse. each column has
%%%                     data from one session. each value is CR probability
%%%                     normalized to CR probability on the session in the
%%%                     first column. the first column shows data from the
%%%                     last session with a strong UR. the remaining columns
%%%                     show data from sessions with weak URs. all sessions
%%%                     are consecutive.
%%%     normURDur       as normCRProb, but for UR duration (s)
%%%     rmidcs          indices for the sessions used for the Friedman
%%%                     ANOVA for the ChR2 mice (for consistency with
%%%                     figure 2)
%%%     strongURTraces  Cell array, where each row of the cell corresponds to
%%%                     one mouse. Each cell contains an array of UR traces
%%%                     from CS + US sessions without laser stimulation on
%%%                     consecutive sessions with strong URs. Each row of the
%%%                     array is a session-averaged eyelid trace. Not every
%%%                     mouse contributed an eyetrace on each day -- trials
%%%                     with movement before the UR were thrown out, and some mice 
%%%                     with a lot of movement didn't have any usable UR 
%%%                     traces on some sessions. The places for these 
%%%                     sessions are held by NaNs.
%%%     timeVector      timestamps that eyelid position samples were taken
%%%     urAmpNoLaser    UR amplitude on sessions without laser stimulation
%%%     urAmpWithLaser  UR amplitude on sessions with laser stimulation
%%%     urDurNoLaser    UR duration (ms) on sessions without laser
%%%                     stimulation
%%%     urDurWithLaser  UR duration (ms) on sessions with laser stimulation
%%%     weakURTraces    Cell array, where each row of the cell corresponds to
%%%                     one mouse. Each cell contains an array of UR traces
%%%                     from CS + US sessions without laser stimulation on
%%%                     consecutive sessions with weak URs. Each row of the
%%%                     array is a session-averaged eyelid trace. Not every
%%%                     mouse contributed an eyetrace on each day -- trials
%%%                     with movement before the UR were thrown out, and some mice 
%%%                     with a lot of movement didn't have any usable UR 
%%%                     traces on some sessions. The places for these 
%%%                     sessions are held by NaNs.
%%%     withLaserURs    Cell array, organized as described for noLaserURs,
%%%                     except that the data are taken from 10 sessions
%%%                     with laser stimulation during the puff.


%% set up the workspace
clear all
close all

% tell MATLAB where you have saved the data and helper functions
datadir = "C:\Users\kimol\Documents\GitHub\KimOhmaeMedina"; % *** YOUR DATA DIRECTORY ***
cd(datadir)

% default is to not plot legends because they obscure the data
plotLegends = 0;

load('edfig6_matlabVariables.mat')



%% A version of the UR figure that only includes data from the ChR2 animals
noLaserURTraces = nan(8,200);
laserURTraces = nan(8,200);
for d = 1:length(noLaserURs)
    noLaserURTraces(d,1:200) = nanmedian(noLaserURs{d,1});
    laserURTraces(d,1:200) = nanmedian(withLaserURs{d,1});    
end

figure
% panel a
subplot(2,4,[1,2])
[withLaser] = shadedErrorBar(timeVector(1,:), nanmean(laserURTraces),...
    nanstd(laserURTraces)./sqrt(sum(~isnan(laserURTraces(:,1)))), '-b', 1);
hold on
[noLaser] = shadedErrorBar(timeVector(1,:), nanmean(noLaserURTraces),...
    nanstd(noLaserURTraces)./sqrt(sum(~isnan(noLaserURTraces(:,1)))), '-k', 1);
if plotLegends==1
    legend([noLaser.mainLine, withLaser.mainLine], 'No Laser', 'Laser', 'Location', 'NorthOutside')
end
xlim([0.2 0.75])
ylabel('Eyelid Position (FEC)')


% panel b
subplot(2,4,3)
hold on
for i = 1:size(urAmpWithLaser,1)
    a = plot([1,2], [urAmpNoLaser(i,1), urAmpWithLaser(i,1)], '-o');
    set(a, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0], 'Color', [0.7 0.7 0.7])
end
xlim([0 3])
ylim([0 1.05])
xticklabels({'','No Laser','Laser',''})
ylabel('UR Amplitude (FEC)')

% panel c
subplot(2,4,4)
hold on
for i = 1:size(urDurWithLaser,1)
    a = plot([1,2], [urDurNoLaser(i,1), urDurWithLaser(i,1)], '-o');
    set(a, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0], 'Color', [0.7 0.7 0.7])
end
xlim([0 3])
ylim([0 350])
xticklabels({'','No Laser','Laser',''})
ylabel('UR Duration (ms)')

% panel d
subplot(2,4,[5,6])
weakURTraces_mousely = nan(length(weakURTraces),200);
for i = 1:length(weakURTraces)
    weakURTraces_mousely(i,1:200) = nanmean(weakURTraces{i,1});
end
[strongUR] = shadedErrorBar(timeVector(1,:), nanmean(strongURTraces),...
    nanstd(strongURTraces)./sqrt(sum(~isnan(strongURTraces))), '-k', 1);
hold on
[weakUR] = shadedErrorBar(timeVector(1,:), nanmean(weakURTraces_mousely),...
    nanstd(weakURTraces_mousely)./sqrt(sum(~isnan(weakURTraces_mousely))), '-r', 1);
% need to run after biganalysis figure 5 plot
[laserUR] = shadedErrorBar(timeVector(1,:), nanmean(laserURTraces),...
    nanstd(laserURTraces)./sqrt(sum(~isnan(laserURTraces(:,1)))), '-b', 1);
if plotLegends==1
    legend([strongUR.mainLine, weakUR.mainLine, laserUR.mainLine], 'longer UR', 'shorter UR', ...
        'during laser', 'Location', 'NorthOutside')
end
xlim([0.2 0.75])
ylabel('Eyelid Position (FEC)')

% panel e
meanvals.crprob = nan(1,6);
semvals.crprob = nan(1,6);
meanvals.urdur = nan(1,6);
semvals.urdur = nan(1,6);
for n = 1:6
    meanvals.crprob(1,n) = nanmean(normCRProb(:,n));
    semvals.crprob(1,n) = nanstd(normCRProb(:,n))./sqrt(sum(~isnan(normCRProb(:,n))));
    meanvals.urdur(1,n) = nanmean(normURDur(:,n));
    semvals.urdur(1,n) = nanstd(normURDur(:,n))./sqrt(sum(~isnan(normURDur(:,n))));
end
subplot(2,4,[7,8])
plot([0 9], [1 1], 'LineStyle', '--', 'Color', [0 0 0])
hold on
a = errorbar([1.1], meanvals.crprob(1), semvals.crprob(1), 's', 'LineStyle', 'none', 'Color', [0 0 0]);
set(a,'CapSize',0,'MarkerSize',6)
a = errorbar([2:6], meanvals.crprob(2:6), semvals.crprob(2:6), 's', 'LineStyle', 'none', 'Color', [1 0 0]);
set(a,'CapSize',0,'MarkerSize',6)
b = errorbar([0.9], meanvals.urdur(1), semvals.urdur(1), '.', 'LineStyle', 'none', 'Color', [0 0 0]);
set(b,'CapSize',0,'MarkerSize',14)
b = errorbar([2:6], meanvals.urdur(2:6), semvals.urdur(2:6), '.', 'LineStyle', 'none', 'Color', [1 0 0]);
set(b,'CapSize',0,'MarkerSize',14)
ylim([0 1.25])
xlim([0.5 6.5])
text(4.5, 0.05, 'n = 9')
ylabel('Normalized Value')
if plotLegends==1
legend('CR Prob, baseline', 'CR prob, weak UR', 'UR Dur, baseline', 'UR Dur, weak UR', 'Location', 'SouthWest')
end
xlabel('Consecutive Sessions')





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
    checkSpherAndRunFANOVA(normURDur, mousenums, rmidcs, 0.05, ...
    'mouse', 'URDrop', 'URDur', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(normCRProb, mousenums, rmidcs, 0.05, ...
    'mouse', 'URDrop', 'CRProb', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

% write the repeated measures test results
stringcols = [rmGroup, rmPhase, rmMeas];
numcols = [rmChi, rmdf, rmn, rmp, rmW];
tbldata = [stringcols, num2cell(numcols)];
tempcsv = [rmSummaryHeaders;tbldata];
pause(2)
xlswrite('edfig6_repeatedMeasuresOutput.xls', tempcsv)


%% go to R script for accompanying pairwise test
