function [flag_in,flag_out,channel_string] = isChannel(channel_string, list_out,list_in)
    
    tf_out=strcmp(channel_string,list_out);
    tf_in=strcmp(channel_string,list_in);
    
    k_out=find(tf_out);
    k_in=find(tf_in);
    if k_in ~= 0
        flag_in=1;
        flag_out=0;
    elseif k_in ~ flag_in=0;
    end
end
