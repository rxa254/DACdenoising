function noise_shaper_high_prem()
    close all;
%     load('saved_out_DARM_decreased.mat');
     mp.Digits(1);
    % sampling rate
%     rate_Hz = 524.288e3; 
    rate_Hz = mp('16.384e3');
%     rate_Hz=length(save_out)/32;
%     rate_Hz=256;
%     
%     exponent=(numel(num2str(rate_Hz))-5);
%     const=10^-exponent;
    % signal duration in seconds
    gcl_s = mp('32');
    len=gcl_s*rate_Hz;
    len1=double(len);
    fi=fopen('take_signal_shape.bin','rb');
    if fi==-1
        display('error reading file');
        return
    end
    [save_out,~]=fread(fi,len1,'real*8');
    fclose(fi);
%     
    td=mp(save_out');
%    
    factor=mp(0.8);
    pass_freq=factor*(rate_Hz/2);
    pass_freq=double(pass_freq);
    rate_Hz1=double(rate_Hz);
    hpFilt = designfilt('highpassiir', 'FilterOrder', 4, ...
             'PassbandFrequency', pass_freq, 'PassbandRipple', 3,...
             'SampleRate', rate_Hz1);
    sos=hpFilt.Coefficients;
    
    [b,a]=sos2tf(sos);
%   
    % *********************************************
    % Derive the noise shaper filter from the desired
    % noise frequency response
    % Note: a unit delay is removed by shortening bb.
    % *********************************************    
    bb = b / b(1);

    bb = bb(2:end) - a(2:end);
%     sos_s=tf2sos(bb,a);
%     [gain,sos_shape]=sos_shuffle(sos_s);

%    

    tdOut1 = mp(zeros(size(td)));
    tdOut2 = mp(zeros(size(td)));
    
    % "filterState" preserves the delay line content between 
    % invocations to "filter"
    filterState =[];
    filterState=mp(filterState);
    % quantErr is the quantization error of the -previous- sample
    % (because a unit delay was removed from the filter)
    quantErr = 0;
    quantErr=mp(quantErr);
%     n=numel(bb)
%     l=length(a)
%     SOS=tf2sos(bb,a);

    for ix = 1 : len;
        s = td(ix);
        
        % variant 1: ordinary quantization
        tdOut1(ix) = quant(s);

        % variant 2: quantization with noise shaping
%         if(filterState ~= 0), f_in=filterState
%         end
        quantErr1=double(quantErr);
        filterState1=double(filterState);
        [filterOut, filterState] = filter(bb,a, quantErr1, filterState1);
%             filterOut=sosfilt(SOS,quantErr);
%         if(filterState ~=0), f=filterState
%         end
        quantIn = mp(s + filterOut);
%         quantIn = s + quantErr;
        quantOut = mp(quant(quantIn));
%         quantErr = quantOut - quantIn;
        quantErr = mp(quantOut - quantIn);
        tdOut2(ix) = quantOut;
    end
    

   
    tdOut21=double(tdOut2);

%     length(filterState)
    % remove signal padding
%     td = td(nPad+1:end);
%     tdOut1 = tdOut1(nPad+1:end);
%     tdOut2 = tdOut2(nPad+1:end);
    %write the output to file to match with C code%%
    fi=fopen('match_data.txt','w');
    fprintf(fi,'%d\n',tdOut21);
    fclose(fi);

%%%% Read C code output , should be commented when MATLAB code is being tested%%%
    fid=fopen('shaped_out.txt','r');
    if fid==-1
        display('error opening file')
    end
    tdOut2C=fscanf(fid,'%d',len1);
    tdOut2C=tdOut2C';
    fclose(fid);
    
    %%Read Higher precision C Code output%%
    fid=fopen('shaped_out_long.txt','r');
    if fid==-1
        display('error opening file')
    end
    tdOut2Cl=fscanf(fid,'%d',len1);
    tdOut2Cl=tdOut2Cl';
    fclose(fid);
% %     
%     
%         %****PLOT DATA******%
% %    %%%% When comparing C And MATLAB %%%%
       figure(4);
    plot(tdOut2-tdOut2C);
    grid on;
    title('tdOut2-tdOut2C');
      figure(44);
    plot(tdOut2-tdOut2Cl);
    grid on;
    title('tdOut2-tdOut2Cl');

      figure(46);
    plot(tdOut2C-tdOut2Cl);
    grid on;
    title('diff between the two C codes');
    
%     diff=tdOut2(1000:2000)-tdOut2C(1000:2000);

    

   plot_shape(td-tdOut2,td-tdOut2C,td-tdOut2Cl,td,td,rate_Hz);
   
   %%%%%%%%%%%%%%%
   
   %%%%Plotting MATLAB Output ONLY %%%%%%%%%
%    plot_shape(td,tdOut1,tdOut2,td-tdOut1,td-tdOut2,rate_Hz);
   

    
end

% *********************************************
% quantizer model: 
% 18 bit integer round off with clipping
% *********************************************
function sOut = quant(s)
%     sOut=roundfloat(s,18);
    if s>=2^(17)-1
        display('clipping1');
        sOut=mp(int32(2^(17)-1));
    elseif s<=-2^(17)
        sOut=mp(int32(-2^(17)));
        display('clipping');
    else
       sOut=mp(int32(s));
    end
end
