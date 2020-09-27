function [W] = kendallsW(data)
% measure of data coherence, for effect size of friedman anovas
% each mouse is in a row, total rows is m
% each day is in a column, total columns is k
% assumes no missing data
% using definition of kendall's w from https://www.real-statistics.com/reliability/interrater-reliability/kendalls-w/
%
%   W = 12R/(m^2 (k^3-k))
%
%   R = sum across all k (Ri - Rbar)^2 = squared deviation
%   Rbar = mean(Ri)
%   Ri = sum across all m(rij)
%
%   where:
%           each mouse is one m
%           each day is one k
%           rij is the rating that mouse j had for day i
%           Ri is the sum of each mouse's ranks for a single day, i
%           Rbar is the mean of all the days' Ri values

rankedData = nan(size(data,1), size(data,2));
for r = 1:size(data,1)
    [~,~,ranking]=unique(data(r,:));
    rankedData(r,:) = ranking';
end

Ri = sum(rankedData);
Rbar = mean(Ri);

squaredDevs = nan(1,length(Ri));
for i = 1:length(squaredDevs)
    squaredDevs(1,i) = (Ri(1,i) - Rbar).^2;
end

R = sum(squaredDevs);

k = size(data,2);
m = size(data,1);
W = (12*R)./((m.^2)*((k.^3)-k));

end