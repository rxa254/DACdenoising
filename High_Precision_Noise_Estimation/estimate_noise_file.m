function [output_df2, output_bqf, noise_df2, noise_bqf] = estimate_noise_file(signal, iir)
    
	n_iir=length(iir);
	len=length(signal);
%     len
%     n_iir
    output_df2=zeros(1,len);
	output_bqf=zeros(1,len);
    noise_df2=zeros(1,len);
    noise_bqf=zeros(1,len);
%     noise_df2_single=zeros(1,len);
%     noise_bqf_single=zeros(1,len);
	fid=fopen('take_data.bin','wb');
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

	fid=fopen('take_data_signal.bin','wb');
	if fid == -1
		disp(['Unable to open file take_data_signal.txt']);
        return
    end
    fwrite(fid,len,'int');
    fwrite(fid,n_iir,'int');
	for i=1:len
        fwrite(fid,signal(i),'real*8');
    end
        
	fclose(fid);
	!./est

    pause(2);
    
    fid=fopen('give_data.bin','rb');
    if fid == -1
        disp(['Error reading file']);
        return
    end
    
        
       
	        
        output_df2=fread(fid,len,'real*8');
       


        output_bqf=fread(fid,len,'real*8');
       

        noise_df2=fread(fid,len,'real*8');
       
        noise_bqf=fread(fid,len,'real*8');
       
%             
%         	A=fscanf(fid,'%s',1);
%         	noise_df2_single(j)=str2double(A);
%             
%             
%         	A=fscanf(fid,'%s',1);
%         	noise_bqf_single(j)=str2double(A);

   
   
    fclose(fid);
end	
