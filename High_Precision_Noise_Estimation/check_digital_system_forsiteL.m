function check_digital_system_forsiteL(name, channel, filter_bank)
    % Function checks noise of the digital filter modules
    % given the list of models
    format longEng;
    
    % Get site parameters: IFO, ifo, site, chans directory, 
    % uapps directory, host name
    params = config_editedforsiteL(); %change when change the site
    
    % Add Java classes for SWIG
    % nds2AddJava;
    
    % Fields of each model are
    %   -name
    %   -foton_file (.txt)
    %   -model file (.mdl)
    %   -modules (with filters from Foton file)
    %   -fs (sampling frequency of the model)
    %   -subsystems (if they are tagget "top_names")
    %   -channels (all _IN1 channels inside the model)
    %   -module_parameters (ezcaread from online system)

    % Foton file of the model
    
    foton_file = [params.chans params.IFO upper(name) '.txt'];

    % Read filter modules and sampling frequency from Foton file
    [modules, fs] = read_model_foton_file(foton_file);
    
    % Online parameters of the fitler module
    module_parameters = read_module_params_forsiteL(channel); %change when change the time and also for site
    
    %modules(filter_bank);
    % Filters that are switched on
    online_filters = find_online_filters(modules(filter_bank), module_parameters);
%     for i=1:length(online_filters)
%         online_filters(i)
%     end
    

    % Download data from the channel
    clear data
    T = 1;
    %freq=fs
    [data,fs] = download_online_data_forsiteL({channel}, T, fs); %change when change the time and for site
%     data(1:10)
    %fs
    pause(2)
%     T*fs
%     length(data)
    
    if length(data) ~= T*fs || isempty(online_filters) || data(end) == 0
        disp('Fiter Module Switched Off');
        
    else if length(data) == T*fs && ~isempty(online_filters) && data(end) ~= 0
    %if length(data) == T*fs && ~isempty(online_filters) ~= 0
        disp('Filter is On, Downloading data...');
        clear data
        T = 32;

        [data,fs] = download_online_data_forsiteL({channel}, T, fs);%change when change the time and for site
        data(1:10)
        disp('Got CHANNEL');
        
        
        
        % Subtract offset if it is ON
        if module_parameters.OFFSET_SW
            data = data - module_parameters.OFFSET;
        end
    
        % Calculate digital noise
        [output_df2, output_bqf, noise_df2, noise_bqf] = estimate_noise_file(double(data'), online_filters);
        
        if noise_bqf==0, display('noise is zero')
        end
        %gain=module_parameters.GAIN
        % Multiply filter output by module GAIN
        output_df2 = output_df2 * module_parameters.GAIN;
        output_bqf = output_bqf * module_parameters.GAIN;
        noise_df2 = noise_df2 * module_parameters.GAIN;
        noise_bqf = noise_bqf * module_parameters.GAIN;

        % Check LIMIT value
        if module_parameters.LIMIT_SW && max(abs(output_bqf)) > module_parameters.LIMIT
            disp('LIMIT is small!');
        end
%         output_df2(1:10)
%         output_bqf(1:10)
%         noise_df2(1:10)
%         noise_bqf(1:10)
        % Plot power spectrum density of the digital noise
        plot_psd(data, output_df2, output_bqf, noise_df2, noise_bqf, channel, fs);
    end
end