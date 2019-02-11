function [Rsq] = Rsquared(data, model, n)
    QQ = data(randperm(length(data), n));
    qq_x = linspace(0.0001, 0.9999, length(QQ));
    qq_y = icdf(model, qq_x);
    qq_z = sort(QQ);
    mdl = fitlm((qq_z),(qq_y));
    Rsq = mdl.Rsquared.Ordinary;
end

