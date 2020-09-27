%%% Load and plot data for Kim, Ohmae, Medina (2019 initial submission
%%% to Nature Neuroscience)
%%% figure 3
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
%%% Data/information will be loaded in from "fig3_matlabVariables.mat"
%%% Description of variables imported from this file:
%%%     VARIABLE NAME           DESCRIPTION
%%%     chr2mousenums           unique identifiers for the ChR2 mice that
%%%                             contributed data for this figure. using the
%%%                             same identifying number shown for the 
%%%                             corresponding histology in the ChR2 panels
%%%                             shown in extended data figure 3. Data in
%%%                             all the arrays in this file are organized
%%%                             in the order specified here.
%%%     chr2rmidcs              indices for the sessions used for the
%%%                             Friedman ANOVA for the ChR2 mice (deals
%%%                             with missing data and maintains consistency
%%%                             with figure 2)
%%%     crprob_chr2             cr probabilities for each mouse in the ChR2
%%%                             group on the sessions shown in the figure.
%%%                             Each row shows data for one animal. Columns
%%%                             1 and 2 contain cr probability during the
%%%                             pre-laser-manipulation baseline period.
%%%                             Columns 3 through 12 contain cr probability
%%%                             during the laser manipulation period.
%%%     fig3_eyetraces          eyelid position (fraction eyelid closure -
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
%%%                             fig3_eyeraces(:,:,1)
%%%     fig3_sessionBySessionCRAmps     cr amplitudes displayed in figure panel d for
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
%%%     sspkfrs                 struct containing information about each 
%%%                             recording including:
%%%                                 FIELD               DESCRIPTION
%%%                                 mouseDateCell       the source mouse/date of recording/
%%%                                                     recording taken that day
%%%                                 frdata              SSpk FRs (in spikes/s) in 50 ms bins,
%%%                                                     sampled from the 400 ms before stimulus
%%%                                                     onset in each trial. column 1 has the FR
%%%                                                     in that bin, column 2 has the trial number
%%%                                                     associated with the binned FR value in the
%%%                                                     same row
%%%     timeVector              timestamps (s) for eyelid position sampling
%%%                             times. the tone starts playing at 0 s.
%%%     trialByTrialAmps_after  CR amplitude on individual trials
%%%                             throughout the last baseline day before the
%%%                             laser-after-trial manipulation (laser onset
%%%                             is 350 ms after puff onset) and the 10 days
%%%                             of the manipulation. Each row shows data
%%%                             from one mouse. Each column shows data from
%%%                             one trial.
%%%     trialByTrialAmps_during CR amplitude on individual trials
%%%                             throughout the last baseline day before the
%%%                             laser-during puff manipulation (laser onset
%%%                             is 20 ms before puff onset) and the 10 days
%%%                             of the manipulation. Each row shows data
%%%                             from one mouse. Each column shows data from
%%%                             one trial.
%%%     trialByTrialSessionKey  Cell array with the same number of columns
%%%                             as the two trialByTrial variabiles
%%%                             mentioned above. Each cell names the
%%%                             session that the corresponding data were
%%%                             sourced from.

%% set up the workspace
clear all
close all

% tell MATLAB where you have saved the data and helper functions
datadir = "C:\Users\kimol\Documents\GitHub\KimOhmaeMedina"; % *** YOUR DATA DIRECTORY ***
cd(datadir)

% default is to not plot legends because they obscure the data
plotLegends = 0;

load('fig3_matlabVariables.mat')

colordef white
figure
%% panel b, CR probability across manipulation
subplot(15, 4, [1,5,9,13,17])
title('Figure 3')
plot([2.5 2.5], [0 1], 'LineStyle', '--', 'Color', [0 0 0])
hold on
chr2plot = errorbar(1:12, nanmedian(crprob_chr2), mad(crprob_chr2,1), '.', 'LineStyle', 'none');
set(chr2plot, 'CapSize', 0, 'MarkerSize', 12, 'Color', [1 0 0])
ylim([0 0.85])
xlim([0.5 12.5])
xticks([1:12])
xticklabels({'TLast','1','','','','5','',...
    '','','','10'})
set(gca,'box','off','TickDir','out')
xlabel('Session (100 trials/session)')
ylabel('CR Probability')


%% panel c, eyelid traces across manipulation
subplot(15, 4, [21,25,29,33,37])
[A,B,C,D]=plotEyelidTraces(timeVector, fig3_eyetraces, [1 0 0], 0.5);
ylabel('Eyelid Position (FEC)')
if plotLegends == 1
    legend([A,B,C,D], 'TLast', '1', '2', '10', 'Location', 'NorthWest')
end

%% panel d, cr amp across manipulation
subplot(15, 4, [41,45,49,53,57])
plotBoxplot(fig3_sessionBySessionCRAmps, [1 0 0], 0.55, [0 0 0])
ylabel('CR Amplitude')

%% panel e, normalized cr amp trial-by-trial across manipulation
subplot(15, 4, [2,3,6,7,10,11,14,15,18,19])
% NOTE: "after" refers to the "laser after the trial" manipulation,
% "during" refers to the "laser during airpuff" manipulation
aftervals = nanmean(trialByTrialAmps_after); % each row of trialByTrialAmps_after has CR amplitude on single trials from a single mouse, with the session that the trial corresponds to indicated in trialByTrialSessionKey. data are arranged in chronological order across the columns.
aftervalsnormd = aftervals/nanmean(aftervals(101:200)); % normalize to mean CR Amp on 2nd baseline day
duringvals = nanmean(trialByTrialAmps_during); 
duringvalsnormd = duringvals/nanmean(duringvals(101:200)); % normalize to mean CR Amp on 2nd baseline day
hold on
for s=1:100:1101 % decided to only plot data from the last baseline day onwards -- trying to save space
    plta = scatter(s-100:s+99-100, aftervalsnormd(1,s:s+99), 2);
    set(plta, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
    pltd = scatter(s-100:s+99-100, duringvalsnormd(1,s:s+99), 2);
    set(pltd, 'MarkerFaceColor', [0 0.75 1], 'MarkerEdgeColor', [0 0.75 1])
    plot([s+99.5-100 s+99.5-100], [0 2.05], 'Color', [0.25 0.25 0.25], 'LineStyle', '--')
end
xlim([0 1100])
ylim([0 2])
ylabel('CR Amplitude (normalized)')
set(gca, 'Box', 'off', 'TickDir', 'out')
xticks([50, 150, 250, 350, 450, 550, 650, 750, 850, 950, 1050])
xticklabels({'TLast', '1','2','3','4','5','6','7','8','9','10'})
xlabel('Session')
if plotLegends==1
    legend([plta, pltd], 'laser after trial', 'laser during puff')
end

%% panel f: FR plots
% sspkinfo.frdata has SSpk FRs (in spikes/s) in 50 ms bins, sampled from
% the 400 ms before stimulus onset in each trial
% column 1 has the FR in that bin, column 2 has the trial number associated
% with the binned FR value in the same row
cellorder = [3,4,2,10,1,9,8,5,6,7]; % this is just so that the plots all fit together later
plotvals={};
startsubplot = 22;
for f = 1:10
    baselineTrialsFR = mean(sspkfrs(cellorder(f),1).frdata(1:40,1));
    subplot(15,4,[startsubplot startsubplot+1])
    plot([0 (length(sspkfrs(cellorder(f),1).frdata(:,1))/8)+1], [100 100], 'Color', [0.3 0.2 0.3], 'LineStyle', '--')
    hold on
    plot(1/8:1/8:length(sspkfrs(cellorder(f),1).frdata(:,1))/8, movmean((sspkfrs(cellorder(f),1).frdata(:,1)/baselineTrialsFR)*100,8), 'Color', [0 0 0]) % there are 8, 50 ms bins per 400 ms pre-trial baseline. A window width of 8 bins is a window width of 1 trial.
    temp = 1/8:1/8:length(sspkfrs(cellorder(f),1).frdata(:,1))/8;
    temp = temp';
    temp2 = sspkfrs(cellorder(f),1).frdata(:,1);
    tempcat = [temp, temp2];
    plotvals{f,1} = tempcat;
    xlim([0 196])
    ylim([0 200])
    set(gca, 'TickDir', 'out')
    clear temp temp2 tempcat
    startsubplot = startsubplot+4;
    if f==5
        ylabel('SSpk FR (norm Hz)')
    elseif f == 10
        xlabel('Trial')
    end
end

%% panel f: inset (not inset in matlab)
% beginning and end of session SSPk firing
sspkFR_early = nan(10,1);
sspkFR_late = nan(10,1);
for f = 1:10
    numTrials = length(sspkfrs(f,1).frdata(:,1))/8;
    first10Pct = 1:ceil(numTrials/10);
    last10Pct = ceil(9*numTrials/10):numTrials;
    
    temp = [];
    for i = 1:length(first10Pct)
        thisTrialBins = first10Pct(i):first10Pct(i)+7;
        temp(end+1,1) = sum(sspkfrs(f,1).frdata(thisTrialBins,1)*0.05)./0.4;
    end
    sspkFR_early(f,1) = mean(temp);
    
    temp = [];
    for i = 1:length(last10Pct)
        thisTrialBins = last10Pct(i):last10Pct(i)+7;
        temp(end+1,1) = sum(sspkfrs(f,1).frdata(thisTrialBins,1)*0.05)./0.4;
    end
    sspkFR_late(f,1) = mean(temp);
end

% write data for R shapiroWilk test
csvwrite('fig3_laserAfterTrial_sspkFRBeginningOfSession.csv', sspkFR_early)
csvwrite('fig3_laserAfterTrial_sspkFREndOfSession.csv', sspkFR_late)

subplot(15,4, [32,36,40])
hold on
plot([1 2], [sspkFR_early, sspkFR_late], '-o', 'Color', [0 0 0])
xlim([0.5 2.5])
ylim([0 160])
set(gca, 'TickDir', 'out')
%ylabel('SSpk FR (Hz)')
xticks([1 2])
xticklabels({'First','Last'})


%% Run statistics: repeated measures ANOVA-type tests
% Check whether the data satisfy the sphericity and normality assumptions
% for an ANOVA, and then run the Friedman's ANOVA if no to either

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
    'ChR2', 'laserAfterTrial', 'CRProb', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);


% CR Amplitude across the laser during puff manipulation for the ChR2
% group
[rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(fig3_sessionBySessionCRAmps, chr2mousenums, [], 0.05, ...
    'ChR2', 'laserAfterTrial', 'CRAmp', ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW);

% write the repeated measures test results
stringcols = [rmGroup, rmPhase, rmMeas];
numcols = [rmChi, rmdf, rmn, rmp, rmW];
tbldata = [stringcols, num2cell(numcols)];
tempcsv = [rmSummaryHeaders;tbldata];
pause(2)
xlswrite('fig3_repeatedMeasuresOutput.xls', tempcsv)


%% Run statistics: pairwise tests
% go to the R file "fig3_pairwiseTest.R" for corresponding Shapiro-Wilk tests for
% normality and the subsequent pairwise tests
