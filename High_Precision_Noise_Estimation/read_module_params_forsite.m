function module_params = read_module_params_forsite(channel)
    % Function returns parameters of a filter module
    
    % Ezcaread module input and output keys; offset, gain and limit values
    conn = nds2.connection('nds.ligo-la.caltech.edu', 31200);
    str=strrep(channel,'_IN1_DQ','_SWSTAT')
    buffers = conn.fetch(1119305120,1119305136,{str});
    key_all=buffers(1).getData();
    %[~, key_all] = conn.iterate(channel)
    %system(['ezcaread -n ' strrep(channel, '_IN1', '_SW1R')])
    %[~, output_key] = conn.iterate(strrep(channel,'_IN1','SWSTAT'));
    %system(['ezcaread -n ' strrep(channel, '_IN1', '_SW2R')]);
    str=strrep(channel, '_IN1_DQ', '_OFFSET');
    buffers = conn.fetch(1119305120,1119305136, {str});
    offset=buffers(1).getData();
    %system(['ezcaread -n ' strrep(channel, '_IN1', '_OFFSET')]);
    str=strrep(channel, '_IN1_DQ', '_GAIN');
    buffers = conn.fetch(1119305120,1119305136, {str});
    gain=buffers(1).getData();
    %system(['ezcaread -n ' strrep(channel, '_IN1', '_GAIN')]);
    str=strrep(channel, '_IN1_DQ', '_LIMIT');
    buffers = conn.fetch(1119305120,1119305136, {str});
    limit=buffers(1).getData();
    %system(['ezcaread -n ' strrep(channel, '_IN1', '_LIMIT')]);

    
   
        
        
        % Convert switch keys to bits representation
        key=flip(dec2bin(key_all(1),16)')
        %input_key = flipdim(dec2bin(str2double(input_key), 16)', 1);
        %output_key = flipdim(dec2bin(str2double(output_key), 11)', 1);
        

        % Write parameter SWITCH parameters to structure
        module_params.INPUT_SW = key(11);
        module_params.OFFSET_SW =  key(12);
        module_params.FILTERS_SW =  key(1:10);
        module_params.LIMIT_SW = key(14);
        module_params.DECIMATION_SW = key(16);
        module_params.OUTPUT_SW = key(13);
%        module_params.INPUT_SW = str2double(input_key(3));
%        module_params.OFFSET_SW = str2double(input_key(4));
%        module_params.FILTERS_SW = str2num([input_key(6:2:end); output_key(2:2:8)]);
%        module_params.LIMIT_SW = str2double(output_key(9));
%        module_params.DECIMATION_SW = str2double(output_key(10));
%        module_params.OUTPUT_SW = str2double(output_key(11));

        % Write offset, gain and limit parameters to structure
        module_params.OFFSET = double(offset(1));
        module_params.GAIN = double(gain(1));
        module_params.LIMIT = double(limit(1));

end