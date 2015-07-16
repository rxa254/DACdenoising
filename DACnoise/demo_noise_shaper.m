function demo_noise_shaper()
    close all;
    
    % signal duration in seconds
    gcl_s = 1e-3; 

    % sampling rate
    rate_Hz = 76.8e6; 
    0.001 * rate_Hz / 4e6
    % *********************************************
    % spectrum analyzer setup
    % *********************************************
    SAparams = struct('RBW_window_Hz', 30e3, ...
                      'RBW_power_Hz', 3.84e6, ...
                      'pRef_W', 0.001 * rate_Hz / 4e6, ...
                      'NMax', 5000, ...
                      'filter', 'brickwall', ...
                      'noisefloor_dB', -150);    
        
    % *********************************************
    % Generate random test signal
    % *********************************************
    % start with white noise
    td = randn(1, floor(gcl_s * rate_Hz + 0.5))...
         + 1i * randn(1, floor(gcl_s * rate_Hz + 0.5));

    if true
        % filter to turn it into an oversampled narrow-band signal
        fd = fft(td);
        fb = freqbase(numel(fd)) * rate_Hz;
        fd(abs(fb) > 2e6) = 0;
        td = ifft(fd);
    end
    
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
    if false
        % highpass filter. Moves quantization noise out of the
        % wanted signal bandwidth
        % [b, a] = cheby1(3, 3, [5e6/(rate_Hz/2)], 'stop');
        b = [5.24490673e-001 -1.57347202e+000 1.57347202e+000 -5.24490673e-001];
        a = [1.00000000e+000 -1.86668830e+000 1.17268490e+000 -1.56552175e-001];
    else
        % bandstop filter. Removes quantization noise from a bandwidth of
        % 29 to 34 MHz.
        % [b, a] = cheby1(3, 3, [29e6/(rate_Hz/2), 34e6/(rate_Hz/2)], 'stop');
        b = [5.24490673e-001 2.71530360e+000 6.25920749e+000 8.12596164e+000 6.25920749e+000 2.71530360e+000 5.24490673e-001];
        a = [1.00000000e+000 4.19916469e+000 7.75267045e+000 7.94032920e+000 4.65817369e+000 1.41707496e+000 1.56552175e-001];
    end

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
    fNorm_Hz = linspace(-0.5, 0.5, 10000);
    fPlot_Hz = rate_Hz * fNorm_Hz;
    zInv = exp(-2i * pi * fNorm_Hz); 
    H = polyval(b, zInv) ./ polyval(a, zInv);
    
    figure(2);
    plot(fPlot_Hz / 1e6, 20*log10(abs(H) + eps));
    xlabel('f / MHz');
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
        
    % *********************************************
    % Simulate
    % *********************************************    
    % Signal padding: 
    % replicate the end of the (cyclic!) signal to give the filter
    % time to settle. This part of the result will be discarded.
    nPad = 1000;
    td = [td(end-nPad+1:end) td];

    tdOut1 = zeros(size(td));
    tdOut2 = zeros(size(td));
    
    % "filterState" preserves the delay line content between 
    % invocations to "filter"
    filterState = [];
    
    % quantErr is the quantization error of the -previous- sample
    % (because a unit delay was removed from the filter)
    quantErr = 0;
    for ix = 1 : numel(td);
        s = td(ix);
        
        % variant 1: ordinary quantization
        tdOut1(ix) = quant(s);

        % variant 2: quantization with noise shaping
        [filterOut, filterState] = filter(bb, a, quantErr, filterState);
        quantIn = s + filterOut;
        quantOut = quant(quantIn);
        quantErr = quantOut - quantIn;
        tdOut2(ix) = quantOut;
    end
    
    % remove signal padding
    td = td(nPad+1:end);
    tdOut1 = tdOut1(nPad+1:end);
    tdOut2 = tdOut2(nPad+1:end);

    % *********************************************
    % Plot quantization noise ("-td" subtracts the ideal
    % output and leaves only the error)
    % *********************************************    
    td_spectrAnalyzer('signal', dowindow(tdOut1 - td), 'gcl_s', gcl_s, SAparams, 'fig', 1, 'plotStyle', 'r');
    legFig1{end+1} = 'quantizer output error (no noise shaping)';

    td_spectrAnalyzer('signal', dowindow(tdOut2 - td), 'gcl_s', gcl_s, SAparams, 'fig', 1, 'plotStyle', 'm');
    legFig1{end+1} = 'quantizer output error (noise shaping)';

    xlabel('f / MHz');
    ylabel('dB (30 kHz RBW filter)');
    title('noise shaping');    
    grid on;
    legend(legFig1);

    figure(); hold on;
    plot(real(td), 'k');
    plot(real(tdOut2), 'b');
end

% *********************************************
% quantizer model: 
% infinite stairstep, no clipping
% *********************************************
function sOut = quant(s)
    qf = 10;
    sOut = 1/qf * floor(qf * s + 0.5 + 0.5i);
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
    nWin = 1000;
    win = linspace(0, 1, nWin+1);
    win = win(2:end);
    win = (1-cos(pi*win))/2;
    seq(1:nWin) = seq(1:nWin) .* win;
    seq(end-nWin+1:end) = seq(end-nWin+1:end) .* fliplr(win);   
end