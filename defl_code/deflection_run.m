clc
clear
close all

%% The directory of your files
str = [uigetdir('E:\TianKexin\Site List_Deflection\','Choose the root path of dataset'),'\'];
%% dir set by depth-first walk
mFiles = [];
[mFiles, iFilesCount] = DeepTravel(str,mFiles,0);
mFiles = mFiles';
erd_set = regexp(mFiles, '.erd');
len = length(cell2mat(erd_set));
bar = waitbar(0,'data processing...');
log = fopen(fullfile(str,'error_log.txt'),'a');
cur_num = 0;
%% solve
for k = 1:length(erd_set)

    if isempty(erd_set{k}) == 1
        continue
    end
    cur_num = cur_num + 1;
    str=['data processing...',num2str(cur_num),'/',num2str(len)];
    waitbar(cur_num/len,bar,str);
    fprintf('Running: %d/%d\n',[cur_num,len]);
    filepath = mFiles{k};
    if regexpi(filepath, '\\dir_Down\\')
        dir = 'down';
    elseif regexpi(filepath, '\\dir_Up\\')
        dir = 'up';
    else
        warning(['Cannot get direction of file:', filepath])
        continue
    end
    indx = regexpi(filepath, '\JS_\d*ft\');
    js = findFirstNumber(filepath(indx:end));
    D = 1/12;
    F = js;
    NS = js;
    B = 3;
    [filenames, profiles, num_file] = erd_read(filepath);
    for i = 1:num_file
        %bar = waitbar(0,[filenames(i,:), ' processing...']);
        fig_path = [filenames(i,:),'_slabImages'];
        mkdir(fig_path);
        filename = [filenames(i,:),'.xlsx'];
        profile = profiles(:,[1,i+1]);
        try
            [ind3, x6, y6] = Joint_Detection_2 (profile, D, F, NS, B, dir);
        catch
            warning(['Cannot get ind3, skip: ',filename]);
            filename = strrep(filename,'\','\\');
            fprintf(log,['Cannot get ind3, skip: ',filename,'\n']);
            continue;
        end
        cur_index = 1;
        prev_index = 1;
        x_cur = 0;
        [row,~] = size(profile);
        rst = zeros(row,7);
        stat = zeros(length(ind3)+1, 6); % 
        for j = 1:length(ind3)+1
            
            if j == length(ind3) + 1
                last_idx = row;
            else
                last_idx =ind3(j);    
            end
            section = profile(cur_index:last_idx,:);
            prev_index = cur_index;
            cur_index = last_idx;
            x = section(:,1);
            y = section(:,2);
            x_fit = x - x(1);
            [p,S] = polyfit(x_fit,y,2);
            R2 = 1 - (S.normr/norm(y - mean(y)))^2;
            y1 = polyval(p,x_fit);
            angle = atan((y1(end) - y1(1))/(x_fit(end) - x_fit(1)));
            fit_rotated = rotate_curve([x_fit,y1], [x_fit(1), y1(1)], angle);
            raw_rotated = rotate_curve([x_fit,y], [x_fit(1), y1(1)], angle);
            raw_rotated(:,2) = raw_rotated(:,2) - fit_rotated(1,2);
            fit_rotated(:,2) = fit_rotated(:,2) - fit_rotated(1,2);
            raw_rotated(:,1) = raw_rotated(:,1) - raw_rotated(1,1) + x_cur;
            fit_rotated(:,1) = fit_rotated(:,1) - fit_rotated(1,1) + x_cur;
            rst(prev_index:cur_index,1:7) = [raw_rotated(:,1:2), fit_rotated(:,1:2),x,y,y1];
            stat(j,:) = [j, max(abs(fit_rotated(:,2))),p, R2];
            x_cur = raw_rotated(end,1);
            fig_name = ['fig_slab_',num2str(j, '%.5d'),'.tif'];
            
            %%%%%%%%%%% ouput image if needed %%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%
%             if R2 >= 0.993
%                 h = figure;
%                 set(h,'visible','off');
%                 scatter(raw_rotated(:,1),raw_rotated(:,2),80,'.');
%                 hold on
%                 plot(fit_rotated(:,1),fit_rotated(:,2),'-d','LineWidth',2,'MarkerIndices',1:10:length(fit_rotated(:,2)));
%                 line(xlim(), [0,0],'LineStyle','-.', 'LineWidth', 1, 'Color', 'k');
%                 h = modify_Fig(h);
%                 saveas(h,fullfile(fig_path,fig_name));
%                 print(h,fullfile(fig_path,fig_name),'-r600','-dtiff'); 
%                 close(h);
%                 %waitbar(j/(length(ind3)+1),bar)
%                 fprintf('got slab: %d/%d\n',[j,length(ind3)+1]);
%             end
            
        end
        raw_x = rst(:,1);
        raw_y = rst(:,2);
        fitted_x = rst(:,3);
        fitted_y = rst(:,4);
        fitted_y_abs = abs(rst(:,4));
        x_unrotated = rst(:,5);
        y_unrotated = rst(:,6);
        y_fitted_unrotated = rst(:,7); 
        csvwrite([filenames(i,:),'_fitted_y.csv'],y_fitted_unrotated);
        
        T1 = table(raw_x, raw_y, fitted_x, fitted_y, fitted_y_abs, x_unrotated, y_unrotated, y_fitted_unrotated);
        slab_index = stat(:,1);
        deflection = stat(:,2);
        ind3 = [ind3;length(profile)];
        p = stat(:,3:5);
        R = stat(:,6);
        culvature_degree = 2.*p(:,1)./144./12.*100000;
        deflection_mean = mean(deflection);
        culvature_degree_mean = mean(culvature_degree);
        T2 = table(slab_index, ind3, deflection, p, R, culvature_degree);
        T3 = table(deflection_mean, culvature_degree_mean);
        
        writetable(T1, filename, 'Sheet',1);
        writetable(T2, filename, 'Sheet',2);
        writetable(T3, filename, 'Sheet',2, 'Range','I1:J6');
        
        disp(['Finished:', filename]);
    end

end
fclose(log);
disp('Done!');




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


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
