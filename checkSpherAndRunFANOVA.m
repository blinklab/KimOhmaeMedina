%%%  Uses Mauchly's test to check for sphericity. If sphericity is not
%%%  satisfied, proceeds to run a Friedman repeated measures ANOVA on the
%%%  data. If sphericity is satisfied, outputs a message telling the user
%%%  to check the normality assumption in R and then proceed accordingly.

function [rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW] =...
    checkSpherAndRunFANOVA(data, mousenums, rmidcs, alpha, ...
    groupName, phaseName, measurementName, ...
    rmGroup, rmPhase, rmMeas, rmChi, rmdf, rmn, rmp, rmW)

if isempty(rmidcs)
    compdata = data;
else
    [~, cols] = size(rmidcs);
    compdata = nan(length(mousenums),cols); % As reported in the methods section, we used the last baseline day, manipulation days 1:4, and the last 2 manipulation days for the repeated measures ANOVA-type tests to deal with missing data. Skillings-Mack tests (nonparametric tests that can handle missing data) run on the entire dataset returned the same overall results as the Friedman tests, so we reported the more commonly used Friedman test results.
    for m = 1:length(mousenums)
        for d = 1:cols
            compdata(m, d) = data(m, rmidcs(m,d));
        end
    end
end

if size(compdata,2) == 7
    t = table(mousenums,compdata(:,1),compdata(:,2),compdata(:,3),...
        compdata(:,4),compdata(:,5),compdata(:,6),compdata(:,7),...
        'VariableNames',{'mouse','bsln','exp1','exp2','exp3','exp4','exp5','explast'});
    Meas = table([1 2 3 4 5 6 7]','VariableNames',{'Measurements'});
    rm = fitrm(t,'bsln-explast~mouse','WithinDesign',Meas);
elseif size(compdata,2) == 5
    t = table(mousenums,compdata(:,1),compdata(:,2),compdata(:,3),...
        compdata(:,4),compdata(:,5),...
        'VariableNames',{'mouse','bsln','reacq1','reacq2','reacq3','reacqlast'});
    Meas = table([1 2 3 4 5]','VariableNames',{'Measurements'});
    rm = fitrm(t,'bsln-reacqlast~mouse','WithinDesign',Meas);
elseif size(compdata,2)==6
    t = table(mousenums,compdata(:,1),compdata(:,2),compdata(:,3),...
        compdata(:,4),compdata(:,5),compdata(:,6),...
        'VariableNames',{'mouse','long','short1','short2','short3','short4','short5'});
    Meas = table([1 2 3 4 5 6]','VariableNames',{'Measurements'});
    rm = fitrm(t,'long-short5~mouse','WithinDesign',Meas);
else
    error('UNEXPECTED NUMBER OF DAYS')
end
mauchlyP = mauchly(rm);

if mauchlyP.pValue <= alpha
    disp('Sphericity condition for RMANOVA not satisfied, proceeding to run the Friedman ANOVA.')
    
    
else
    disp('Sphericity condition satisfied. Proceed to R script associated with this figure to view results from normality test. Running Friedman ANOVA and returning results in case not normal.')
end

% run Friedman ANOVA
[p,tbl,stats]=friedman(compdata,1,'off');
if p < 0.05
    W = kendallsW(compdata);
else
    W = NaN;
end

% update output variables for spreadsheet
rmGroup = [rmGroup;groupName];
rmPhase = [rmPhase;phaseName];
rmMeas = [rmMeas; measurementName];
rmChi = [rmChi; tbl{2,5}];
rmdf = [rmdf; tbl{2,3}];
rmn = [rmn; stats.n];
rmp = [rmp; tbl{2,6}];
rmW = [rmW; W];

end
