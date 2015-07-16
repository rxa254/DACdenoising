%Create your own input signal
 in=randn(1,floor(1e-3*16384+0.5))+1i*randn(1,floor(1e-3*16384+0.5));
 
 %Create your own filter to get an output
 
 Hd=lpf8test;
 
 out=filter(Hd,in);
 