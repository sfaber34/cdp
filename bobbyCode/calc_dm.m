function dm = calc_dm(conc, bins)

total = sum(conc,2);

if(total > 0)
    cum = 0;
    i = 1;
    while(cum < 0.5*total)
        cum = cum+ conc(i);
        i = i + 1;
    end
    dm = bins(i);

else
    dm = 0;
end