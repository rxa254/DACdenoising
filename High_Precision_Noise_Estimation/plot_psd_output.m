function plot_psd_output(signal,output_bqf,noise_bqf, channel, fs)
    % Remove mean
    LIMIT_SNR=100;
    signal = detrend(signal);
    %output_df2 = detrend(output_df2);
    output_bqf = detrend(output_bqf);
    %noise_df2 = detrend(noise_df2);
    noise_bqf = detrend(noise_bqf);
%     length(signal)
%     length(output_df2)
%     length(noise_df2)
    count=0;
    nfft = length(signal)/2;
    
    % Calculate psd
    [psd_input,f] = pwelch(signal, hanning(nfft), 3*nfft/4, nfft, fs);
    %[psd_output_df2,~] = pwelch(output_df2, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_output_bqf,~] = pwelch(output_bqf, hanning(nfft), 3*nfft/4, nfft, fs);
   % [psd_noise_df2,~] = pwelch(noise_df2, hanning(nfft), 3*nfft/4, nfft, fs);
    [psd_noise_bqf,~] = pwelch(noise_bqf, hanning(nfft), 3*nfft/4, nfft, fs);
    
    for i=1:length(psd_input)
        SNR(i)=psd_output_bqf(i)/psd_noise_bqf(i);
        limit_snr(i)=LIMIT_SNR;
        if SNR(i)<limit_snr(i)
            count=1;
        end
        if count>=1 && SNR(i)>limit_snr(i)
            count=count+1;
            
        end
    end
    if count==1, display('The SNR is below the limit atleast once');
    end
    if count==0, display('The filter is alright')
    end
    if count>1, display('Warning! SNR too low');
    end
   
%     length(SNR)
%     length(f)
%     R=snr(SNR,f,'psd')
    
%     length(SNR)
%check_digital_system_forsite(H1HPIHAM3,H1:HPI-HAM3_BLND_L4C_RY_IN1_DQ ,HAM3_BLND_L4C_RY)
%check_digital_system_forsite(H1HPIHAM6,H1:HPI-HAM6_STSINF_B_Z_IN1_DQ ,HAM6_STSINF_B_Z)
       
    disp('Plot the result...');
    scrsz = get(groot,'ScreenSize');
    figure('Position',[1 1 scrsz(3) scrsz(4)],'Visible','on','PaperPosition',[1 1 scrsz(3) scrsz(4)],'PaperPositionMode','manual');
    loglog(f, sqrt(psd_input), 'c', f, sqrt(psd_output_bqf), 'g--', ...
         f, sqrt(psd_noise_bqf),'m-.', 'LineWidth', 3);
    grid on;
    xlabel('frequency, Hz', 'FontSize', 16);
    ylabel('amplitude arb/sqrt(Hz)', 'FontSize', 16);
    hLegend=legend(strrep(channel, '_', '-'),'output bqf', 'noise bqf');
    set(hLegend,'FontSize', 12, 'Location', 'SouthOutside');
    set(gca, 'FontSize', 14);
    axis tight;
  
    saveas(gcf,channel,'svg');
    display('Now plotting SNR');
    
    plot_snr(SNR,channel,f,limit_snr);
%     orient portrait
%     set(gcf,'Position', [1 1  1500  1200]);
%     print(gcf, '-dpng',  [channel '.png']);
%     
%     close(gcf);
end
