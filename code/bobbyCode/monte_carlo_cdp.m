num_ensembles = 10;
%% How many particles from population?
%% Assume uniform size with variable concentration

time = 0.1;                                        % Time of simulation in s
%sa = calc_sa(128,25,61,64);

saq = 0.24;                                      % Qualified Sample volume of CDP in mm^2
sae = 20.1;                                      % Extended sample volume of CDP in mm^2
%N = 100;                                             % Number concentration of natural particles cm-3
Nliq = 500;                                       % Number concentration of liquid particles cm-3
%particle_size = 500;                                 % 1000 micron particle
%liq_size = 25;

%sa = sa(40);
num_fragments = 0;                                  % # of fragments is normal distribution with mean
%sa_frag = sa(5);
tas = 100;
dt = 2.5e-7;                                          % Clock frequency of probe
int_arr_qualified = 1/((tas*100*saq*(1e-1)^2)*(Nliq));
int_arr_extended = 1/((tas*100*sae*(1e-1)^2)*(Nliq));
%shattered_dist = 100000;                              % Distance of shattered particle
 
P_break = 0;                                       % Probability of breakup (assume 1%)


hists = zeros(num_ensembles,40);
for(i=1:num_ensembles)
    int_arr = [];
    time_since_last_natural_particle = 0;
    time_since_last_liquid_particle = 0;
    time_since_last_artifact = 0;
    time_to_next_impact = Inf;
    num_pieces = 0;
    time_to_next_natural_particle = 1/poissrnd(1/int_arr_qualified);
    time_to_next_liquid_particle = 1/poissrnd(1/int_arr_extended);
    time_to_next_fragment = Inf;
    
    t = 0;
    while(t < time);
        % Handle population of shattered particles
        dt = min([time_to_next_fragment time_to_next_natural_particle time_to_next_impact time_to_next_liquid_particle]);

        if(num_pieces > 0)
            % Does a shattered fragment appear?
            if(time_to_next_fragment <= time_since_last_artifact)
                int_arr = [int_arr; time_since_last_artifact];
                time_since_last_artifact = 0;
                num_pieces = num_pieces - 1;
                time_to_next_fragment = -log(rand(1))*int_arr_fragment;
            else
                time_since_last_artifact = time_since_last_artifact + dt;          
            end
        end 
        % Handle population of natural particles
        if(time_to_next_natural_particle <= time_since_last_natural_particle)

            % Does particle shattter?
            if(rand(1) <= P_break)
                % How many pieces does it break into?
                num_pieces = num_pieces + num_fragments;
                % Assume volume per D^3 
                Conc_artifact = num_pieces/((shattered_dist*1e-4)*sa(5)*(1e-1)^2);
                % Mean arrival rate
                int_arr_fragment = 1/(Conc_artifact*(tas*100*sa(5)*(1e-1)^2));
                time_to_next_fragment = -log(rand(1))*int_arr_fragment;
                int_arr = [int_arr; time_since_last_natural_particle];
            else
                int_arr = [int_arr; time_since_last_natural_particle];
            end    
            time_since_last_natural_particle = 0;
            
            time_to_next_natural_particle = -log(rand(1))*int_arr_qualified;
            
        end    
        time_since_last_natural_particle = time_since_last_natural_particle+dt; 
        % Hangle liquid drops
        % Handle population of natural particles
        if(time_to_next_liquid_particle <= time_since_last_liquid_particle)
            int_arr = [int_arr; time_since_last_liquid_particle];
            time_since_last_liquid_particle = 0;
            %last_natural_particle = 0;
            time_to_next_liquid_particle = -log(rand(1))*int_arr_extended;
            
        end    
        time_since_last_liquid_particle = time_since_last_liquid_particle+dt; 
        if(mod(t,dt*1000000) == 0)
            disp([num2str(t) '/' num2str(time)]);
        end
        t = t + dt;
    end
    [h,bins] = hist(int_arr(int_arr > 0), logspace(-7,0,40));
    hists(i,:) = h;
    int_arr = [];
    disp(['Ensemble member ' num2str(i) ' complete']);
end

save hists.mat
figure;

for(i=1:num_ensembles)
    plot(bins, hists(i,:)/(sum(hists(i,:),2))*100, 'r', 'LineWidth', 1);
    hold on;
end    
set(gca, 'XScale', 'log');
xlabel('\DeltaT [s]');
ylabel('%');
title(['TAS = ' num2str(tas) ' P_{break} = ' num2str(P_break*100) '% N_{liq} = ' num2str(Nliq) ' cm^{-3} mean fragments = ' num2str(num_fragments)]);
bimodalfit = @(tau, dt) tau(3).*(dt/tau(1)).*exp(-dt/tau(1))+(1-tau(3)).*(dt/tau(2)).*exp(-dt/tau(2));
%[tau_std1] = abs(nlinfit(bins,h./sum(h),bimodalfit,[1e-6 1e-4 0.5], statset('Robust', 'on')));
hold on;
%plot(logspace(-7, 1, 300), bimodalfit(tau_std1, logspace(-7, 1, 300))*100, 'r', 'LineWidth', 2);


%% Plot interarrival time distribution
