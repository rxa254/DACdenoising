function input = invert_data(output, iir)
    
	n_iir=length(iir);
	len=length(output);
%     len
%     n_iir
    input=zeros(1,len);
%     output_df2=zeros(1,len);
% 	output_bqf=zeros(1,len);
%     noise_df2=zeros(1,len);
%     noise_bqf=zeros(1,len);
%     noise_df2_single=zeros(1,len);
%     noise_bqf_single=zeros(1,len);
	fid=fopen('take_data_invert.bin','wb');
	if fid == -1
        disp(['Unable to open file take_data.txt']);
        return
    end
    
	for i=1:n_iir
        	fwrite(fid,iir(i).number,'int');
        	fwrite(fid,iir(i).order,'int');
        	fwrite(fid,iir(i).g,'real*8');
        	fwrite(fid,iir(i).sos','real*8');
    end
        
  
	fclose(fid);
%     gain=iir(1).g
%     number=iir(1).number
%     order=iir(1).order
	fid=fopen('take_data_signal_invert.bin','wb');
	if fid == -1
		disp(['Unable to open file take_data_signal.txt']);
        return
    end
    fwrite(fid,len,'int');
    fwrite(fid,n_iir,'int');
%     output(1:10)
	for i=1:len
        fwrite(fid,output(i),'real*8');
    end
        
	fclose(fid);
	!./inv

    pause(2);
    
    fid=fopen('give_data_invert.bin','rb');
    if fid == -1
        disp(['Error reading file']);
        return
    end
    
    input=fread(fid,len,'real*8');
    
       
	        
%         output_df2=fread(fid,len,'real*8');
%        
% 
% 
%         output_bqf=fread(fid,len,'real*8');
%        
% 
%         noise_df2=fread(fid,len,'real*8');
%        
%         noise_bqf=fread(fid,len,'real*8');
       
%             
%         	A=fscanf(fid,'%s',1);
%         	noise_df2_single(j)=str2double(A);
%             
%             
%         	A=fscanf(fid,'%s',1);
%         	noise_bqf_single(j)=str2double(A);

   
   
    fclose(fid);
end	
