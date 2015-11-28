function noise_shaper2()
    close all;
    rate_Hz = 16.384e3;
    gcl_s = 32;
    len=gcl_s*rate_Hz;
    fi=fopen('take_signal_shape.bin','rb');
    if fi==-1
        display('error reading file');
        return
    end
    [save_out,~]=fread(fi,len,'real*8');
    fclose(fi);   
    td=save_out';

    %%%%%%%%%%%% bandstop filter. Removes quantization noise from a bandwidth of
    % rate/4 to rate/3.%%%%%%%%%%%%%%%
    %Order =3 ; 3dB ripple in passband
%     band_stop=(rate_Hz/120);
%     band_pass=(rate_Hz/100);
%     [b, a] = cheby1(3, 3, [band_stop/(rate_Hz/10), band_pass/(rate_Hz/10)], 'stop');


    %%%%%%%%%%%%%%%%%%%%high pass filter%%%%%%%%%%%%%%%%%%%%
    factor=0.8;
    pass_freq=factor*(rate_Hz/2);

    
    %Filter Design High Pass IIR%
    hpFilt = designfilt('highpassiir', 'FilterOrder', 4, ...
             'PassbandFrequency', pass_freq, 'PassbandRipple', 3,...
             'SampleRate', rate_Hz);
    sos=hpFilt.Coefficients;
    
    [b,a]=sos2tf(sos);

    % *********************************************
    % plot the above filter response (impulse response
    % from quantizer error to output)
    % *********************************************    
    pulse = zeros(1, 100);
    pulse(1) = 1;
    pulse = filter(b, a, pulse);
    figure(33);
    stem(pulse);
    title('h_{Target}');
    
    % *********************************************
    % plot the filter response
    % *********************************************    

    
    figure(2);
    freqz(b,a);
    xlabel('f / Hz (Norm)');
    ylabel('dB');
    grid on;
    title('desired noise shaper frequency response H_{Target}');

    % *********************************************
    % Derive the noise shaper filter from the desired
    % noise frequency response
    % Note: a unit delay is removed by shortening bb.
    % *********************************************    
    bb = b / b(1);
    bb = bb(2:end) - a(2:end);
    sos_s=tf2sos(bb,a);
    [gain,sos_shape]=sos_shuffle(sos_s)
   
    order=length(sos_shape)/4
    for i=1:4*order
        sos_new(i+1)=sos_shape(i);
    end
    sos_new(1)=gain;
    sos2=sos_new'
    
   
    % *********************************************
    % Simulate
    % *********************************************    
    tdOut1 = zeros(size(td));
    tdOut2 = zeros(size(td));
    
    % "filterState" preserves the delay line content between invocations to
    % filter
    for i=1:len
        quantErr(i)=0;
    end
    for i=1:2*order
        filterState(i)=0;
    end
    % quantErr is the quantization error of the -previous- sample
    % (because a unit delay was removed from the filter)

    
    for ix = 1 : len;
        s = td(ix);
        
        % variant 1: ordinary quantization
        tdOut1(ix) = quant(s);

        % variant 2: quantization with noise shaping
        if ix==1
            filterOut(ix)= calculate_noise_shaper_mex(0,sos2',order,filterState); 
        else
            filterOut(ix)= calculate_noise_shaper_mex(quantErr(ix-1),sos2',order,filterState); 
            quantIn(ix) = s + filterOut(ix);
            quantOut(ix) = double(quant(quantIn(ix)));
            quantErr(ix) = quantOut(ix) - quantIn(ix);
            tdOut2(ix) = quantOut(ix);
        end
    end
    

    %write the output to file to match with C code%%
    fi=fopen('match_data.txt','w');
    fprintf(fi,'%d\n',tdOut2);
    fclose(fi);

%%%% Read C code output , should be commented when MATLAB code is being tested%%%
    fid=fopen('shaped_out.txt','r');
    if fid==-1
        display('error opening file')
    end
    tdOut2C=fscanf(fid,'%d',len);
    tdOut2C=tdOut2C';
    fclose(fid);
% %     
%     
        %****PLOT DATA******%
   %%%% When comparing C And MATLAB %%%%
       figure(4);
    plot(tdOut2);
    grid on;
    title('tdOut2');
      figure(44);
    plot(tdOut2C);
    grid on;
    title('tdOut2C');
   
    figure(5);
    plot(tdOut2-tdOut2C);
    grid on;
    title('diff C MATLAB in series values');
    

   plot_shape(td,td-tdOut1,td-tdOut2,td-tdOut2C,tdOut2-tdOut2C,rate_Hz);
   
   %%%%%%%%%%%%%%%
   
   %%%%Plotting MATLAB Output ONLY %%%%%%%%%
%    plot_shape(td,tdOut1,tdOut2,td-tdOut1,td-tdOut2,rate_Hz);
    
end

% *********************************************
% quantizer model: 
% 18 bit integer round off with clipping
% *********************************************
function sOut = quant(s)
%     sOut=roundfloat(s,18);
    if s>=2^(17)-1
        display('clipping1');
        sOut=int32(2^(17)-1);
    elseif s<=-2^(17)
        sOut=int32(-2^(17));
        display('clipping');
    else
       sOut=int32(s);
    end
end

