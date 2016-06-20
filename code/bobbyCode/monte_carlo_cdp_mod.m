num_ensembles = 1;
%% How many particles from population?
%% Assume uniform size with variable concentration

time = 1;                                        % Time of simulation in s

saq = 0.24;                                      % Qualified Sample volume of CDP in mm^2
sae = 20.1;                                      % Extended sample volume of CDP in mm^2
Nliq = 20;                                       % Number concentration of liquid particles cm-3

tas = 100;                                         % Clock frequency of probe
int_arr_qualified = 1/((tas*100*saq*(1e-1)^2)*(Nliq));
int_arr_extended = 1/((tas*100*sae*(1e-1)^2)*(Nliq));
 
P_break = 0;                                       % Probability of breakup (assume 1%)


hists = zeros(num_ensembles,40);
for(i=1:num_ensembles)
    int_arr = [];
    time_since_last_natural_particle = 0;
    time_since_last_liquid_particle = 0;
    time_to_next_natural_particle = 1/poissrnd(1/int_arr_qualified);
    time_to_next_liquid_particle = 1/poissrnd(1/int_arr_extended);
    
    t = 0;
    while(t < time);
        % Handle population of shattered particles
        dt = min([time_to_next_natural_particle time_to_next_liquid_particle]);

        % Handle population of natural particles
        if(time_to_next_natural_particle <= time_since_last_natural_particle)
            int_arr = [int_arr; time_since_last_natural_particle];
            time_since_last_natural_particle = 0;
            time_to_next_natural_particle = -log(rand(1))*int_arr_qualified;
        end    
        time_since_last_natural_particle = time_since_last_natural_particle+dt; 

        
        % Handle population of natural particles
        if(time_to_next_liquid_particle <= time_since_last_liquid_particle)
            int_arr = [int_arr; time_since_last_liquid_particle];
            time_since_last_liquid_particle = 0;
            time_to_next_liquid_particle = -log(rand(1))*int_arr_extended;
            
        end    
        time_since_last_liquid_particle = time_since_last_liquid_particle+dt; 
        
        
        if(mod(t,dt*1000000) == 0)
            disp([num2str(t) '/' num2str(time)]);
        end
        t = t + dt;
    end
    
    n=int_arr > int_arr_qualified;
    nnz(n)/numel(int_arr)
    numel(int_arr)
    
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
% title(['TAS = ' num2str(tas) ' P_{break} = ' num2str(P_break*100) '% N_{liq} = ' num2str(Nliq) ' cm^{-3} mean fragments = ' num2str(num_fragments)]);
bimodalfit = @(tau, dt) tau(3).*(dt/tau(1)).*exp(-dt/tau(1))+(1-tau(3)).*(dt/tau(2)).*exp(-dt/tau(2));
hold on;



%% Plot interarrival time distribution
