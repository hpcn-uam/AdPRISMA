close all; clc
data = readtable("data/correlados.txt","Delimiter", "|");
X = table2array(data(:,14)) - table2array(data(:,7));
ts = table2array(data(:,1));
N = length(X);
X = X(X > 0);
ts = ts(X > 0);
alpha = 0.00001;

[pvalue, pds] = adjust_long_term(X, ts, alpha);

%%
figure(1); hold on; CM = jet(length(pds));
len = 1;
for i=1:length(pds)
    pd = pds{i};
    interval_data = pd.InputData.data;
    size = length(interval_data);
    plot([len, len+size], [mean(interval_data), mean(interval_data)], "LineWidth", 3, "Color", CM(i, :));
    plot([len, len+size], [mean(interval_data)+std(interval_data), mean(interval_data)+std(interval_data)], "LineWidth", 1, "Color", CM(i, :), "LineStyle", "--");
    plot([len, len+size], [mean(interval_data)-std(interval_data), mean(interval_data)-std(interval_data)], "LineWidth", 1, "Color", CM(i, :), "LineStyle", "--");
    len = len + size;
end
pds_backup = pds;