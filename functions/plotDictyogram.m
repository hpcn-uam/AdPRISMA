function plotDictyogram(X,ts,WIND_DICT,beginTime,endTime)

    deciles_sample = quantile(X,0.1:0.1:0.9);

    sec_obs = floor(ts/WIND_DICT)*WIND_DICT;
    G = findgroups(sec_obs);
    ts_sec = splitapply(@mean,sec_obs,G);

    G_dict = findgroups(sec_obs);
    X_dict = splitapply(@(x){(histc(x, [-inf deciles_sample inf]))'},X,G_dict);
    ts_sec = splitapply(@mean,sec_obs,G);

    X_dict_arr = cell2mat(X_dict);
    X_dict_arr_cum = cumsum(X_dict_arr,2);

    
    figure1 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);
    ax1 = axes('Parent',figure1);
    
    dict_abs_ts = timeseries(X_dict_arr_cum,ts_sec);
    dict_abs_ts.TimeInfo.StartDate = '01-Jan-1970';
    dict_abs_ts.TimeInfo.Format = 'HH:MM';
        
    plot(dict_abs_ts )
    ylabel('#(Flows)/Decile')
    xlabel('Time of day')
    title('')

    xlim([beginTime endTime])
    
    set(ax1,'FontName','Times New Roman','FontSize',20,'XGrid','on','YGrid',...
    'on','YMinorTick','on');


    saveas(figure1,sprintf('%d_dict_abs.eps',WIND_DICT),'epsc')


    figure2 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);
    ax2 = axes('Parent',figure2);
    
    X_dict_arr_rel = [];
    
    for ii=1:size(X_dict_arr_cum,2)
    
        X_dict_arr_rel = [X_dict_arr_rel X_dict_arr_cum(:,ii) ./ X_dict_arr_cum(:,end)];
    end
        

    dict_abs_ts = timeseries(X_dict_arr_rel ,ts_sec);
    dict_abs_ts.TimeInfo.StartDate = '01-Jan-1970';
    dict_abs_ts.TimeInfo.Format = 'HH:MM';

    plot(dict_abs_ts )
    ylabel('#(Flows)/Decile')
    xlabel('Time of day')
    title('')
    
    xlim([beginTime endTime])
    

    set(ax2,'FontName','Times New Roman','FontSize',20,'XGrid','on','YGrid',...
    'on','YMinorTick','on');


    saveas(figure2,sprintf('%d_dict_rel.eps',WIND_DICT),'epsc')


    figure3 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);
    ax3 = axes('Parent',figure3);
    dX_dict_arr_rel = sum(abs(diff(X_dict_arr)),2)./sum(X_dict_arr(2:end,:),2);
       

    dict_abs_ts = timeseries(dX_dict_arr_rel,ts_sec(2:end));
    dict_abs_ts.TimeInfo.StartDate = '01-Jan-1970';
    dict_abs_ts.TimeInfo.Format = 'HH:MM';

    plot(dict_abs_ts )
    ylabel('Cumulative relative variation')
    xlabel('Time of day')
    title('')
    
    xlim([beginTime endTime])
    

    set(ax3,'FontName','Times New Roman','FontSize',20,'XGrid','on','YGrid',...
    'on','YMinorTick','on');
    saveas(figure3,sprintf('%d_abs_cum_rel_diff.eps',WIND_DICT),'epsc')
    
    figure4 = figure('Renderer', 'painters', 'Position', [50 50 800 600]);
    ax4 = axes('Parent',figure4);

	dX_rel_dict_arr = diff(X_dict_arr_rel,1);

    
    dict_abs_ts = timeseries(dX_rel_dict_arr,ts_sec(2:end));
    dict_abs_ts.TimeInfo.StartDate = '01-Jan-1970';
    dict_abs_ts.TimeInfo.Format = 'HH:MM';

    plot(dict_abs_ts )
    hold on
    ezplot('0.1')
    ezplot('-0.1')
    
    ylabel('Variation of relative series')
    xlabel('Time of day')
    title('')
    
    xlim([beginTime endTime])
    

    set(ax4,'FontName','Times New Roman','FontSize',20,'XGrid','on','YGrid',...
    'on','YMinorTick','on');
    saveas(figure4,sprintf('%d_diff_rel_dict.eps',WIND_DICT),'epsc')
    
%     ax4 = subplot(2,2,4)
%     hold off
% 
%     for ii=1:(length(deciles_sample)+2)
% 
%         kk = kk + X_dict_arr(:,ii)
%         plot(ts_sec(2:end),diff(kk))    
%         hold all
%     end
% 

    %linkaxes([ax1,ax2],'x')

end