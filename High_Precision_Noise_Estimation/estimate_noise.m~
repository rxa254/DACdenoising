function [output_df2, output_bqf, noise_df2, noise_bqf] = estimate_noise(signal, iir)

    n_iir = length(iir);
    
    
    % Calculate Biquad filter coefficients
    for i=1:n_iir
        iir(i).sos_bqf = zeros(size(iir(i).sos));
        iir(i).sos_bqf(:,1) = -iir(i).sos(:,1) - 1;
        iir(i).sos_bqf(:,2) = -iir(i).sos(:,1) - iir(i).sos(:,2) - 1;
        iir(i).sos_bqf(:,3) = iir(i).sos(:,3) - iir(i).sos(:,1);
        iir(i).sos_bqf(:,4) = iir(i).sos(:,4) - iir(i).sos(:,2) + iir(i).sos(:,3) - iir(i).sos(:,1);
    end
    
    output_df2_single = signal;
    output_df2 = signal;
    output_bqf_single = signal;
    output_bqf = signal;

    % Calculate output from the filter bank using df2 and bqf
    for i=1:n_iir
        output_df2_single = calculate_noise(mp(output_df2_single), iir(i).sos, iir(i).g, 0);
        output_df2 = calculate_noise(double(output_df2), iir(i).sos, iir(i).g, 1);
        output_bqf_single = calculate_noise(mp(output_bqf_single), iir(i).sos_bqf, iir(i).g, 2);
        output_bqf = calculate_noise(double(output_bqf), iir(i).sos_bqf, iir(i).g, 3);
    end
       
    % Calculate filter noise
    mp(noise_df2,100) = (output_df2_single - output_df2);
    mp(noise_bqf,100) = (output_bqf_single - output_bqf);
end
