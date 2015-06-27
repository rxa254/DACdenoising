common='LSC';
common1=char(common)
fid=fopen('filter_names.txt','r');
if fid == -1
     disp(['Model file C1LSC.txt not found. Change path to file']);
        return
end
    
[a,count]=fscanf(fid,'%s');
a_trun=a(66:1656) %66 is the start
%start storing at underscore, until L or # occurs.
len=length(a_trun)
count=0;
for i=1:len
   if i>len, break
   end
    if i > count
                count=0;
                if a_trun(i) == '_'
                for j=i:len
                    if j+2>len, break
                    end
                 if ~strcmp(a_trun(j:j+2),'LSC') && ~strcmp(a_trun(j),'#')
                     count=count+1;

                 else
                     break;
                 end
                end
                result=a_trun(i+1:i+count-1);
                result_string=char(result)
                count=count+i;
                common_string_channel1='C1:LSC-'
                common_string_channel2='_IN1'
                channel_string=strcat(common_string_channel1,result_string,common_string_channel2);
                channel_string1=char(channel_string)
                filter_bank_string=strcat(common,'_',result_string);
                filter_bank_string1=char(filter_bank_string)
                check_digital_system(common1,channel_string1,filter_bank_string1)
                display('did it plot?')

                end
    end
 end
   display('done')
