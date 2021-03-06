function [signal,fs] = download_online_data_forsiteL(channel, T, fs)
    time=1117562416;
    
    conn = nds2.connection('nds.ligo-la.caltech.edu', 31200);
    bufs=conn.fetch(time,time+T,channel);
    bufs=bufs(1).getData();
    fs=length(bufs)/T;
    for i = 1:T
        
       % bufs = conn.next();
        
        signal((i-1)*fs + 1 : i*fs) =bufs((i-1)*fs + 1 : i*fs);
    end
end