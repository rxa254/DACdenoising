function signal = download_online_data(channel, T, fs)
    conn = nds2.connection('nds.ligo-la.caltech.edu', 31200);
    conn.iterate(channel);
    
    for i = 1:T
        
        bufs = conn.next();
        signal((i-1)*fs + 1 : i*fs) = bufs(1).getData();
    end
end