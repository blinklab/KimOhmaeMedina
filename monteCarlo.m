%%% companion function for extended data figure 4. gets called in
%%% edfig4_plotScript.m.
%
% Note that output will vary from run to run due to randomness in the
% sampling
%
% output organization:
%   each row shows results for one neuron
%   column 1 shows FR below which 99% of the bootstrapped distribution lies
%   column 2 is 0 if the rebound FR is < the FR of 99 % of the distribution
%   column 2 is 1 if the rebound FR is >= the FR of 99% of the distribution


function [exceeds99PctBootstrap] = monteCarlo(binedges, baselineBinFR, reboundFRs, plotOutput)


exceeds99PctBootstrap = nan(length(baselineBinFR),2); % initialize output variable

% loop through each neuron
for i = 1:length(baselineBinFR)
    
    % Run a Monte Carlo simulation of neurons' baseline CSpk firing rates
    % Sample firing rate (FR) from a random bin during the baseline window 
    % on each trial. This simulation will be run "with replacement,"
    % meaning that a bin that is randomly sampled on one iteration of the
    % simulation may be sampled again on a subsequent iteration (i.e., it
    % is not removed from the sample pool).
    % This simulation is based on going through 500 iterations of sampling.
    iterations = 500;
    numtrials = sum(~isnan(baselineBinFR{i,1}(:,1)));
    bslnvals = nan(iterations,1);
    for r = 1:iterations
        %disp(num2str(r))
        binvals = nan(numtrials,1);
        biniter = 1;
        
        % sample FR from a random bin in the baseline period on each trial
        while biniter<=numtrials
            trialnum = randi(numtrials);
            binnum = randi(size(baselineBinFR{i,1},2));
            checking = 1;
            same = 0;
            if r>1
                while checking==1
                    for c = 1:r
                        if isnan(baselineBinFR{i,1}(trialnum,binnum))
                            same = 1;
                        else
                            same = 0;
                        end
                    end
                    if same==0
                        checking=0;
                    else
                        trialnum = randi(numtrials);
                        binnum = randi(size(baselineBinFR{i,1},2));
                    end
                end
            end
            binvals(biniter,1) = baselineBinFR{i,1}(trialnum,binnum);
            biniter = biniter+1;
        end
        
        % Find the mean of the randomly sampled bins
        bslnvals(r,1) = mean(binvals);
    end
    
    % sort the Monte Carlo simulation output so it's easier to find wher
    % 99% of the sample lies
    sortedBsln = sort(bslnvals);
    
    % plot a histogram showing the output of the simulation, the firing
    % rate during the rebound window, and the firing rate below which 99%
    % of the Monte Carlo simulation results fall below
    if plotOutput==1
        figure
        [histout,xvals] = hist(bslnvals, binedges);
        bar(xvals,histout)
        hold on
        plot([reboundFRs(i,1), reboundFRs(i,1)], [0 max(histout)],'Color',[0 0 0], 'LineStyle', '--', 'LineWidth', 2)
        plot([sortedBsln(0.99*length(sortedBsln)) sortedBsln(0.99*length(sortedBsln))], [0 max(histout)], 'LineStyle', '--', 'Color', [1 0 0], 'LineWidth', 2)
        if max(bslnvals)>reboundFRs(i,1)
            xlim([0 max(bslnvals)+0.1])
        else
            xlim([0 reboundFRs(i,1)+0.1])
        end
        legend('bootstrapped distribution','rebound FR','99% threshold')
        ylabel('Number of Samples')
        xlabel('Firing Rate (norm Hz)')
        xlim([0 10])
        pause(2)
        close all
    end
    
    % Store the firing rate below which 99% of the simulated distribution
    % fell.
    % If the firig rate in the rebound bin was higher than 99% of the
    % firing rates output by the simulation, output 1. If not, output 0.
    exceeds99PctBootstrap(i,1)=sortedBsln(0.99*length(sortedBsln));
    if reboundFRs(i,1)>sortedBsln(0.99*length(sortedBsln))
        exceeds99PctBootstrap(i,2)=1;
    else
        exceeds99PctBootstrap(i,2)=0;
    end
    
end