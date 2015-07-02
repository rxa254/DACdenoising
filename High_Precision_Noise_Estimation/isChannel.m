function flag = isChannel(channel_string, list)
    
    tf=strcmp(channel_string,list);
    k=find(tf);
    if k ~= 0 
        flag=1;
    else flag=0;
    end
end
