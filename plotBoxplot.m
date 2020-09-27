function plotBoxplot(data, color, ymax, dotColor)
% had to plot these boxplots as lines instead of rectangles so they could
% be imported into FigureComposer (plotting software maintained by
% Lisberger lab; free download available at
% https://sites.google.com/a/srscicomp.com/datanav/figure-composer)
hold on
for d = 1:7
    meanval = nanmean(data(:,d));
    semval = nanstd(data(:,d))./sqrt(sum(~isnan(data(:,d))));
    minval = min(data(:,d));
    maxval = max(data(:,d));
    plot([d-0.25 d+0.25], [meanval meanval], 'Color', color) % mean
    plot([d-0.25 d+0.25], [meanval+semval meanval+semval], 'Color', color)% mean + SEM
    plot([d-0.25 d+0.25], [meanval-semval meanval-semval], 'Color', color)% mean - SEM
    plot([d d], [meanval+semval maxval], 'Color', color)% mean+SEM to max
    plot([d d], [meanval-semval minval], 'Color', color)% mean-SEM to min
    plot([d-0.25 d-0.25], [meanval-semval meanval+semval], 'Color', color)% box edge left
    plot([d+0.25 d+0.25], [meanval-semval meanval+semval], 'Color', color)% box edge right
    %scatter((ones(1,size(data,1))*d)+((rand(1,size(data,1))-0.5)*0.1), data(:,d), 3, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
    scatter(ones(1,size(data,1))*d, data(:,d), 3, 'MarkerFaceColor', dotColor, 'MarkerEdgeColor', dotColor)
end
xlim([0.5 7.5])
ylim([0 ymax])
xticks([1:7])
xticklabels({'TLast', '1','2','3','4','9','10'})
end