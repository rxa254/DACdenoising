function signal = download_past_data(channel, sc)
    
    host = 'fb:8088';
    
    [~, gps_now] = system('tconvert now');  % GPS time now
    gps_now = str2double(gps_now);
    t_margin = 32;                   % End time is 32 sec before now
    
    dt = 100;               % signal duration
    t_start = gps_now - dt - t_margin;      % time to start
    signal = NDS_GetData(channel, t_start, dt, host, sc);
end