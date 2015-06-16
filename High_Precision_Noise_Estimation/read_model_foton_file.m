function [modules, fs] = read_model_foton_file(file)
    % Function reads Foton file with IIR filters of a given model

    % Open Foton file
    fd = fopen(file, 'r');
    if fd == -1
        disp(['Foton file ' file ' not found. Change path to file']);
        return
    end
    
    % Module name map to module filters
    modules = containers.Map();
    
    % Read lines of the Foton file until empty
    tline = fgets(fd);
    while ischar(tline)
        % Split line into words
        words = regexp(tline, '\s+', 'split');

        % Check if line is useful
        if length(words) < 2 || isempty(words{1})
            tline = fgets(fd);
            continue
        end
        
        % Read model sampling frequency
        if strcmp('SAMPLING', words{2})
            fs = str2double(words{4});
        end
        
        % Read names of each module
        if strcmp('MODULES', words{2})
            for j=3:length(words)
				if ~isempty(words{j})
                	modules(words{j}) = [];
				end
            end
        end
                
        % Extract sos-representation of the filters
        sw = (strfind(keys(modules), words{1}));
        sw = sw(~cellfun('isempty', sw));
        if ~strcmp('#', words{1}(1)) && ~isempty(sw)
            iir.number = str2double(words{2});      % filter number
            iir.order = str2double(words{4});       % order
            iir.g = str2double(words{8});           % gain
            iir.sos = zeros(iir.order, 4);       % sos matrix
            iir.sos(1,1:4) = str2num([words{9} ' ' words{10} ' ' words{11} ' ' words{12}]);

            % Read remaining sos matrix
            for j=2:1:iir.order
                tline = fgets(fd);
                elem = regexp(tline, '\s+', 'split');
                iir.sos(j,1:4) = str2num([elem{2} ' ' elem{3} ' ' elem{4} ' ' elem{5}]);
            end
            modules(words{1}) = [modules(words{1}) iir];
        end 
        tline = fgets(fd);
    end
    fclose(fd);
end