%filter_name=zeros(1,13);
common='LSC';
common1=char(common);
input_filters={'AS11','AS55','AS165','AS110','REFL11','REFL33','REFL55','REFL165','POX11','POY11','POP55','POP22','POP110'};
for i=1:4
    common_string_channel1='C1:LSC-';
    common_string_channel2='_I_IN1';
    channel_string=strcat(common_string_channel1,input_filters(i),common_string_channel2);
    channel_string1=char(channel_string);
    filter_bank_string=strcat(common,'_',input_filters(i),'_I');
    filter_bank_string1=char(filter_bank_string)
    check_digital_system(common1,channel_string1,filter_bank_string1)
    display('did it plot?')
end
