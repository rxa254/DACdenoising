function plot_shape(signal, output_1, output_2, noise_1, noise_2, fs)
    % Remove mean
  
    signal = detrend(signal);
    output_1 = detrend(output_1);
    output_2 = detrend(output_2);
    noise_1 = detrend(noise_1);
    noise_2 = detrend(noise_2);
%     length(signal)
%     length(output_df2)
%     length(noise_df2)

    nfft = length(signal)/2;
    
    % Calculate psd
    [psd_input,f] = pwelch(signal, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_output_1,~] = pwelch(output_1, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_output_2,~] = pwelch(output_2, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_noise_1,~] = pwelch(noise_1, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_noise_2,~] = pwelch(noise_2, hanning(nfft), 3*nfft/4, nfft, fs);
    
    name=char(abs(randn*100));
    disp('Plot the result...');
    scrsz = get(groot,'ScreenSize');
    figure('Position',[1 1 scrsz(3) scrsz(4)],'Visible','on','PaperPosition',[1 1 scrsz(3) scrsz(4)],'PaperPositionMode','manual');
    loglog(f, sqrt(psd_input), 'c',f, sqrt(psd_output_1), 'b--',f, sqrt(psd_output_2), 'g--',  ...
         f, sqrt(psd_noise_1),'r-.',f, sqrt(psd_noise_2),'m-.', 'LineWidth', 3);
%      loglog(f, sqrt(psd_input), 'c',f, sqrt(psd_output_1), 'b--',f, sqrt(psd_output_2), 'g--',  ...
%          'LineWidth', 3);
    grid on;
    xlabel('frequency, Hz', 'FontSize', 24);
    ylabel('amplitude arb/sqrt(Hz)', 'FontSize', 24);
    %%%%%%%%%When Comparing C and MATLAB %%%%%%%
    
%     hLegend=legend('Pre-processing Output', 'Noise without shaping', 'noise with shaping matlab', 'noise with shaping C', 'difference in C and MATLAB');
    
    %%%%%%%%%%%%%
    
    %%%%%Plotting MATLAB Only%%%%%%%%%%%%%
    hLegend=legend('Pre-processing Output', 'Output without shaping', 'output with shaping', 'noise without shaping', 'noise with shaping');
    set(hLegend,'FontSize', 16, 'Location', 'SouthOutside');
    set(gca, 'FontSize', 18);
    axis tight;
    saveas(gcf,'Diff_C_MATLAB','svg');

end