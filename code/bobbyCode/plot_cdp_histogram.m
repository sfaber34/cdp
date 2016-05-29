period_to_view = 7;

switch(period_to_view)
    case 1
        filename = '8um_10Hz.csv';
    case 2
        filename = '10um_10Hz.csv';
    case 3
        filename = '15um_10Hz.csv';
    case 4
        filename = '20um_10Hz.csv';
    case 5
        filename = '30um_10Hz.csv';
    case 6
        filename = '40um_10Hz.csv';
    case 7
        filename = '50um_10Hz.csv';
end        

filename = '/Users/spencerfaber/research/cdp/code/data/CDP_20160519_203922F.csv';

data = csvread(filename, 1, 19);

CDP_bins = [2, 3.000000,4.000000,5.000000,6.000000,7.000000,8.000000,9.000000,10.000000,11.000000,12.000000,13.000000,14.000000,16.000000,18.000000,20.000000,22.000000,24.000000,26.000000,28.000000,30.000000,32.000000,34.000000,36.000000,38.000000,40.000000,42.000000,44.000000,46.000000,48.000000,50.000000]
CDP_bin_dD = diff(CDP_bins);
CDP_bins = CDP_bins(1:end-1)+CDP_bin_dD./2;CDP_conc = data(:,1:30);
CDP_n = sum(CDP_conc,2);



for(i=1:length(CDP_n))
    CDP_mvd(i) = calc_dm(CDP_conc(i,:), CDP_bins);
    CDP_std(i) = calc_std(CDP_conc(i,:), CDP_bins);
end
%time = data(:,1);

%hours = floor(time/3600);
%minutes = floor((time-hours*3600)/60);
%seconds = mod(time,60);

%time_hhmmss= hours*1e4+minutes*1e2+seconds;

glass_bead_sizes = [8 10 15 20 30 40 50];
water_sizes = [6.2 7.5 14 15.75 25.25 35 39.5];
water_std_mins = [5.4 7.2 12.5 14.25 23.5 33.5 37.25]  
water_std_maxs = [7.2 8.1 15.2 16.1 26.75 35.75 41.75]
%times_1Hz = [132745 132830; 133000 133130; 133500 133600; 133800 134000; 134000 134300; 134700 135100; 135100 135400];
%times_5Hz = [135600 135700; 140000 140100; 140300 140400; 141100 141200; 141700 141200; 141700 141800; 144200 144400];
%times_2Hz = [154200 154400; 154600 154800; 155000 155100; 155200 155300; 155500 155600; 155700 155800; 155800 155900];



%start_time = times_2Hz(period_to_view,1);
%end_time = times_2Hz(period_to_view,2);

total = sum(CDP_conc,2);
threshold_low = 00;
threshold_high = 20;

% figure
% PBP_n = PBP_conc('5HzPBP.csv', time);
% 
% scatter(sum(CDP_conc,2), PBP_n, 49, 'r', 'filled');
% hold on;
% plot([0 10000], [0 10000], 'k', 'LineWidth', 2);
% xlim([0 500]);
% ylim([0 500]);
% set(gca, 'FontSize', 15, 'FontWeight', 'bold');
% xlabel('Total # [Histogram file]');
% ylabel('Total # [PBP file]');
% 

figure
indicies = find(total > threshold_low & total < threshold_high);
histogram = sum(CDP_conc(indicies,:),1);
stairs(CDP_bins, sum(CDP_conc(indicies,:),1), 'r', 'LineWidth', 2);
hold on;
plot([water_sizes(period_to_view) water_sizes(period_to_view)], [-1000 1000], 'k', 'LineWidth', 2);
plot([water_std_mins(period_to_view) water_std_mins(period_to_view)], [-1000 1000], 'k--', 'LineWidth', 2);
plot([water_std_maxs(period_to_view) water_std_maxs(period_to_view)], [-1000 1000], 'k--', 'LineWidth', 2);
ylim([0 max(histogram)*1.1]);
set(gca, 'FontSize', 20, 'FontWeight', 'bold');
xlabel('D [\mum]');
ylabel('Counts');
title([num2str(threshold_low) ' < counts < ' num2str(threshold_high)]);

figure

subplot(2,1,1);

indicies = 1:length(CDP_conc);
plot(time(indicies), sum(CDP_conc(indicies,:),2), 'LineWidth', 2);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Time [s]');
ylabel('Count [#]');

subplot(2,1,2);

indicies = 1:length(CDP_conc);
plot(time(indicies), CDP_mvd(indicies), 'LineWidth', 2);
set(gca, 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Time [s]');
ylabel('D_{m} [\mum]');

figure;

subplot(2,1,1);
indicies = 1:length(CDP_conc);
scatter(sum(CDP_conc(indicies,:),2), CDP_mvd(indicies), 'LineWidth', 2);
hold on;
set(gca, 'FontSize', 15, 'FontWeight', 'bold', 'XSCale', 'log');
plot(get(gca, 'XLim'), [water_sizes(period_to_view) water_sizes(period_to_view)], 'k', 'LineWidth', 2);
xlabel('Counts [#]');
ylabel('D_{m} [\mum]');

subplot(2,1,2);
indicies = 1:length(CDP_conc);
scatter(sum(CDP_conc(indicies,:),2), CDP_std(indicies), 'LineWidth', 2);
hold on;
set(gca, 'FontSize', 15, 'FontWeight', 'bold', 'XSCale', 'log');
plot(get(gca, 'XLim'), [water_sizes(period_to_view) water_sizes(period_to_view)], 'k', 'LineWidth', 2);
xlabel('Counts [#]');
ylabel('D_{std} [\mum]');

