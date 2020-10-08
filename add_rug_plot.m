function add_rug_plot(sub_handle, rugVal, barColor, barHeight)
% This function adds rug plots to the horizontal axis of a figure or
% subplot. It automatalcally adds to the hight of the figure when adding
% the rug plot, so you would not lose any information on the plot. It also
% accepts multiple rugs and multiple colors.
% INPUTS:
%   sub_handle: figure or sub plot handle. If you have a figure that
%   contains subplots, you need to pass the subplot handle.
%
%   rugVal: cell. Each cell element is a row vector with the same length as the
%   horizonal axis, consiting ONLY of zero and ones. The function uses SIGN
%   finuction to ensure only zero and ones are passed. If you want to add
%   two rug plots add another element to the cell. example {[0 0 0 1 1] [1 1 1 0 0]}
%
%   barColor: Color of the rug plots in rgb. If there are multiple
%   rugplots, use a N x 3 array to specify color of each rug. You can also
%   use rgb() function, and pass the color. defaults is black
%   example [rgb('Red'); rgb('Orange')]
%   
%   barHeight: You can specify the height of the rugs. All rugs have the
%   same height. You can specifcy any number. Defaults is equal to 10% of
%   the ylim.
%
% Copyright 2020, Seyed Yahya Shirazi.

if ~iscell(rugVal), rugVal = {rugVal}; end % backward compatibitly for non-cell instances
rugCount = length(rugVal);
for r = 1: rugCount
    singRugVal = rugVal{r}; % only one row of rug plot at a time.
    singRugVal = abs(sign(singRugVal)); % rug plots only accepts 0 and 1.
    if exist('barColor', 'var') && size(barColor,1)==rugCount
        bCol = barColor(r,:);
    else
        barColor = rgb('Black'); bCol = barColor;
        if size(barColor,1)~=rugCount, warning("color columns not equal to the siginificant array. Will use black for all"); end
    end
            if ~isempty(find(singRugVal)) %#ok<EFIND>
                Y = ylim(sub_handle);
                if ~exist('barHeight','var')|| isempty(barHeight); barHeight = (Y(2) - Y(1))*.1; end
                ylim(sub_handle,[Y(1)-barHeight/.8,Y(2)]); Y(1) = Y(1) - barHeight/.95; % devided by 0.8 to let more sapce for the ticks and also for compatibiltiy
                plot(sub_handle, xlim(sub_handle), [Y(1)+barHeight Y(1)+barHeight],'Color',bCol)
                plot(sub_handle,[find(singRugVal);find(singRugVal)],[ones(1,length(find(singRugVal)))*Y(1);...
                    ones(1,length(find(singRugVal)))*Y(1) + barHeight],'Color',bCol,"LineWidth",1)
            end

end