fnames=dir('/home/ayush/h1_filter_files/h1_archive/*.txt');
for i=1:length(fnames)
    file_name=strcat('/home/ayush/h1_filter_files/h1_archive/',fnames(i).name)
    fid=fopen(file_name,'r');
    
    if fid == -1
         disp([strcat('Model file ', fnames(i).name, 'not found. Change path to file')]);
            return
    end
    common=fnames(i).name;
    trunc=length(common)-4; %removing the .txt to get name from the file name
    common1=common(1:trunc);
    
    dummy=fgets(fid);
    dummy=fgets(fid);
    dummy=fgets(fid);
    dummy=fgets(fid);
    a=fgets(fid);
    
    while ischar(a)
        words=regexp(a,'\s+','split')
        if strcmp(words(2),'MODULES')==1
            j=3;
            while(strcmp(words(j),'')~=1)
                result_string=words(j);
                result_string=char(result_string);
                first_phrase=regexp(result_string,'_','split');
                first_phrase=first_phrase(1);
                first_phrase=char(first_phrase);
                common_string_channel1= strcat('H1:',first_phrase,'-');
                append=length(first_phrase)+2;
                common_string_channel2='_IN1_DQ';
                channel_string=strcat(common_string_channel1,result_string(append:end),common_string_channel2);
                channel_string1=char(channel_string);
                filter_bank_string1=char(words(j));
                try
                    display('calling function with following parameters');
                    common1
                    channel_string1
                    filter_bank_string1
                    check_digital_system_forsite(common1,channel_string1,filter_bank_string1);
                catch ME
                    getReport(ME)
                    display('The execution will continue for other filters');
                end
                j=j+1;
            end
        
        else break;
        end
        a=fgets(fid);
                 
    end
end
display('done')

