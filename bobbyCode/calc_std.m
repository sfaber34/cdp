function st = calc_dm(conc, bins)

total = sum(conc,2);

%% Calculate mean

d_bar = (conc*bins')./total;

if(total > 0)
    var = (bins-d_bar).^2*conc'./total;
    st = sqrt(var);
else
    st = 0;
end