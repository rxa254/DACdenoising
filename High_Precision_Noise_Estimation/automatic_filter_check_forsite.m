fnames=dir('/home/ayush/h1_filter_files/h1_archive/*.txt');

for i=1:length(fnames)
    count_try=0;
    k=1;
    count_catch=0;
    file_name=strcat('/home/ayush/h1_filter_files/h1_archive/',fnames(i).name)
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
                common_string_channel1= strcat('H1:',first_phrase,'-'); %change when changing site
                append=length(first_phrase)+2;
                common_string_channel2='_IN1_DQ';
                channel_string=strcat(common_string_channel1,result_string(append:end),common_string_channel2);
                channel_string1=char(channel_string);
                filter_bank_string1=char(words(j));
                channel_list_file(i,k)=cellstr(channel_string1);
                try
                    display('calling function with following parameters');
                    disp(strcat('check_digital_system_forsite( ',common1,',', channel_string1,' ,', filter_bank_string1,',)'));
                    count_try=count_try+1;
                    check_digital_system_forsite(common1,channel_string1,filter_bank_string1);
                    
                catch ME
                    log_filter(i,k)=cellstr(filter_bank_string1);
                    
                    k=k+1;
%                     display('checking other possibility');
                    count_catch=count_catch+1;
                    display(char(10));
                    display('The execution will continue for other filters');
                    display(char(10));
%                     
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
    end
        
end
display('done, writing the log file')
disp(strcat('Faulty files are ',faulty_file));
%disp(strcat('Faulty filters are: ',log_filter));


