% Compute parameters
init
% Load irradiance
load('gmonths.mat')
% Sensor activation durantion 
air_time = 30; 
methane_time = 30; 
temp_time = 6; 
mic_time = 12; 
transmit_time = 24; 
mc_time = 6;
% Period
period = 120;
% Pulse width: % of period when sensor is active
air_pulse = (air_time * 100)/period; 
methane_pulse = (methane_time * 100)/period; 
temp_pulse = (temp_time *100)/period; 
mic_pulse = (mic_time * 100)/period; 
mc_pulse = (mc_time*100)/period; 
transmit_pulse = (transmit_time * 100)/period; 
% Simulation length
sim_length = Gmonth(size(Gmonth, 1),1);

% Parallel execution
air_delay = 0; 
methane_delay = 0; 
temp_delay = 0; 
mic_delay = 0;
mc_delay = 30; 
transmit_delay = mc_delay + mc_time;
% Run simulation
sim('simulation.slx');
% Save results
save('parallel_wl.mat');

% Serial execution
air_delay = 0; 
methane_delay = air_time; 
temp_delay = methane_delay + methane_time; 
mic_delay = temp_delay + temp_time; 
mc_delay = mic_delay + mic_time; 
transmit_delay = mc_delay + mc_time;
% Run simulation
sim('simulation.slx');
% Save results
save('serial_wl.mat');

% Custom execution
air_delay = methane_time;
methane_delay = 0; 
temp_delay = 0;
mic_delay = methane_time;
mc_delay = air_delay + air_time; 
transmit_delay = mc_delay + mc_time;
% Run simulation
sim('simulation.slx');
% Save results
save('custom_wl.mat');

% Modified model

% 2 PV parallel
sim('simulation_2pv_parallel.slx');
% Save results
save('2pv_parallel.mat');

% 2 PV series
sim('simulation_2pv_series.slx');
% Save results
save('2pv_series.mat');

% 2 batteries series
sim('simulation_2batt.slx');
% Save results
save('batt_series.mat');

% 2 PV parallel + 2 batteries series
sim('simulation_2pv_2batt.slx');
% Save results
save('parallel_series.mat');

% 3 PV parallel
sim('simulation_3pv_parallel.slx');
% Save results
save('3pv_parallel.mat');

% Evaluate results
results

