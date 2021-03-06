#include<stdlib.h>
#include<math.h>
#include<stdio.h>

#include "filter_forms_modified.c"

#define size 4 //hardcoding the size of sos array to 4. Any Problem?
#define length 524288
#define times 1
/*
struct iir_filters
{
	int number, order;
	double g, **sos,**sos_bqf; 
};
*/

int main()
{

	//variable definitions 
	int number, order;
	//double **sos_bqf, **sos;
//	double sos[times][size],sos_bqf[times][size]; 
	double **test;
	double g, iir[5];
	int count=0,num,ord,j,i,sig=0,k;
	long double signal[length], output_df2_longdouble[length], output_bqf_longdouble[length], noise_df2[length], noise_bqf[length];
	double output_df2[length],output_bqf[length];
	double t, s[times][size];
	double signal_d[length];//, output_df2_d[length],output_bqf_d[length];
	char dummy3;
	char dummy1[15],dummy2[15];
	//allocate table
	double **sos = (double**) malloc(times*sizeof(double*));
	double **sos_bqf = (double**) malloc(times*sizeof(double*));	
	//allocate rows		
    	for(i=0; i<times; i++) 
	{
		sos[i] = (double*) malloc (size * sizeof(double));
		sos_bqf[i]=(double*) malloc (size * sizeof(double));
	} 
	//allocate colums and set value
 	for(i=0; i<times; i++) 
	{
		for(j=0; j<size; j++) 
		{
			
			sos[i][j] = 0;
			printf("sos[%d][%d]: %lf",i,j,sos[i][j]);
			sos_bqf[i][j] = 0;
			printf("sos_bqf[%d][%d]: %lf",i,j,sos_bqf[i][j]);
		}
	}
	
	//allocate colums and set value
	//file read to extract signal and online_filters structure

	FILE *fi,*fo, *fs; //defining pointers to files for input file to be read and output file fo to be written

	fi=fopen("take_data.txt","r");
	if(fi==NULL)
	{
		printf("\nError Reading File \n");
	}
	while(fscanf(fi, "%s", dummy1) != EOF)
	{
		fscanf(fi,"%s",dummy2);
		fscanf(fi,"%d",&num);
		number=num;
		fscanf(fi,"%s",dummy2);
		fscanf(fi,"%d",&ord);
		order=ord;
		fscanf(fi,"%s",dummy2);
		fscanf(fi,"%lf",&t);
		g=t;
		fscanf(fi,"%s",dummy2);
		//fscanf(fi,"%s",dummy2);		
		//dummy3=fgetc(fi);
		//printf("%c\n",dummy3);

		
		//allocate colums and set value
 		for(i=0; i<times; i++) 
		{
			for(j=0; j<size; j++) 
			{
				fscanf(fi,"%lf",&s[i][j]);
				sos[i][j] = s[i][j];
				printf("sos[%d][%d]: %lf",i,j,sos[i][j]);
			}
		}
			
			
		//dummy3=fgetc(fi);
		//printf("%c\n",dummy3);	
		//fscanf(fi,"%s",dummy2);
		//printf("\n%d\n%d\n%Lf\n",iir.number,iir.order,iir.g);
		
		count=count+1;
		
	}
	fclose(fi);
	printf("\ncount = %d\n",count);

	//now reading signal

	fs=fopen("take_data_signal.txt","r");
	if(fs==NULL)
	{
		printf("\nError Reading File \n");
	}
	i=0;
	while(fscanf(fs, "%Lf", &signal[i]) != EOF)
	{
		
		i=i+1;
		
	}
	fclose(fs);
	sig=i;
	printf("\nsig = %d\n",sig);
	
	
	//Initialize and allocate memory to Biquad filter coefficients
	/*for(i=0;i<count;i++)
	{
		//allocate table
		 
		double **sos_bqf = (double**) malloc(times * sizeof(double*));

		//allocate rows		
    		for(k=0; k<times; k++) 
		{
			sos_bqf[k] = (double*) malloc (size * sizeof(double));
		}
		
		//initialize sos_bqf
		for(k=0; k<times; k++) 
		{
			for(j=0; j<size; j++) 
			{
				//iir[i].sos_bqf[k][j] =0;
				sos_bqf[k][j] =0;
				//printf("sos_bqf: %lf\n",iir[i].sos_bqf[k][j]);
				printf("sos_bqf[%d][%d]: %lf\n",k,j,sos_bqf[k][j]);
			}
		}
	
	} */

	//calculate biquad filter coefficients
	/*
	for(i=0;i<count;i++)
	{
	       // iir[i].sos_bqf = zeros(size(iir(i).sos)); //initiate sos_bqf array as an element of structure iir_filters with all zeros. 				Already done	
		for(k=0;k<times;k++)
		{

		        iir[i].sos_bqf[k][0] = -iir[i].sos[k][0] - 1; //start filling in values of sos_bqf
		        iir[i].sos_bqf[k][1] = -iir[i].sos[k][0] - iir[i].sos[k][1] - 1;
		        iir[i].sos_bqf[k][2] = iir[i].sos[k][2] - iir[i].sos[k][0];
		        iir[i].sos_bqf[k][3] = iir[i].sos[k][3] - iir[i].sos[k][1] + iir[i].sos[k][2] - iir[i].sos[k][0];
		}
	}
    
	  // iir[i].sos_bqf = zeros(size(iir(i).sos)); //initiate sos_bqf array as an element of structure iir_filters with all zeros. 				Already done 	*/
	//printf("\n\n\n\n\nEntered Loop\n\n\n");
	for(i=0;i<count;i++)
	{	
		//printf("\n\n\n\n\nEntered Loop\n\n\n");
		for(j=0; j<times; j++)
		{
			//printf("\n\n\n\n\nEntered Loop\n\n\n");
		        sos_bqf[j][0] = -sos[j][0] - 1; //start filling in values of sos_bqf
			//printf("\n\n\n\n\nEntered Loop\n\n\n");
		        sos_bqf[j][1] = -sos[j][0] - sos[j][1] - 1;
		        sos_bqf[j][2] = sos[j][2] - sos[j][0];
		        sos_bqf[j][3] = sos[j][3] - sos[j][1] + sos[j][2] - sos[j][0];
			//printf("\n\n\n\n\nEntered Loop\n\n\n");
		}
		//printf("\n\n\n\n\nEntered Loop\n\n\n");
	}
	for(k=0; k<times; k++) 
		{
			//printf("\n\n\n\n\nEntered Loop\n\n\n");
			for(j=0; j<size; j++) 
			{
				
				//printf("sos_bqf: %lf\n",iir[i].sos_bqf[k][j]);
				printf("sos_bqf[%d][%d]: %lf\n",k,j,sos_bqf[k][j]);
			}
		}
		
 	
	

    //Calculate output from the filter bank using df2 and bqf
	/*
    	for (i=0; i<count; i++)
	{
        	iir_df2_longdouble(signal, output_df2_longdouble, sig, iir[i].sos, iir[i].g, size);
	        iir_df2_double((double)signal, (double)output_df2, sig, iir[i].sos, iir[i].g, size);
        	iir_bqf_longdouble(signal, output_bqf_longdouble, sig, iir[i].sos_bqf, iir[i].g, size);
        	iir_bqf_double((double)signal, (double)output_bqf, sig, iir[i].sos_bqf, iir[i].g, size);
	}
	*/

	for(i=0;i<length;i++)
	{
		signal_d[i]=(double)signal[i];
		//output_df2_d[i]=(double)output_df2[i];
		//output_bqf_d[i]=(double)output_bqf[i];
	}
	for (i=0; i<count; i++)
	{
		//printf("\n\n\n\n\nEntered Loop assigning sos_bqf now\n\n\n");
        	iir_df2_longdouble(signal, output_df2_longdouble, length, sos, g, times);
		//printf("\n\n\n\n\nEntered Loop assigning sos_bqf now\n\n\n");
	        iir_df2_double(signal_d, output_df2, length,sos, g, times);
        	iir_bqf_longdouble(signal, output_bqf_longdouble, length, sos_bqf, g, times);
        	iir_bqf_double(signal_d, output_bqf, length,sos_bqf,g, times);
		//printf("\n\n\n\n\nEntered Loop assigning sos_bqf now\n\n\n");
	}
    //Calculate filter noise
	for(i=0;i<length;i++)
	{
		//printf("\n\n\n\n\nEntered Loop assigning sos_bqf now\n\n\n");
	    	noise_df2[i] = output_df2_longdouble[i] - output_df2[i];
	    	noise_bqf[i] = output_bqf_longdouble[i] - output_bqf[i];
	}
	/*Write outputs to file, viz. the outputs and the noises. This file give_data.txt will be read by matlab. Hence, file names have been used with reference to C code and not matlab */
	printf("\n%lf\n",output_df2[1]);
	printf("\n%lf\n",output_bqf[1]);
	printf("\n%Lf\n",noise_df2[1]);
	printf("\n%Lf\n",noise_bqf[1]);
	fo=fopen("give_data.txt","w");

	//printing output of df2 to the file
	for(i=0;i<length;i++)
	{
		fprintf(fo,"%Lf\n",output_df2_longdouble[i]);
	
		fprintf(fo,"%Lf\n",output_bqf_longdouble[i]);
	
		fprintf(fo,"%Lf\n",noise_df2[i]);

		fprintf(fo,"%Lf\n",noise_bqf[i]);
	}
		
	fclose(fo);

	
/*The plan is to get long double output from the filter_modified.c file. Then calculate noise using the double and the long double output in this code, finally printing out double output (or long double) and noise to a file which then matlab will read. When to call which function? You have to call all of them, one by one, storing their outputs in their own arrays. Now, what do the functions need? Input? From where does that come? From a file? its 54k long array. But that's the only way I guess. So, MATLAB (the first step) : writes in a file the input signal and the online_filters structure. our code (this one) reads that file to take out iir structure and the input. Now, our code calls the iir_d...functions giving it the pointer of output array for each and supplying input. This way you get the outputs. Once you have the output, calculate the noise and then print to a file the noise and the output, this completes the second step. The third and final step would be MATLAB reading this file for noise and output and giving it to plot_psd to complete the task. The challenges that I might face:

 	1. The data is too too big, maybe that can cause problems (memory related maybe?). We'll see. 
	2. What was calculate_noise.c doing initially? The memory allocations ? If we would be skipping all that, won't it be a problem? We'll see. 

Rest is all fine I guess. File parsing in C and in MATLAB have been done previously (for other related/unrelated tasks. Now, just have to use everything nicely. Starting with step 1. */


	
	return 0;
}
