function [pvalue, models] = adjust_long_term(X, alpha)
    % adjust_optimal_model 
    % Tries to fit an adaptive model to X
    
    %% Condicion de parada 1: nos quedamos sin datos
    threshold = 200;
    if length(X) <= threshold
        [pvalue, model] = get_optimal_model(X);
        models = {model};
        return;
    end
    
    %% Condicion de parada 2: look-ahead de mejora 
    % Ajustamos modelo
    [pvalue, model] = get_optimal_model(X);
    
    % Hacemos look-ahead para ver si hay mejora
    sep = ceil(length(X)/2);
    X1 = X(1:sep);
    X2 = X(sep+1:end);
    
    pvalue1 = get_optimal_model(X1);
    pvalue2 = get_optimal_model(X2);
    
    if max(pvalue1, pvalue2) < pvalue + alpha
        models = {model};
        return
    end
    
    %% Recursion
    [pvalue1, models1] = adjust_long_term(X1, alpha);
    [pvalue2, models2] = adjust_long_term(X2, alpha);
    
    models = [models1, models2];
    pvalue = max(pvalue1, pvalue2);
end

