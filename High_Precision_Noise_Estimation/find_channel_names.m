function channels = find_channel_names(model, modules, subsystems)
	% Function creates channels names and replaces keys in modules map
	% from module names to channels

	% Extract module names and parse it
    IFO = getenv('IFO');
	module_names = keys(modules);
	[first_parts res_parts] = strtok(module_names,'_');
    
	% Create cell array of channels
	channels = cell(size(module_names));
    
	for i=1:length(channels)
		% If subsystems does not have top_names TAG then
		% channel name is IFO:MODEL-MODULE_NAME_IN1_DQ
        sw = strfind(subsystems, first_parts{i});
        sw = sw(~cellfun('isempty', sw));
        if isempty(sw)
            channels{i} = [IFO ':' model '-' module_names{i} '_IN1'];
		% Else channel name is IFO:SUBSYSTEM-RESIDUAL_MODULE_NAME_IN1_DQ
		else
			% Delete '_' in the beginning of residual module name
			res_part = res_parts{i};
			res_part(1) = [];
			channels{i} = [IFO ':' first_parts{i} '-' res_part '_IN1'];
		end

		% Replace keys in the map
		modules(channels{i}) = modules(module_names{i});
		remove(modules, module_names{i});
	end
end
