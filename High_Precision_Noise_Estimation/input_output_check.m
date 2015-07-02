count=0;
count_out=0;
for i=1:length(list_out)
    var=char(list_out(i));
    list_out_modified(i)=cellstr(var(1:end-7));
end
for i=1:length(list_in)
    var=char(list_in(i));
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
    