function hfig = modify_Fig(hfig)
    set(0, 'CurrentFigure', hfig)
    xlabel('Distance (ft)','FontSize',10) 
    ylabel('Elevation (in)','FontSize',10) 
    title('Elevation distribution','FontSize',12)
    legend({'Raw data', 'Fitted curve'},'Location','northwest','FontSize',6);
    figWidth = 5;  % 设置图片宽度
    figHeight = figWidth * 0.618;  % 设置图片高度
    set(hfig,'PaperUnits','inches'); % 图片尺寸所用单位
    set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
    
end
