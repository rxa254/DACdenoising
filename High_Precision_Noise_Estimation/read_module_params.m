function module_params = read_module_params(channel)
    % Function returns parameters of a filter module
    
    % Ezcaread module input and output keys; offset, gain and limit values
    [~, input_key] = system(['ezcaread -n ' strrep(channel, '_IN1', '_SW1R')]);
    [~, output_key] = system(['ezcaread -n ' strrep(channel, '_IN1', '_SW2R')]);
    [~, offset] = system(['ezcaread -n ' strrep(channel, '_IN1', '_OFFSET')]);
    [~, gain] = system(['ezcaread -n ' strrep(channel, '_IN1', '_GAIN')]);
    [~, limit] = system(['ezcaread -n ' strrep(channel, '_IN1', '_LIMIT')]);


    
   
        
        
        % Convert switch keys to bits representation
        input_key = flipdim(dec2bin(str2double(input_key), 16)', 1);
        output_key = flipdim(dec2bin(str2double(output_key), 11)', 1);

        % Write parameter SWITCH parameters to structure
        module_params.INPUT_SW = str2double(input_key(3));
        module_params.OFFSET_SW = str2double(input_key(4));
        module_params.FILTERS_SW = str2num([input_key(6:2:end); output_key(2:2:8)]);
        module_params.LIMIT_SW = str2double(output_key(9));
        module_params.DECIMATION_SW = str2double(output_key(10));
        module_params.OUTPUT_SW = str2double(output_key(11));

        % Write offset, gain and limit parameters to structure
        module_params.OFFSET = str2double(offset);
        module_params.GAIN = str2double(gain);
        module_params.LIMIT = str2double(limit);

end