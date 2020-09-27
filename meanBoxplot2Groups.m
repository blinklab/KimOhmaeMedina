function meanBoxplot2Groups(group1, group2, lineColor, dotColor)
hold on
meanval = mean(group1);
semval = std(group1)./sqrt(size(group1,1));
plot([0.75 1.25], [meanval meanval], 'Color', lineColor)
plot([0.75 1.25], [meanval-semval meanval-semval], 'Color', lineColor)
plot([0.75 1.25], [meanval+semval meanval+semval], 'Color', lineColor)
plot([0.75 0.75], [meanval-semval meanval+semval], 'Color', lineColor)
plot([1.25 1.25], [meanval-semval meanval+semval], 'Color', lineColor)
plot([1 1], [min(group1), meanval-semval], 'Color', lineColor)
plot([1 1], [max(group1), meanval+semval], 'Color', lineColor)
%scatter(ones(1,size(group1,1)), group1, 4, 'MarkerFaceColor', dotColor, 'MarkerEdgeColor', dotColor)

meanval = mean(group2);
semval = std(group2)./sqrt(size(group2,1));
plot([1.75 2.25], [meanval meanval], 'Color', lineColor)
plot([1.75 2.25], [meanval-semval meanval-semval], 'Color', lineColor)
plot([1.75 2.25], [meanval+semval meanval+semval], 'Color', lineColor)
plot([1.75 1.75], [meanval-semval meanval+semval], 'Color', lineColor)
plot([2.25 2.25], [meanval-semval meanval+semval], 'Color', lineColor)
plot([2 2], [min(group2), meanval-semval], 'Color', lineColor)
plot([2 2], [max(group2), meanval+semval], 'Color', lineColor)
%scatter(ones(1,size(group1,1))*2, group2, 4, 'MarkerFaceColor', dotColor, 'MarkerEdgeColor', dotColor)
end