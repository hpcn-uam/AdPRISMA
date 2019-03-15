close all; clc
data = readtable('correlados.txt','Delimiter', '|');

%data = readtable('correlados_10.98.7.13.txt','Delimiter', '|');
X = table2array(data(:,14)) - table2array(data(:,7));
ts = table2array(data(:,1));
N = length(X);

data_filt = data((X<1),:);

X = X(X > 0);
ts = ts(X > 0);
alpha = 0.00001;

X_filt = X(X<1);
ts_filt = ts(X<=quantile(X,0.999));

X_filt_1 = X_filt(1:floor(size(X_filt,1)/4),:);
ts_filt_1 = ts_filt(1:floor(size(X_filt,1)/4),:);

hist((X_filt_1-mean(X_filt_1))/std(X_filt_1),sqrt(length(X_filt_1)))

ksdensity(log(X_filt_1))

createFit(X,'total_flows_nolog.eps');


for ii=[1 30 60 300]
    
sec_obs = floor(ts/ii)*ii;
G = findgroups(sec_obs);
ts_sec = splitapply(@mean,sec_obs,G);


X_sec_mean = splitapply(@mean,X,G);
X_sec_median = splitapply(@median,X,G);
X_sec_p95 = splitapply(@(x)quantile(x,0.95),X,G);
%X_sec_max = splitapply(@max,X,G);

createFit(X_sec_mean,sprintf('%dsec_mean.eps',ii));
createFit(X_sec_p95,sprintf('%dsec_p95.eps',ii));
%createFit(X_sec_max,sprintf('%dsec_max.eps',ii));
createFit(X_sec_median,sprintf('%dsec_median.eps',ii));

end


hold off
%plot(ts,X)
%hold all
%plot(ts_sec,X_sec_max,'^')
%plot(ts_sec,X_sec_p95,'o')
%plot(ts_sec,X_sec_median,'*')
plot(ts_sec,X_sec_mean)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
Fs = 30;            % Sampling frequency (1 sec)
T = 1/Fs;             % Sampling period (1 Hz)
L = length(total_flows); % Length of signal
t = (0:L-1)*T;        % Time vector




Y = fft(total_flows);
P2 = abs(Y/L);
P1 = P2(1:floor(L/2)+1,:);
P1(2:end-1,:) = 2*P1(2:end-1,:);

hold off
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')


plot(ts, X)

% 
% [pvalue, pds] = adjust_long_term(X, ts, alpha);
% 
% %%
% figure(1); hold on; CM = jet(length(pds));
% len = 1;
% for i=1:length(pds)
%     pd = pds{i};
%     interval_data = pd.InputData.data;
%     size = length(interval_data);
%     plot([len, len+size], [mean(interval_data), mean(interval_data)], "LineWidth", 3, "Color", CM(i, :));
%     plot([len, len+size], [mean(interval_data)+std(interval_data), mean(interval_data)+std(interval_data)], "LineWidth", 1, "Color", CM(i, :), "LineStyle", "--");
%     plot([len, len+size], [mean(interval_data)-std(interval_data), mean(interval_data)-std(interval_data)], "LineWidth", 1, "Color", CM(i, :), "LineStyle", "--");
%     len = len + size;
% end
% pds_backup = pds;