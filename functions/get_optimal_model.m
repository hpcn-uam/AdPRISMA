function [pvalue, model] = get_optimal_model(data)
%get_optimal_model Obtains optimal model based 
    mode = "BIC";
    distros = ["Normal", "Lognormal", "GeneralizedExtremeValue", "Burr", "Stable"];%, "tLocationScale"];
    distros = ["Normal", "Lognormal", "GeneralizedExtremeValue", "Burr"];%, "Stable"];%, "tLocationScale"];
    n_distros = length(distros);
    pvalues = zeros(1, n_distros);
    models = cell(1, n_distros);
    criteria = zeros(1, n_distros);
    distro_c = 0;
    % For each distribution...
    for distro_s = distros
        distro_c = distro_c + 1;
        distro = char(distro_s);
        % Fit the distribution
        models{distro_c} = fitdist(data, distro);
        % Chi^2 Goodness of Fit test
        QQ = data;%(randperm(length(data), 500));
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
            QQ = data(randperm(length(data), 100));
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
end


