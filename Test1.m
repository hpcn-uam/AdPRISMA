close all; clc
N = 10000;
X = normrnd(12, 2, N, 1);
X = [X; normrnd(15, 2, N, 1)];
alpha = 0.01;

[pvalue, pds] = adjust_long_term(X, 1:length(X), alpha);

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
%% Merge models (Rsq)
tolerance = 1 - 1e-3;
pds = pds_backup;
count = 1;
new_pds = {pds{count}};
K = 1e5;
for i=2:length(pds)
    pd1 = new_pds{count};
    interval_data1 = pd1.InputData.data;
    pd2 = pds{i};
    interval_data2 = pd2.InputData.data;
    data = [interval_data1; interval_data2];
    if RsquaredBetweenModels(pd1, pd2, K) >= tolerance
        [~, new_pds{count}] = get_optimal_model(data);
    else
        count = count + 1;
        new_pds{count} = pd2;
    end
end

figure(2); hold on; 
CM = jet(length(new_pds));
len = 1;
for i=1:length(new_pds)
    pd = new_pds{i};
    interval_data = pd.InputData.data;
    size = length(interval_data);
    plot([len, len+size], [mean(interval_data), mean(interval_data)], "LineWidth", 3, "Color", CM(i, :));
    plot([len, len+size], [mean(interval_data)+std(interval_data), mean(interval_data)+std(interval_data)], "LineWidth", 1, "Color", CM(i, :), "LineStyle", "--");
    plot([len, len+size], [mean(interval_data)-std(interval_data), mean(interval_data)-std(interval_data)], "LineWidth", 1, "Color", CM(i, :), "LineStyle", "--");
    len = len + size;
end

%% Merge models (KS)
pds = pds_backup;
count = 1;
new_pds = {pds{count}};
K = 50
00;
for i=2:length(pds)
    pd1 = new_pds{count};
    interval_data1 = pd1.InputData.data;
    pd2 = pds{i};
    interval_data2 = pd2.InputData.data;
    data = [interval_data1; interval_data2];
    if KSBetweenModels(pd1, pd2, K)
        [~, new_pds{count}] = get_optimal_model(data);
    else
        count = count + 1;
        new_pds{count} = pd2;
    end
end

figure(3); hold on; 
CM = jet(length(new_pds));
len = 1;
for i=1:length(new_pds)
    pd = new_pds{i};
    interval_data = pd.InputData.data;
    size = length(interval_data);
    plot([len, len+size], [mean(interval_data), mean(interval_data)], "LineWidth", 3, "Color", CM(i, :));
    plot([len, len+size], [mean(interval_data)+std(interval_data), mean(interval_data)+std(interval_data)], "LineWidth", 1, "Color", CM(i, :), "LineStyle", "--");
    plot([len, len+size], [mean(interval_data)-std(interval_data), mean(interval_data)-std(interval_data)], "LineWidth", 1, "Color", CM(i, :), "LineStyle", "--");
    len = len + size;
end


