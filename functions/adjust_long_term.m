function [pvalue, models] = adjust_long_term(X, ts, alpha)
    % adjust_optimal_model 
    % Tries to fit an adaptive model to X
    
    %% Condicion de parada 1: nos quedamos sin datos
    threshold = 100;
    if length(X) <= threshold
        [pvalue, model] = get_optimal_model(X);
        models = {model};
        return;
    end
    
    %% Condicion de parada 2: look-ahead de mejora 
    % Ajustamos modelo
    [pvalue, model] = get_optimal_model(X);
    
    % Hacemos look-ahead para ver si hay mejora
    sep = find_separator(X, ts);
    X1 = X(1:sep);
    X2 = X(sep+1:end);
    ts1 = ts(1:sep);
    ts2 = ts(sep+1:end);
    
    [pvalue1, model1, Rsq1] = get_optimal_model(X1);
    [pvalue2, model2, Rsq2] = get_optimal_model(X2);
    if max(pvalue1, pvalue2) < pvalue + alpha
        models = {model};
        return
    end
    
    %% Recursion
    [pvalue1, models1] = adjust_long_term(X1, ts1, alpha);
    [pvalue2, models2] = adjust_long_term(X2, ts2, alpha);
    
    models = [models1, models2];
    pvalue = max(pvalue1, pvalue2);
end

