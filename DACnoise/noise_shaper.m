function noise_shaper()
    close all;
%     load('saved_out_DARM_decreased.mat');
    
    % sampling rate
%     rate_Hz = 524.288e3; 
    rate_Hz = 16.384e3;
%     rate_Hz=length(save_out)/32;
%     rate_Hz=256;
%     
%     exponent=(numel(num2str(rate_Hz))-5);
%     const=10^-exponent;
    % signal duration in seconds
    gcl_s = 32;
    len=gcl_s*rate_Hz;
    fi=fopen('take_signal_shape.bin','rb');
    if fi==-1
        display('error reading file');
        return
    end
    [save_out,~]=fread(fi,len,'real*8');
    fclose(fi);
%     
    td=save_out';
%     td=resample(td,16384,rate_Hz);
%     rate_Hz=16384;
%     RBW_window=rate_Hz/2.5e3;
%     RBW_power=rate_Hz/2e1;
%     pRef_W=const*rate_Hz/4e6;
%     % *********************************************
%     % spectrum analyzer setup
% %     % *********************************************
%     SAparams = struct('RBW_window_Hz', RBW_window, ...
%                       'RBW_power_Hz', RBW_power, ...
%                       'pRef_W', pRef_W, ...
%                       'NMax', 5000, ...
%                       'filter', 'brickwall', ...
%                       'noisefloor_dB', -150);    
  
%     td(1:10)
%     length(td)
%     td(rate_Hz-1)=0;
%     td(rate_Hz)=0;
    % *********************************************
    % Generate random test signal
    % *********************************************
    % start with white noise
%     td = randn(1, floor(gcl_s * rate_Hz + 0.5));
         %+ 1i * randn(1, floor(gcl_s * rate_Hz + 0.5));
%     length(td)

%     if true
%         % filter to turn it into an oversampled narrow-band signal
%         fd = fft(td);
%         fb = freqbase(numel(fd)) * rate_Hz;
%         fd(abs(fb) > 2*10^(3+exponent)) = 0;
%         td = ifft(fd);
%     end

%     length(td)
%     if false
%         % use real-valued signal
%         td = real(td);
%     else
%         % keep complex-valued but scale
%         td = sqrt(1/2) * td;
%     end
%         
    % *********************************************
    % plot input signal spectrum
    % *********************************************
%     legFig1 = {};
%     legFig1{end+1} = 'input signal, unquantized';
%     td_spectrAnalyzer('signal', dowindow(td), 'gcl_s', gcl_s, SAparams, 'fig', 1, 'plotStyle', 'k');

    % *********************************************
    % Design a filter that reflects the shape of the desired 
    % noise spectrum
    % *********************************************    
  
    %%%%%%%%%%%% bandstop filter. Removes quantization noise from a bandwidth of
    % rate/4 to rate/3.
    %Order =3 ; 3dB ripple in passband
%     band_stop=(rate_Hz/120);
%     band_pass=(rate_Hz/100);
%     [b, a] = cheby1(3, 3, [band_stop/(rate_Hz/10), band_pass/(rate_Hz/10)], 'stop');
%     display(strcat('stop band is between ',num2str(band_stop/rate_Hz),' Hz and ',num2str(band_pass/rate_Hz),' Hz'));

    %%%%%%%%%%%%%%%%%%%%high pass filter%%%%%%%%%%%%%%%%%%%%
    factor=0.8;
    pass_freq=factor*(rate_Hz/2);
%     Hd = designfilt('highpassiir', 'FilterOrder', 4, ...
%              'PassbandFrequency', 5e3, 'PassbandRipple', 3,...
%              'SampleRate', rate_Hz);
%     [b,a]=tf(Hd);

%     display(strcat('Cutoff frequency is ',num2str(pass_freq),' Hz'));
    
    %Filter Design High Pass IIR%
    hpFilt = designfilt('highpassiir', 'FilterOrder', 4, ...
             'PassbandFrequency', pass_freq, 'PassbandRipple', 3,...
             'SampleRate', rate_Hz);
    sos=hpFilt.Coefficients;
    
    [b,a]=sos2tf(sos);
%     H1=tf(b,a,-1,'Variable','z^-1');
    
%     


    % *********************************************
    % plot the above filter response (impulse response
    % from quantizer error to output)
    % *********************************************    
%     pulse = zeros(1, 100);
%     pulse(1) = 1;
%     pulse = filter(b, a, pulse);
%     figure(33);
%     stem(pulse);
%     title('h_{Target}');
%     
    % *********************************************
    % plot the filter response
    % *********************************************    
%     fNorm_Hz = linspace(0, 1, 10000);
%     fPlot_Hz = rate_Hz * fNorm_Hz;
%     zInv = exp(-2i * pi * fNorm_Hz); 
%     H = polyval(b, zInv) ./ polyval(a, zInv);
    
%     figure(2);
%     freqz(b,a);
%     xlabel('f / Hz (Norm)');
%     ylabel('dB');
%     grid on;
%     title('desired noise shaper frequency response H_{Target}');

    % *********************************************
    % Derive the noise shaper filter from the desired
    % noise frequency response
    % Note: a unit delay is removed by shortening bb.
    % *********************************************    
    bb = b / b(1);
    bb = bb(2:end) - a(2:end);
    sos_s=tf2sos(bb,a);
    [gain,sos_shape]=sos_shuffle(sos_s);

%     Hz=tf([0 1],[1],-1,'Variable','z^-1');
%     Hz1=tf([1 0],[1],-1);
%     H_filter=(H1+1)*Hz1;
%     
%     [bb,aa]=tfdata(H_filter,'v');
% %     aa(1)=0.6;
    
%       
%     figure(5);
%     freqz(bb,a);
%     xlabel('f / Hz (Norm)');
%     ylabel('dB');
%     grid on;
%     title('desired noise shaper frequency response H_{Target}*(z^-1)');
%     Hd = dfilt.df2t(bb,a);
%     sos2=tf2sos(bb,a);
    % *********************************************
    % Simulate
    % *********************************************    
    % Signal padding: 
    % replicate the end of the (cyclic!) signal to give the filter
    % time to settle. This part of the result will be discarded.
%     nPad=10^((numel(num2str(length(td)))-2));
% %     nPad=1000;
%     td = [td(end-nPad+1:end) td];

    tdOut1 = zeros(size(td));
    tdOut2 = zeros(size(td));
    
    % "filterState" preserves the delay line content between 
    % invocations to "filter"
    filterState = [];
    
    % quantErr is the quantization error of the -previous- sample
    % (because a unit delay was removed from the filter)
    quantErr = 0;
%     n=numel(bb)
%     l=length(a)
%     SOS=tf2sos(bb,a);

    for ix = 1 : len;
        s = td(ix);
        
        % variant 1: ordinary quantization
        tdOut1(ix) = quant(s);

        % variant 2: quantization with noise shaping
%         if(filterState ~= 0), f_in=filterState
%         end
        
        [filterOut, filterState] = filter(bb,a, quantErr, filterState);
%             filterOut=sosfilt(SOS,quantErr);
%         if(filterState ~=0), f=filterState
%         end
        quantIn = s + filterOut;
%         quantIn = s + quantErr;
        quantOut = double(quant(quantIn));
%         quantErr = quantOut - quantIn;
        quantErr = quantOut - quantIn;
        tdOut2(ix) = quantOut;
    end
    

   
    
%     length(filterState)
    % remove signal padding
%     td = td(nPad+1:end);
%     tdOut1 = tdOut1(nPad+1:end);
%     tdOut2 = tdOut2(nPad+1:end);
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
    
    %%Read Higher precision C Code output%%
    fid=fopen('shaped_out_long.txt','r');
    if fid==-1
        display('error opening file')
    end
    tdOut2Cl=fscanf(fid,'%d',len);
    tdOut2Cl=tdOut2Cl';
    fclose(fid);
% %     
%     
%         %****PLOT DATA******%
% %    %%%% When comparing C And MATLAB %%%%
%        figure(4);
%     plot(tdOut2-tdOut2C);
%     grid on;
%     title('tdOut2-tdOut2C');
%       figure(44);
%     plot(tdOut2-tdOut2Cl);
%     grid on;
%     title('tdOut2-tdOut2Cl');
% 
%       figure(46);
%     plot(tdOut2C-tdOut2Cl);
%     grid on;
%     title('diff between the two C codes');
    
%     diff=tdOut2(1000:2000)-tdOut2C(1000:2000);
    
    %Measurement of Relative Error in this filtering code%
    e_matlab=abs(tdOut2-tdOut2Cl)/abs(tdOut2Cl);
    e_c=abs(tdOut2C-tdOut2Cl)/abs(tdOut2Cl);
    e_matlab0=abs(tdOut2(:,1)-tdOut2Cl(:,1))/abs(tdOut2Cl(:,1));
    e_c0=abs(tdOut2C(:,1)-tdOut2Cl(:,1))/abs(tdOut2Cl(:,1));
    const_matlab=e_matlab/e_matlab0;
    const_c=e_c/e_c0;
    e_matlab0
    e_c0
    
    figure(9);
    plot(const_matlab);
    grid on;
    title('const_matlab');
    
    figure(10);
    plot(const_c);
    grid on;
    title('const_c');
    

   plot_shape(td-tdOut2,td-tdOut2C,td-tdOut2Cl,td,td,rate_Hz);
   
   %%%%%%%%%%%%%%%
   
   %%%%Plotting MATLAB Output ONLY %%%%%%%%%
%    plot_shape(td,tdOut1,tdOut2,td-tdOut1,td-tdOut2,rate_Hz);
   
%     tdOut2(1:10)
    % *********************************************
    % Plot quantization noise ("-td" subtracts the ideal
    % output and leaves only the error)
%     % *********************************************    
%     td_spectrAnalyzer('signal', dowindow(tdOut1 - td), 'gcl_s', gcl_s, SAparams, 'fig', 1, 'plotStyle', 'r');
%     legFig1{end+1} = 'quantizer output error (no noise shaping)';

%     td_spectrAnalyzer('signal', dowindow(tdOut2-td), 'gcl_s', gcl_s, SAparams, 'fig', 1, 'plotStyle', 'm');
%     legFig1{end+1} = 'quantizer output error (noise shaping)';
% 
%     xlabel('f / Hz');
%     ylabel('dB');
%     title('noise shaping');    
%     grid on;
% %     legend(legFig1);
% 
%     figure(); hold on;
%     plot(real(td), 'k');
%     plot(real(tdOut2), 'b');
    
    
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

%function sOut = quant(s)
%    sOut = 0.1 * (-1 + 2 * (s > 0));
%end

% *********************************************
% frequency corresponding to each FFT bin
% % *********************************************
% function fb = freqbase(n)
%     fb = 0:(n - 1);
%     fb = fb + floor(n / 2);
%     fb = mod(fb, n);
%     fb = fb - floor(n / 2);
%     
%     fb = fb / n; % now [0..0.5[, [-0.5..0[
% end
% 
% % *********************************************
% The wanted signal is periodic, but noise shaping does
% not preserve the periodicity because of the noise shaper's
% inherent small oscillations.
% The error is localized to the first and last sample
% Therefore, apply some gentle windowing to head
% and tail of the signal.
% % *********************************************
% function seq = dowindow(seq)
% %     size(seq)
%     nWin=10^((numel(num2str(length(seq)))-2));
% %     nWin=1000;
%     win = linspace(0, 1, nWin+1);
% %     size(win)
%     win = win(2:end);
% %     size(win)
%     win = (1-cos(pi*win))/2;
% %     size(win)
%     seq(1:nWin) = seq(1:nWin) .* win;
%     seq(end-nWin+1:end) = seq(end-nWin+1:end) .* fliplr(win);   
% end