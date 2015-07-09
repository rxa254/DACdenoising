function [flag,flag_in,flag_out,channel_string] = getChannelName(site,common1,first_phrase,result_string, list_out,list_in)
    
    input_suffix='_IN1_DQ';
    output_suffix='_OUT_DQ';
    
    %Try 1st type of channel name

    common_string_channel_1= strcat(site,first_phrase,'-'); %change when changing site
        %common_string_channel_2=strcat('L2:',first_phrase,'-');
    append=length(first_phrase)+2;

    channel_string=strcat(common_string_channel_1,result_string(append:end),input_suffix);
    channel_string_out=strcat(common_string_channel_1,result_string(append:end),output_suffix);
    channel_string=char(channel_string);
    channel_string_out=char(channel_string_out);
         
                
    tf_out=strcmp(channel_string_out,list_out);
    tf_in=strcmp(channel_string,list_in);
    
    k_out=find(tf_out);
    k_in=find(tf_in);
    if k_in ~= 0
        flag=1;
        flag_in=1;
        flag_out=0;
        return;
    elseif k_out ~=0
        flag=1;
        flag_in=0;
        flag_out=1;
        channel_string=channel_string_out;
        return;
    else flag=0;
    end
    %trying second type of channel
    first_phrase=char(common1(3:5));
    common_string_channel_1= strcat(site,first_phrase,'-'); %change when changing site
    channel_string=strcat(common_string_channel_1,result_string,input_suffix);
    channel_string=char(channel_string);
    
    channel_string_out=strcat(common_string_channel_1,result_string,output_suffix);
    channel_string_out=char(channel_string_out);
    
    tf_out=strcmp(channel_string_out,list_out);
    tf_in=strcmp(channel_string,list_in);
    
    k_out=find(tf_out);
    k_in=find(tf_in);
    if k_in ~= 0
        flag=1;
        flag_in=1;
        flag_out=0;
        return;
    elseif k_out ~=0
        flag=1;
        flag_in=0;
        flag_out=1;
        channel_string=channel_string_out;
        return;
    else flag=0;
    end     
end

