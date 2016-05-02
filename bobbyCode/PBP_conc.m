function [total_conc] = PBP_conc(file, time)

data = csvread(file, 122, 0);

times = data(:,1);
%time = floor(time(1)):(1/Hz):ceil(time(end));

for(i=1:length(time))
    if(i~=1)
        total_conc(i) = length(find(times > time(i-1) & times <= time(i)));
    else
        total_conc(i) = length(find(times <= time(i)));
    end    
end



%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


end

