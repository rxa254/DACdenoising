function plot_snr(snr,channel,f,limit_snr)

%plots snr for the filter being checked
    scrsz = get(groot,'ScreenSize');
    
    figure('Position',[1 1 scrsz(3) scrsz(4)],'Visible','on','PaperPosition',[1 1 scrsz(3) scrsz(4)],'PaperPositionMode','manual');
    
    loglog(f,snr,'b',f,limit_snr,'r')
    grid on;
    xlabel('index', 'FontSize', 16);
    ylabel('SNR', 'FontSize', 16);
    hLegend=legend('snr');
    set(hLegend,'FontSize', 12, 'Location', 'SouthOutside');
    set(gca, 'FontSize', 14);
    axis tight;
  
    saveas(gcf,strcat(channel,'_SNR'),'svg');
end