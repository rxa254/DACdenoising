function signal = download_online_data(channel, T, fs)
    conn = nds2.connection('l1nds0', 8088);
    conn.iterate(channel);
    
    for i = 1:T
        i
        bufs = conn.next();
        signal((i-1)*fs + 1 : i*fs) = bufs(1).getData();
	signal=mp(signal,100);
    end
end
