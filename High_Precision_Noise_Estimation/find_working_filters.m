function [group] = find_working_filters(ifo, model, name)

	command = sprintf('ezcaread -n %s:%s-%s_SW1R', ifo, model, name);
    [~, key_1_6] = dos(command);
	command = sprintf('ezcaread -n %s:%s-%s_SW2R', ifo, model, name);
    [~, key_7_10] = dos(command);

	key_1_6 = str2double(key_1_6) - 4;
	key_7_10 = str2double(key_7_10) - 1536;
    
    group = zeros(10,1);
    
    value_1_6(1) = 48;
    value_1_6(2) = 192;
    value_1_6(3) = 768;
    value_1_6(4) = 1024;
    value_1_6(5) = 4096;
    value_1_6(6) = 49152;
    
    for i=6:-1:1
        if key_1_6 >= value_1_6(i) 
            group(i) = 1;
            key_1_6 = key_1_6 - value_1_6(i);
        end
    end
    
    value_7_10(1) = 3;
    value_7_10(2) = 6;
    value_7_10(3) = 48;
    value_7_10(4) = 64;
    
    for i=4:-1:1
        if key_7_10 >= value_7_10(i) 
            group(6+i) = 1;
            key_7_10 = key_7_10 - value_7_10(i);
        end
    end
end
