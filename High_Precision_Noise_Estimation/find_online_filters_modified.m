function online_filters = find_online_filters(iirs, params)
    % Function returns map of channels to iir filters that work online
    
    % Declare structure of online filters
    online_filters = [];
      
    % Check that filter is switched on
    for i=1:length(iirs)
        filters_sw = params.FILTERS_SW;
        if filters_sw(iirs(i).number+1) == 1
            online_filters = [online_filters iirs(i)];
	    online_filters=mp(online_filters,100);		
        end
    end
end
