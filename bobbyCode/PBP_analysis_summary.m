clear
for(l=1:7)
    period_to_view = l;

    switch(period_to_view)
        case 1
            file = '8um_PBP.csv';
        case 2
            file = '10um_PBP.csv';
        case 3
            file = '15um_PBP.csv';
        case 4
            file = '20um_PBP.csv';
        case 5
            file = '30um_PBP.csv';
        case 6
            file = '40um_PBP.csv';
        case 7
            file = '50um_PBP.csv';
    end      


    
    data = csvread(file, 0, 19);
    s = size(data);
    time_strings = textread(file, '%s', 'whitespace', ',');
    glass_bead_sizes = [8 10 15 20 30 40 50];
    water_sizes = [6.2 7.5 14 15.75 25.25 35 39.5];
    water_std_mins = [5.4 7.2 12.5 14.25 23.5 33.5 37.25];  
    water_std_maxs = [7.2 8.1 15.2 16.1 26.75 35.75 41.75];

    total_conc = zeros(s(1),1);
    %% Get information for every particle
    j = 1;
    for(i=1:s(1))
        times = textscan(time_strings{(i-1)*306+2}, '%d:%d:%f');
        hours(j) = times{1};
        minutes(j) = times{2};
        seconds(j) = times{3};
        time_hhmmss1(i) = double(hours(j))*1e4+double(minutes(j))*1e2+double(seconds(j));  
        CDP_conc(i,:) = data(i,1:30);
        first_PBP_time = data(i,31);
        for(k=32:s(2)-1)
            %% Put byte into order 2, 3, 0, 1 -> 3, 2, 1, 0

            %byte2 = uint32(bitget(data(i,k), 32:-1:25));
            %byte3 = uint32(bitget(data(i,k), 24:-1:17));
            %byte0 = uint32(bitget(data(i,k), 16:-1:9));
            %byte1 = uint32(bitget(data(i,k), 8:-1:1));
            %byte = uint32(sum(uint32(2.^(31:-1:24)).*byte3) + sum(uint32(2.^(23:-1:16)).*byte2)+sum(uint32(2.^(15:-1:8)).*byte1)+sum(uint32(2.^(7:-1:0)).*byte0));
            byte = uint32(data(i,k));
            %% Get first 20 bits:
            ADCbits = uint32(bitget(byte, 12:-1:1));        
            ADC(j) = sum(uint32(2.^(11:-1:0)).*ADCbits);
            IntArrbits = uint32(bitget(byte, 32:-1:13));        
            Time(j) = sum(uint32(2.^(19:-1:0)).*IntArrbits);
            if(ADC(j) > 0)
                part_time_hhmmss(j) = Time(j)*1e-6 + double(hours(j))*1e4+double(minutes(j))*1e2+double(seconds(j)) + first_PBP_time*1e-6; 
                part_time_s(j) = Time(j)*1e-6 + double(hours(j))*3600+double(minutes(j))*60+double(seconds(j)) + first_PBP_time*1e-6; 
                if(j == 1)
                    int_arr(j) = NaN;
                else
                    int_arr(j) = part_time_s(j)-part_time_s(j-1);
                end
                j = j + 1;
                hours(j) = times{1};
                minutes(j) = times{2};
                seconds(j) = times{3};
                total_conc(i) = total_conc(i) + 1;

            end
        end
    end

    time_hhmmss = double(hours)*1e4+double(minutes)*1e2+double(seconds);
    time_hhmmss = time_hhmmss(1:end-1);
    for(j=1:length(time_hhmmss1))
        timevec(j) = datenum(num2str(floor(time_hhmmss1(j))), 'HHMMSS');
    end    
    %ADC(ADC < 20) = NaN;
    thresholds_low = [0 0 0 0 0 0 0];
    thresholds_high = [100 100 100 100 20 20 20];
    %bin_thresholds = [20 91 111 159 190 215 243 254 272 301 355 382 488 636 751 846 959 1070 1297 1452 1665 1851 2016 2230 2513 2771 3003 3220 3424 3660 4095];
%bin_thresholds = [20 64 89 115 147 169 188 220 262 308 356 407 461 583 707
%829 983 1148 1324 1512 1697 1909 2131 2365 2610 2864 3097 3337 3583 3879 4096];
bin_thresholds = [20 83 105 173 219 265 307 353 367 407 428 445 502 593 726 913 1100 1258 1396 1523 1661 1803 2008 2274 2533 2782 3017 3252 3477 3716 4025];
    CDP_bins = [2, 3.000000,4.000000,5.000000,6.000000,7.000000,8.000000,9.000000,10.000000,11.000000,12.000000,13.000000,14.000000,16.000000,18.000000,20.000000,22.000000,24.000000,26.000000,28.000000,30.000000,32.000000,34.000000,36.000000,38.000000,40.000000,42.000000,44.000000,46.000000,48.000000,50.000000];
    CDP_bin_mids = CDP_bins(1:end-1)+diff(CDP_bins)/2;
    for(j=1:s(1))
        indicies = find(time_hhmmss == time_hhmmss1(j))
        ADC_sorted(j,:) = histc(ADC(indicies), bin_thresholds);
    end
    
    threshold_low = thresholds_low(l);
    threshold_high = thresholds_high(l);
    indicies = find(total_conc > threshold_low & total_conc < threshold_high);
    
    histogram = sum(ADC_sorted(indicies,:),1); 
    dm(l) = calc_dm(histogram, CDP_bins);
    %% Calculate 95% confidence interval
    std(l) = calc_std(histogram, CDP_bins)./sqrt(sum(histogram,2))*1.95;
    water_std(l,:) = [water_sizes(l)-water_std_mins(l); -water_sizes(l)+water_std_maxs(l)]./sqrt(sum(histogram,2))*1.95;
end

figure
scatter(water_sizes, dm, 49, 'r', 'filled');
hold on;
errorbar(water_sizes, dm, std, 'r.');
for(i=1:length(water_sizes))
    plot([water_sizes(i)-water_std(i,1) water_sizes(i)+water_std(i,2)], [dm(i) dm(i)], 'r', 'LineWidth', 2);
end
plot([0 50], [0 50], 'k', 'LineWidth', 2);

fit = polyfit(water_sizes, dm, 1);
plot([0 50], polyval(fit, [0 50]), 'r', 'LineWidth', 2);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
legend(['Y = ' num2str(fit(1)) 'X + ' num2str(fit(2))]);
xlabel('Expected size [\mum]');
ylabel('Mean size [\mum]');

