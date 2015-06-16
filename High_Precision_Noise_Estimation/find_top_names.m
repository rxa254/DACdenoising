function subsystems =  find_top_names(file)
	% Function looks for SubSystems with top_names tag
	
	% Cell array with all SubSystems with top_names tag
	subsystems = {};
    
	% Open a file with model
	fd = fopen(file, 'r');
	if fd == -1
        disp(['Model file ' file ' not found. Change path to file']);
        return
    end

	% Read strings into a cell
	model_lines=textscan(fd, '%s', 'Delimiter', '\n');
	model_lines = model_lines{1};

	% Find indices of lines where top_names TAG is located
	istop=strfind(model_lines, 'top_names');
	ind = find(cellfun(@(x) ~isempty(x), istop));
	
	% Go to lines with NAME attribute (2 above from TAG)
	ind = ind - 2;

	% Read SubSystem NAMES with top_names tag
	for i=1:length(ind)
		% Split the line with NAME attribute
		words = regexp(model_lines{ind(i)}, '\s+', 'split');
		subsystem = words{2};
		% Delete quates 
		subsystem([1 end]) = [];

		% Add subsystem to cell array
		subsystems = [subsystems subsystem];
	end

	% Close file
    fclose(fd);
end
