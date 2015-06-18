function [output_df2, output_bqf, noise_df2, noise_bqf] = estimate_noise_file(signal, iir)

	n_iir=length(iir);
	fid=fopen('take_data.txt','w');
	if fid == -1
	     	disp(['Unable to open file take_data.txt']);
        	return
	end
	for i=1:n_iir
	fprintf(fid,'online_filters= \n');
	fprintf(fid,'number: %d\n',iir(i).number);
	fprintf(fid,'order: %d\n',iir(i).order);
	fprintf(fid,'g: %.10f\n',iir(i).g);
	fprintf(fid,'sos: %.10f\n',iir(i).sos);
	end
	fclose(fid);

	fid=fopen('take_data_signal.txt','w');
	if fid == -1
	     disp(['Unable to open file take_data.txt']);
         return
	end
	
	fprintf(fid,'%0.10f',signal);
	fclose(fid);
	
	pause(2);

end	
