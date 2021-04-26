function y = likelihood(sigma,X)
    ln1 = -10000*log(sigma*sqrt(2*pi));
    ln2 = 1/(2*sigma^2);
    ln3 = 0;
    for i=1:10000
        ln3 = ln3 + (X(i)-1)^2;
    end
    y = ln1 - ln2*ln3;
end