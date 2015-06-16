function check_digital_system(name, channel, filter_bank)
    % Function checks noise of the digital filter modules
    % given the list of models

    % Get site parameters: IFO, ifo, site, chans directory, 
    % uapps directory, host name
    params = config();
    mp.Digits=100;
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
    module_parameters = read_module_params(channel);

    % Filters that are switched on
    online_filters = find_online_filters(modules(filter_bank), module_parameters);

    % Download data from the channel
    clear data
    T = 32;
    data = download_online_data({channel}, mp(T), mp(fs));
    mp(data(1:10))

    pause(2)

    if length(data) == T*fs && ~isempty(mp(online_filters)) && data(end) ~= 0
        disp('Got CHANNEL');
        
        % Subtract offset if it is ON
        if module_parameters.OFFSET_SW
            data = data - module_parameters.OFFSET;
        end

        % Calculate digital noise
        [output_df2, output_bqf, noise_df2, noise_bqf] = estimate_noise(mp(data'), mp(online_filters));

        % Multiply filter output by module GAIN
        output_df2 = output_df2 * module_parameters.GAIN;
        output_bqf = output_bqf * module_parameters.GAIN;
        noise_df2 = noise_df2 * module_parameters.GAIN;
        noise_bqf = noise_bqf * module_parameters.GAIN;

        % Check LIMIT value
        if module_parameters.LIMIT_SW && max(abs(mp(output_bqf))) > module_parameters.LIMIT
            disp('LIMIT is small!');
        end

        % Plot power spectrum density of the digital noise
        plot_psd(mp(data), mp(output_df2), mp(output_bqf), mp(noise_df2), mp(noise_bqf), channel, mp(fs));
    end
end
