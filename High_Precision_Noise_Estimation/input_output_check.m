count=0;
count_out=0;
list_out=conn.findChannels('*_OUT_DQ');
list_in=conn.findChannels('*_IN1_DQ');

for i=1:length(list_out)
    words=regexp(char(list_out(i)),' ','split');
    var=char(words(1));
    list_out_modified(i)=cellstr(var(2:end));
    var=char(list_out_modified(i));
    list_out_modified(i)=cellstr(var(1:end-7));
end
for i=1:length(list_in)
    words=regexp(char(list_in(i)),' ','split');
    var=char(words(1));
    list_in_modified(i)=cellstr(var(2:end));
    var=char(list_in_modified(i));
    list_in_modified(i)=cellstr(var(1:end-7));
end

for i=1:length(list_in_modified)
    
    tf=strcmp(list_in_modified(i),list_out_modified);
    
    k=find(tf);
    if k ~= 0, 
        count=count+1;
        var=char(list_in_modified(i));
        comm(count)=cellstr(var);
    else continue;
    end
end
count
    

for i=1:length(list_out_modified)
    
    tf=strcmp(list_out_modified(i),list_in_modified);
    
    k=find(tf);
    if k ~= 0, 
        count_out=count_out+1;
        var=char(list_out_modified(i));
        comm_out(count_out)=cellstr(var);
    else continue;
    end
end
count_out
    