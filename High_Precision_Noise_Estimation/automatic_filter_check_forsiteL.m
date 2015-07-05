%The function automatically checks for quantization noise in all the
%digital filters in the digital controller of the advanced ligo
fnames=dir('/home/ayush/l1_filter_files/l1_archive/*.txt');
conn=nds2.connection('nds.ligo-la.caltech.edu',31200);
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
    count_catch=0;
    file_name=strcat('/home/ayush/l1_filter_files/l1_archive/',fnames(i).name)
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
                
                common_string_channel_1= strcat('L1:',first_phrase,'-'); %change when changing site
                %common_string_channel_2=strcat('L2:',first_phrase,'-');
                append=length(first_phrase)+2;
                suffix_string='_IN1_DQ';
                channel_string1=strcat(common_string_channel_1,result_string(append:end),suffix_string);
                channel_string1=char(channel_string1);
                %channel_string2=strcat(common_string_channel_2,result_string(append:end),suffix_string);
                %channel_string2=char(channel_string2);
                if length(first_phrase) ~= 3
                    first_phrase=char(common1(3:5));
                    common_string_channel_1= strcat('L1:',first_phrase,'-'); %change when changing site
                    %common_string_channel_2=strcat('L2:',first_phrase,'-');
                    channel_string1=strcat(common_string_channel_1,result_string,suffix_string);
                    channel_string1=char(channel_string1);
                    %channel_string2=strcat(common_string_channel_2,result_string,suffix_string);
                    %channel_string2=char(channel_string2);
                end
                %channel_list_file(i,k)=cellstr(channel_string1);
                if isChannel(channel_string1,list_in)
                    display('channel is present');
                    try
                        display('calling function with following parameters');
                        disp(strcat('check_digital_system_forsite( ',common1,',', channel_string1,' ,', result_string,')'));
                        count_try=count_try+1;
                        check_digital_system_forsiteL(common1,channel_string1,result_string);

                    catch
%                         try
%                             disp(strcat('check_digital_system_forsite( ',common1,',', channel_string2,' ,', result_string,')'));
%                             check_digital_system_forsite(common1,channel_string2,result_string);
%                             
%                         catch

                            log_filter(i,k)=cellstr(result_string);

                            k=k+1;
                            %display('checking other possibility');
                            count_catch=count_catch+1;
                            display(char(10));
                            display('The execution will continue for other filters');
                            display(char(10));
%                   
                            
%                         end
                         
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
    else num(i)=count_try;
    end
        
end
display('done, writing the log file')
disp(strcat('Faulty files are ',faulty_file));
%disp(strcat('Faulty filters are: ',log_filter));

s=nonzeros(num);
