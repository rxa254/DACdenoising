function check_inverted_digital_system_forsite(name, channel, filter_bank)
    % Function checks noise of the digital filter modules
    % given the list of models
    format longEng;
    
    % Get site parameters: IFO, ifo, site, chans directory, 
    % uapps directory, host name
    params = config_editedforsite(); %change when change the site
    
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
    module_parameters = read_module_params_forsite_inverted(channel); %change when change the time and also for site
    
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
    [data,fs] = download_online_data_forsite({channel}, T, fs); %change when change the time and for site
%     data(1:10)
    %fs
    pause(2)
%     T*fs
%     length(data)
   % data(end)
    if length(data) ~= T*fs || isempty(online_filters) || data(end) == 0
        disp('Fiter Module Switched Off');
        
    elseif length(data) == T*fs && ~isempty(online_filters) && data(end) ~= 0
    %if length(data) == T*fs && ~isempty(online_filters) ~= 0
        disp('Filter is On, Downloading data...');
        clear data
        T = 32;

        [data,fs] = download_online_data_forsite({channel}, T, fs);
       % data(1:10)
        disp('Got CHANNEL');
          % Subtract offset if it is ON
        
%         offset=module_parameters.OFFSET
        data=data/module_parameters.GAIN;
        input=invert_data(double(data'),online_filters);
        %adding offset gives us IN1 value
        if module_parameters.OFFSET_SW
            input = input + module_parameters.OFFSET;
            
        end
%         %subtracting the offset to calculate the filter output and also to
%         %account for quantization noise due to offset operation
%         if module_parameters.OFFSET_SW
%             input= input - module_parameters.OFFSET;
%             
%         end
       % input(1:10)
        % Calculate output
        
        output_bqf = estimate_noise_inverted(double(input), online_filters);
        output_bqf = output_bqf * module_parameters.GAIN;
        data=data*module_parameters.GAIN;
        
%         out-da
        noise_bqf=abs(data')-abs(output_bqf);
      
%         da=output_bqf(100)
%         out=data(:,100)
%         no=noise_bqf(100)
%         gain=module_parameters.GAIN
        % Multiply filter output by module GAIN
        %output_df2 = output_df2 * module_parameters.GAIN;
       
        %noise_df2 = noise_df2 * module_parameters.GAIN;
        noise_bqf = noise_bqf / module_parameters.GAIN;

        % Check LIMIT value
        if module_parameters.LIMIT_SW && max(abs(output_bqf)) > module_parameters.LIMIT
            disp('LIMIT is small!');
        end
%         output_df2(1:10)
%         output_bqf(1:10)
%         noise_df2(1:10)
%         noise_bqf(1:10)
        
        if noise_bqf==0, display('noise is zero')
        end
       
% Plot power spectrum density of the digital noise
        plot_psd_output(input,data,output_bqf,noise_bqf,channel, fs);
    end
    pause(2)
    close all;
end