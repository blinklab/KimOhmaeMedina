%%% expects the following variables:
%%%     timeVector  a vector containing timestamp for each bin in the
%%%                 eyetraces
%%%     traces      a n mice x 200 x 4 array; each row is the FEC values
%%%                 for each bin for the average eyetrace for a mouse; each
%%%                 z-dimensional value contains traces for a single day
%%%     color       the color that you want the lines to be
%%%     ymax        maximum y limit

function [A,B,C,D]=plotEyelidTraces(timeVector, traces, color, ymax)
plot([0.2 0.2], [0 0.8], 'Color', [0 0 0])
hold on
for d = 1:4
    switch d
        case 1
            A = plot(timeVector, nanmean(traces(:,:,d)), 'Color', color);
        case 2
            B = plot(timeVector, nanmean(traces(:,:,d)), 'Color', color, ...
                'LineStyle', '-.');
        case 3
            C = plot(timeVector, nanmean(traces(:,:,d)), 'Color', color, ...
                'LineStyle', '--');
        case 4
            D = plot(timeVector, nanmean(traces(:,:,d)), 'Color', color, ...
                'LineStyle', ':');
    end
end
ylim([0 ymax])
xlim([0 0.25])
set(gca, 'box', 'off', 'TickDir', 'out')
xlabel('Time from Tone (s)')
end