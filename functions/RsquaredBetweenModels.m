function [Rsq] = RsquaredBetweenModels(model1, model2, n)
    qq_x = linspace(0.0001, 0.9999, n);
    qq_y1 = icdf(model1, qq_x);
    qq_y2 = icdf(model2, qq_x);
    mdl = fitlm((qq_y1),(qq_y2));
    %figure; plot(qq_y1, qq_y2)
    coef_1 = table2array(mdl.Coefficients(1,1));
    coef_x = table2array(mdl.Coefficients(2,1));
    
    Rsq = mdl.Rsquared.Adjusted;
    if abs(coef_1) > 2.5
        Rsq = mdl.Rsquared.Adjusted*0.9;
    end
    
    if abs(coef_x - 1) > 1
        Rsq = mdl.Rsquared.Adjusted*0.9;
    end

end

