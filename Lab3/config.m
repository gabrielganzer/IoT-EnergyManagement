load('gmonths.mat')

% sensor activation durantion 
air_time = 30; 
methane_time = 30; 
temp_time = 6; 
mic_time = 12; 
transmit_time = 24; 
mc_time = 6; 

% activation delay
% parallel exec
air_delay = 0; 
methane_delay = 0; 
temp_delay = 0; 
mic_delay = 0;
mc_delay = 30; 
transmit_delay = mc_delay + mc_time;

% period
% setting 1: 120 (2 minutes)
% setting 2: 60*10 (10 minutes)
period = 120; 

% pulse width: % of period when sensor is active
air_pulse = (air_time * 100)/period; 
methane_pulse = (methane_time * 100)/period; 
temp_pulse = (temp_time *100)/period; 
mic_pulse = (mic_time * 100)/period; 
mc_pulse = (mc_time*100)/period; 
transmit_pulse = (transmit_time * 100)/period; 

% simulation length
sim_length = Gmonth(size(Gmonth, 1),1);


