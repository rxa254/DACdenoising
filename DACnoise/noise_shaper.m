function noise_shaper()
    close all;
%     load('saved_out_DARM.mat');
    
    % sampling rate
%     rate_Hz = 524.288e3; 
%     rate_Hz = 16.384e3;
%     rate_Hz=length(save_out)/32;
    rate_Hz=256;
    
    exponent=(numel(num2str(rate_Hz))-5);
    const=10^-exponent;
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
  
    RBW_window=rate_Hz/2.5e3;
    RBW_power=rate_Hz/2e1;
    pRef_W=const*rate_Hz/4e6;
    % *********************************************
    % spectrum analyzer setup
%     % *********************************************
    SAparams = struct('RBW_window_Hz', RBW_window, ...
                      'RBW_power_Hz', RBW_power, ...
                      'pRef_W', pRef_W, ...
                      'NMax', 5000, ...
                      'filter', 'brickwall', ...
                      'noisefloor_dB', -150);    
    td=save_out';
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
    if true
        % filter to turn it into an oversampled narrow-band signal
        fd = fft(td);
        fb = freqbase(numel(fd)) * rate_Hz;
        fd(abs(fb) > 2*10^(3+exponent)) = 0;
        td = ifft(fd);
    end
%     length(td)
    if false
        % use real-valued signal
        td = real(td);
    else
        % keep complex-valued but scale
        td = sqrt(1/2) * td;
    end
        
    % *********************************************
    % plot input signal spectrum
    % *********************************************
    legFig1 = {};
    legFig1{end+1} = 'input signal, unquantized';
    td_spectrAnalyzer('signal', dowindow(td), 'gcl_s', gcl_s, SAparams, 'fig', 1, 'plotStyle', 'k');

    % *********************************************
    % Design a filter that reflects the shape of the desired 
    % noise spectrum
    % *********************************************    
  
    % bandstop filter. Removes quantization noise from a bandwidth of
    % rate/4 to rate/3.
    %Order =3 ; 3dB ripple in passband
%     band_stop=(rate_Hz/120);
%     band_pass=(rate_Hz/100);
%     [b, a] = cheby1(3, 3, [band_stop/(rate_Hz/10), band_pass/(rate_Hz/10)], 'stop');
%     display(strcat('stop band is between ',num2str(band_stop/rate_Hz),' Hz and ',num2str(band_pass/rate_Hz),' Hz'));
%     b=1;
%     a=1;
    %high pass filter
    pass_freq=100;
%     Hd = designfilt('highpassiir', 'FilterOrder', 4, ...
%              'PassbandFrequency', 5e3, 'PassbandRipple', 3,...
%              'SampleRate', rate_Hz);
%     [b,a]=tf(Hd);
    [b, a] = cheby1(4, 3, pass_freq/(rate_Hz/2), 'high');
    display(strcat('Cutoff frequency is ',num2str(pass_freq),' Hz'));
    
   
    

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
%     fNorm_Hz = linspace(0, 1, 10000);
%     fPlot_Hz = rate_Hz * fNorm_Hz;
%     zInv = exp(-2i * pi * fNorm_Hz); 
%     H = polyval(b, zInv) ./ polyval(a, zInv);
    
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
%     Hd = dfilt.df2t(bb,a);
%     sos2=tf2sos(bb,a);
    % *********************************************
    % Simulate
    % *********************************************    
    % Signal padding: 
    % replicate the end of the (cyclic!) signal to give the filter
    % time to settle. This part of the result will be discarded.
    nPad=10^((numel(num2str(length(td)))-2));
%     nPad=1000;
    td = [td(end-nPad+1:end) td];

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

    for ix = 1 : numel(td);
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
        quantOut = quant(quantIn);
        quantErr = quantOut - quantIn;
        tdOut2(ix) = quantOut;
    end
    
%     length(filterState)
    % remove signal padding
    td = td(nPad+1:end);
    tdOut1 = tdOut1(nPad+1:end);
    tdOut2 = tdOut2(nPad+1:end);
    fid=fopen('shaped_out.txt','r');
    if fid==-1
        display('error opening file')
    end
    tdOut2=fscanf(fid,'%d',len);
    tdOut2=tdOut2';
    
    % *********************************************
    % Plot quantization noise ("-td" subtracts the ideal
    % output and leaves only the error)
    % *********************************************    
    td_spectrAnalyzer('signal', dowindow(tdOut1 - td), 'gcl_s', gcl_s, SAparams, 'fig', 1, 'plotStyle', 'r');
    legFig1{end+1} = 'quantizer output error (no noise shaping)';

    td_spectrAnalyzer('signal', dowindow(tdOut2 - td), 'gcl_s', gcl_s, SAparams, 'fig', 1, 'plotStyle', 'm');
    legFig1{end+1} = 'quantizer output error (noise shaping)';

    xlabel('f / Hz');
    ylabel('dB');
    title('noise shaping');    
    grid on;
    legend(legFig1);

    figure(); hold on;
    plot(real(td), 'k');
    plot(real(tdOut2), 'b');
    
    fi=fopen('match_data.txt','w');
    fprintf(fi,'%d\n',tdOut1);
    fclose(fi);
end

% *********************************************
% quantizer model: 
% infinite stairstep, no clipping
% *********************************************
function sOut = quant(s)
   
    if s>=2^(17)-1
        sOut=round(2^(17)-1);
    elseif s<=-2^(17)
        sOut=round(-2^(17));
    else
        sOut=round(s);
    end
end

%function sOut = quant(s)
%    sOut = 0.1 * (-1 + 2 * (s > 0));
%end

% *********************************************
% frequency corresponding to each FFT bin
% *********************************************
function fb = freqbase(n)
    fb = 0:(n - 1);
    fb = fb + floor(n / 2);
    fb = mod(fb, n);
    fb = fb - floor(n / 2);
    
    fb = fb / n; % now [0..0.5[, [-0.5..0[
end

% *********************************************
% The wanted signal is periodic, but noise shaping does
% not preserve the periodicity because of the noise shaper's
% inherent small oscillations.
% The error is localized to the first and last sample
% Therefore, apply some gentle windowing to head
% and tail of the signal.
% *********************************************
function seq = dowindow(seq)
%     size(seq)
    nWin=10^((numel(num2str(length(seq)))-2));
%     nWin=1000;
    win = linspace(0, 1, nWin+1);
%     size(win)
    win = win(2:end);
%     size(win)
    win = (1-cos(pi*win))/2;
%     size(win)
    seq(1:nWin) = seq(1:nWin) .* win;
    seq(end-nWin+1:end) = seq(end-nWin+1:end) .* fliplr(win);   
end