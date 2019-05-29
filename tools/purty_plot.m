function purty_plot(figNum, figurename,type)
% Use purty_plot(figureNumber, desiredFigureName)
fontName = 'Helvetica';

figure(figNum);
hFig = figNum;

titleFontSize = 15;
axisFontSize = 12;
% Get axes:
hAxes = findobj(gcf,'type','axes','-not','Tag','legend','-not','Tag','Colorbar');

% get(hFig,'Children');
hPlot = [];

% Get data axes
hData = get(hAxes,'Children');
hTitle = get(hAxes,'Title');

% hLegend =  findobj(hFig,'Type','axes','Tag','legend');
hLabel = [get(hAxes,'xlabel') get(hAxes,'ylabel')];


% Adjust fonts of the axis
for l = 1:length(hAxes)
    if iscell(hAxes)
        
        set(hLabel{l},  ...
            'FontName',fontName , ...
            'FontSize', axisFontSize, ...
            'FontWeight', 'bold',...
            'Box'         , 'off'     , ...
            'GridLineStyle' , 'none'     , ...
            'TickDir'     , 'out'     , ...
            'TickLength'  , [.02 .02] , ...
            'XMinorTick'  , 'on'      , ...
            'YMinorTick'  , 'on'      , ...
            'YGrid'       , 'on'      , ...
            'XColor'      , [.3 .3 .3], ...
            'YColor'      , [.3 .3 .3], ...
            'LineWidth'   , 1         );
    else
        set(hAxes(l),  ...
            'FontName',fontName , ...
            'FontSize', axisFontSize, ...
             'FontWeight', 'bold',...
            'Box'         , 'off'     , ...
            'GridLineStyle' , 'none'     , ...
            'TickDir'     , 'out'     , ...
            'TickLength'  , [.02 .02] , ...
            'XMinorTick'  , 'on'      , ...
            'YMinorTick'  , 'on'      , ...
            'YGrid'       , 'on'      , ...
            'XColor'      , [.3 .3 .3], ...
            'YColor'      , [.3 .3 .3], ...
            'LineWidth'   , 1         );
    end
    
    grid off
end

% Adjust the line smoothing
if ~isempty(hPlot)
    for k = 1:length(hPlot)
        if iscell(hPlot)
            set(hPlot{k}, ...
                'LineSmoothing', 'on',...
                'LineWidth',2);
        else
            set(hPlot(k), ...
                'LineSmoothing', 'on',...
                'LineWidth',2);
        end
    end
end

% Adjust fonts of the labels
if ~isempty(hLabel)
    for i = 1:length(hLabel)
        if iscell(hLabel)
            set(hLabel{i}, ...
                'FontName'   , fontName ,...
                'FontSize'   , titleFontSize,...
             'FontWeight', 'bold');
        else
            set(hLabel(i), ...
                'FontName'   , fontName ,...
                'FontSize'   , titleFontSize,...
             'FontWeight', 'bold');
        end
    end
end

% Make title purty:
for j = 1:length(hTitle)
    if iscell(hTitle)
        
        set(hTitle{j}                    , ...
            'FontName'   , fontName, ...
            'FontSize'   , titleFontSize          , ...
            'FontWeight' , 'bold'      );
    else
        set(hTitle(j)                    , ...
            'FontName'   , fontName, ...
            'FontSize'   , titleFontSize         , ...
            'FontWeight' , 'bold'      );
    end
    
end
% 
% % Make legend purty:
% set([hLegend]                , ...
%     'FontSize'   , 10       , ...
%     'FontName'   , fontName  , ...
%     'location', 'SouthWest'  );

set(gcf, 'PaperPositionMode', 'auto');

if strcmp(type,'eps')
    figurename_eps = [ figurename '.eps'];
    saveas(figNum,figurename_eps,'eps')
elseif strcmp(type,'pdf')
    figurename_pdf = [ figurename '.pdf'];
    print(figurename_pdf,'-dpdf','-bestfit')
elseif strcmp(type,'png')
    figurename_png = [figurename '.png'];
    print(figurename_png,'-dpng')
elseif strcmp(type,'tiff')
    figurename_tif = [figurename '.tiff'];
    saveas(figNum,figurename_tif,'tiff')
 elseif strcmp(type,'svg')
    figurename_svg = [figurename '.svg'];
    saveas(figNum,figurename_svg,'svg')
end
