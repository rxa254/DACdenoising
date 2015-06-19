function [output_df2, output_bqf, noise_df2, noise_bqf] = estimate_noise_file(signal, iir)

	n_iir=length(iir);
    output_df2=zeros(1,n_iir);
    output_bqf=zeros(1,n_iir);
    noise_df2=zeros(1,n_iir);
    noise_bqf=zeros(1,n_iir);
	fid=fopen('take_data.txt','w');
	if fid == -1
	     	disp(['Unable to open file take_data.txt']);
        	return
	end
	for i=1:n_iir
	fprintf(fid,'online_filters= \n');
	fprintf(fid,'number: %d\n',iir(i).number);
	fprintf(fid,'order: %d\n',iir(i).order);
	fprintf(fid,'g: %ld\n',iir(i).g);
	fprintf(fid,'sos: %ld\n',iir(i).sos);
	end
	fclose(fid);

	fid=fopen('take_data_signal.txt','w');
	if fid == -1
	     disp(['Unable to open file take_data.txt']);
         return
	end
	
	fprintf(fid,'%ld',signal);
	fclose(fid);
	
	pause(2);
    
    fid=fopen('give_data.txt','r');
    if fid == -1
        disp(['Error reading file']);
        return
    end
    for i=1:n_iir
        
        
        A=fscanf(fid,'%s',1);
        output_df2(i)=str2double(A);
        
        A=fscanf(fid,'%s',1);
        output_bqf(i)=str2double(A);
        
        A=fscanf(fid,'%s',1);
        noise_df2(i)=str2double(A);
        
        A=fscanf(fid,'%s',1);
        noise_bqf(i)=str2double(A);
   
    end
    fclose(fid);
end	

