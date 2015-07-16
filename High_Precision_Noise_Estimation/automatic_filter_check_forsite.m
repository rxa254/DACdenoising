%The function automatically checks for quantization noise in all the
%digital filters in the digital controller of the advanced ligo
fnames=dir('/home/ayush/h1_filter_files/h1_archive/*.txt');
conn=nds2.connection('nds.ligo-wa.caltech.edu',31200);
site='H1:';
list_h1_in=conn.findChannels('*_IN1_DQ');
list_h1_out=conn.findChannels('*_OUT_DQ');
num=zeros(length(fnames));
% length(list_h1_out);

for i=1:length(list_h1_in)
    var=char(list_h1_in(i));
    words=regexp(var,' ','split');
    var=char(words(1));
    var=var(2:end);
    list_in(i)=cellstr(var);
end

for i=1:length(list_h1_out)
    var=char(list_h1_out(i));
    words=regexp(var,' ','split');
    var=char(words(1));
    var=var(2:end);
    
    list_out(i)=cellstr(var);
end
    
for i=1:length(fnames)
    count_try=0;
    k=1;
    l=1;
    m=1;
    count_catch=0;
    file_name=strcat('/home/ayush/h1_filter_files/h1_archive/',fnames(i).name);
    fid=fopen(file_name,'r');
    
    if fid == -1
         disp(strcat('Model file ', fnames(i).name, 'not found. Change path to file'));
            break;
    end
    common=fnames(i).name;
    trunc=length(common)-4; %removing the .txt to get name from the file name
    common1=common(1:trunc);
    %ignoring the first four lines in the file
    dummy=fgets(fid);
    dummy=fgets(fid);
    dummy=fgets(fid);
    dummy=fgets(fid);
    a=fgets(fid);
    
    while ischar(a)
        words=regexp(a,'\s+','split');
        if strcmp(words(2),'MODULES')==1
            j=3;
            while(strcmp(words(j),'')~=1)
                
                result_string=words(j);
                result_string=char(result_string);
                first_phrase=regexp(result_string,'_','split');
                first_phrase=first_phrase(1);
                first_phrase=char(first_phrase);
                
               
                [flag, flag_in, flag_out, channel_string]=getChannelName(site,common1,first_phrase,result_string,list_out,list_in);
                if flag==0
                    display('Channel not present at all');
                    count_catch=count_catch+1;
                    log_filter(i,k)=cellstr(channel_string);
                    k=k+1;
                elseif flag==1
                    count_try=count_try+1;
                    if flag_in==1
                        try
                            disp(strcat('check_digital_system_forsite( ',common1,',', channel_string,' ,', result_string,')'));
                            check_digital_system_forsite(common1,channel_string,result_string);
                        catch
                            disp('Report NDS bug maybe? Or some other issue');
                            log_server(i,m)=cellstr(channel_string);
                            m=m+1;
                        end
                    elseif flag_out==1
                        
                        log_filter_out(i,l)=cellstr(channel_string);
                        l=l+1;
                        try
                            disp(strcat('check_inverted_digital_system_forsite( ',common1,',', channel_string,' ,', result_string,')'));
                            check_inverted_digital_system_forsite(common1,channel_string,result_string);
                        catch
                            disp('Report NDS bug maybe? Or some other issue');
                            log_server(i,m)=cellstr(channel_string);
                            m=m+1;
                        end
                    end
                end  
                j=j+1;
            end
            
        else break;
        end
               
       
        
        a=fgets(fid);  
    end     
    fclose(fid);


    faulty_file(1)=cellstr('start');
    if count_try==count_catch 
        display('All filters in this file gave error');
        faulty_file(i+1)=cellstr(char(fnames(i).name));
    %     else num(i)=count_try;
    end
end
display('Done! Now writing the log file...')

fid=fopen('log_file.csv','wt');
csvFun = @(str)sprintf('%s,',str);
xchar = cellfun(csvFun, log_filter, 'UniformOutput', false);
xchar = strcat(xchar{:});
xchar = strcat(xchar(1:end-1),'\n');
fprintf(fid,xchar);
xchar = cellfun(csvFun, faulty_file, 'UniformOutput', false);
xchar = strcat(xchar{:});
xchar = strcat(xchar(1:end-1),'\n');
fprintf(fid,xchar);
xchar = cellfun(csvFun, log_filter_out, 'UniformOutput', false);
xchar = strcat(xchar{:});
xchar = strcat(xchar(1:end-1),'\n');
fprintf(fid,xchar);
xchar = cellfun(csvFun, log_server, 'UniformOutput', false);
xchar = strcat(xchar{:});
xchar = strcat(xchar(1:end-1),'\n');
fprintf(fid,xchar);
fclose(fid);



