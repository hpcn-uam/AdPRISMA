function [h, p] = KSBetweenModels(model1, model2, n)
    x = random(model1,1, n);
    [h, p] = kstest(x,'CDF',model2);
end

