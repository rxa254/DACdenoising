function plot_psd(signal, output_df2, output_bqf, noise_df2, noise_bqf, channel, fs)
    % Remove mean
    signal = detrend(signal);
    output_df2 = detrend(output_df2);
    output_bqf = detrend(output_bqf);
    noise_df2 = detrend(noise_df2);
    noise_bqf = detrend(noise_bqf);
    length(signal)
    nfft = length(signal)/2
    length(output_df2)
    % Calculate psd
    [psd_input,f] = pwelch(signal, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_output_df2,~] = pwelch(output_df2, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_output_bqf,~] = pwelch(output_bqf, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_noise_df2,~] = pwelch(noise_df2, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_noise_bqf,~] = pwelch(noise_bqf, hanning(nfft), 3*nfft/4, nfft, fs);
      
    disp('Plot the result...');
    figure('Position', [1 1 1200 800],'Visible','on');
    loglog(f, sqrt(psd_input), 'c', f, sqrt(psd_output_df2), 'b--', f, sqrt(psd_output_bqf), 'g--', ...
        f, sqrt(psd_noise_df2), 'r-.', f, sqrt(psd_noise_bqf), 'm-.', 'LineWidth', 3);
    grid on;
    xlabel('frequency, Hz', 'FontSize', 16);
    ylabel('amplitude arb/sqrt(Hz)', 'FontSize', 16);
    hLegend=legend(strrep(channel, '_', '-'), 'output df2', 'output bqf', 'noise df2', 'noise bqf');
    set(hLegend,'FontSize', 14, 'Location', 'SouthWest');
    set(gca, 'FontSize', 16);
    axis tight;
    saveas(gcf,'PSD_Plot','jpg');
%     orient portrait
%     set(gcf,'Position', [1 1  1500  1200]);
%     print(gcf, '-dpng',  [channel '.png']);
%     
%     close(gcf);
end
