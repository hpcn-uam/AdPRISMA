function [pvalue, model, criterion, Rsq] = get_optimal_model(data)
%get_optimal_model Obtains optimal model based 
    mode = "BIC";
    distros = ["Normal", "Lognormal", "GeneralizedExtremeValue", "Burr", "Stable"];%, "tLocationScale"];
    distros = ["Normal", "Lognormal", "GeneralizedExtremeValue", "Burr"];%, "Stable"];%, "tLocationScale"];
    n_distros = length(distros);
    pvalues = zeros(1, n_distros);
    models = cell(1, n_distros);
    criteria = zeros(1, n_distros);
    % For each distribution...
    for distro_c = 1:n_distros
        distro = char(distros(distro_c));
        % Fit the distribution
        try
            models{distro_c} = fitdist(data, distro);
        catch exception
           	if exception.identifier == "stats:addburr:WeibullBetter"
                models{distro_c} = fitdist(data, 'weibull');
            end
        end
        % Chi^2 Goodness of Fit test
        QQ = data;%(randperm(length(data), ceil(length(data)*0.1)));
        [h(distro_c), pvalues(distro_c)] = chi2gof(QQ, 'CDF', models{distro_c});
        % Model selection
        if mode == "AIC"
            k = length(models{distro_c}.ParameterValues);
            logL = sum(log(pdf(models{distro_c}, data)));
            criteria(distro_c) = (2*k - 2*logL);
            criteria(distro_c) = -criteria(distro_c);
        elseif mode == "BIC"
            k = length(models{distro_c}.ParameterValues);
            logL = sum(log(pdf(models{distro_c}, data)));
            criteria(distro_c) = (log(length(data))*k-2*logL);
            criteria(distro_c) = -criteria(distro_c);
        elseif mode == "Rsq"
            QQ = data;%(randperm(length(data), length(data)));
            qq_x = linspace(0.0001, 0.9999, length(QQ));
            qq_y = icdf(models{distro_c}, qq_x);
            qq_z = sort(QQ);
            mdl = fitlm((qq_z),(qq_y));
            criteria(distro_c) = mdl.Rsquared.Ordinary;
        end

    end
    [~, i] = max(criteria);
    model = models{i};
    pvalue = pvalues(i);
    criterion = criteria(distro_c);
    Rsq = Rsquared(data, model, length(data));
end


