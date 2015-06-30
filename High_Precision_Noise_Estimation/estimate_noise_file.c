#include<stdlib.h>
#include<math.h>
#include<stdio.h>

#include "filter_forms_modified.c"

#define size 4 //hard coding the size of sos array to 4. Any Problem? No! 
//#define length 524288
//#define times 1

struct iir_filters
{
	int number, order;
	double g, **sos,**sos_bqf; 
};



long double absLD(long double n)
{
    if(n<0.0)
        n=-n;
    return n;
}
double absD(double n)
{
    if(n<0.0)
        n=-n;
    return n;
}

void main()
{
	//printf("\n\n\n\n\nEntered Loop1\n\n\n");
	//variable definitions 
	int length,iir_length;
    FILE *fi,*fo, *fs; //defining pointers to files for input file to be read and output file fo to be written
    int *len,*iir_len;
    len=&length;
    iir_len=&iir_length;
    fs=fopen("take_data_signal.bin","rb");
	if(fs==NULL)
	{
		printf("\nError Reading File Signal \n");
	}
    
    fread(len,sizeof(int),1,fs);
    fread(iir_len,sizeof(int),1,fs);
    fclose(fs);
    //printf("\n\n\n\n%d \t %d\n\n\n",length,iir_length);
    //length=length+1;
	//double **sos_bqf, **sos;
    //double sos[times][size],sos_bqf[times][size]; 
	//double **test, iir[5];
    struct iir_filters iir[iir_length];
	double *gp,*sp;
	int *num,*ord,j,i,sig,k;
    //printf("\n\n\n\n\nEntered Loop1\n\n\n");
	long double *signal, *output_df2_longdouble, *output_bqf_longdouble, *noise_df2, *noise_bqf;
    
    //printf("\n\n\n\n\nEntered Loop1\n\n\n");
	double *output_df2,*output_bqf,*noise_df2_single,*noise_bqf_single,*noise_df2_d,*noise_bqf_d;
    double *output_df2_single,*output_bqf_single;
    //printf("\n\n\n\n\nEntered Loop1\n\n\n");
	
	double *signal_d;//, output_df2_d[length],output_bqf_d[length];
  
    
    //printf("\n\n\n\n\nEntered Loop1\n\n\n")
    //double float_double=1.0e-7;
    //allocating memory dynamically to hold data of more than 7 MB, cannot be done on the stack.
    
    
    signal=(long double *)calloc(length, sizeof(long double));
    signal_d=(double *)calloc(length, sizeof(double));
    output_df2_longdouble=(long double *)calloc(length,sizeof(long double));
    output_bqf_longdouble=(long double *)calloc(length,sizeof(long double));
    noise_df2=(long double *)calloc(length,sizeof(long double));
    noise_bqf=(long double *)calloc(length,sizeof(long double));
    signal_d=(double *)calloc(length,sizeof(double));
    output_df2=(double *)calloc(length,sizeof(double));
    output_bqf=(double *)calloc(length,sizeof(double));
    
    //output_df2_single=(double *)calloc(length,sizeof(double));
    //output_bqf_single=(double *)calloc(length,sizeof(double));
    
    //noise_df2_single=(double *)calloc(length,sizeof(double));
	//noise_bqf_single=(double *)calloc(length,sizeof(double));
    
    noise_df2_d=(double *)calloc(length,sizeof(double));
	noise_bqf_d=(double *)calloc(length,sizeof(double));
    
    fi=fopen("take_data.bin","rb");
        if(fi==NULL)
        {
            printf("\nError Reading File1 \n");
        }
      
    for(i=0;i<iir_length;i++)
    {
        
        num=&iir[i].number;
        ord=&iir[i].order;
        gp=&iir[i].g; 
        //printf("\n\n\n\n\nEntered Loopx\n\n\n");
        fread(num,sizeof(int),1,fi);
        fread(ord,sizeof(int),1,fi);
        fread(gp,sizeof(double),1,fi);
        //printf("\nRead order gain and number Number: %d \t Order: %d \t Gain: %g\n",iir[i].number,iir[i].order,iir[i].g);
        
        
         //allocate table
        iir[i].sos = (double**) malloc(iir[i].order*sizeof(double*));
        iir[i].sos_bqf = (double**) malloc(iir[i].order*sizeof(double*));	
        //allocate rows		
        //printf("\n\n\n\n\nEntered Loop1\n\n\n");
        for(j=0; j<iir[i].order; j++) 
        {
            //printf("\n\n\n\n\nEntered Loop1\n\n\n");		
            iir[i].sos[j] = (double*) malloc (size * sizeof(double));
            iir[i].sos_bqf[j]=(double*) malloc (size * sizeof(double));
        } 
        
        //allocate colums and set value
        for(j=0; j<iir[i].order; j++) 
        {
            for(k=0; k<size; k++) 
            {
                //printf("\n\n\n\n\nEntered Loop1\n\n\n");			
                iir[i].sos[j][k] = 0;
               // printf("sos[%d][%d]: %g",j,k,iir[i].sos[j][k]);
                iir[i].sos_bqf[j][k] = 0;
               // printf("sos_bqf[%d][%d]: %g",j,k,iir[i].sos_bqf[j][k]);
            }
        }
        //printf("\nInitialized and allocated memory for sos, now reading values\n");
        sp=&iir[i].sos[0][0];
        //fscanf(fi,"%s",dummy2);		
        //dummy3=fgetc(fi);
        //printf("%c\n",dummy3);
        for(j=0;j<iir[i].order;j++)
        {
            //printf("\n\n\n\n\nEntered Loopy\n\n\n");
            fread(sp,sizeof(double),size,fi);
            for(k=0;k<size;k++)
            {
                //printf("\n\n\n\n\nEntered Loopz\n\n\n");
                iir[i].sos[j][k]=sp[k];
                //printf("\tsos[%d][%d]=%lf \t",j,k,iir[i].sos[j][k]);

            }
            //printf("\n\n\n\n\nEntered Loop exit for\n\n\n");
        }
        //allocate colums and set value



        //dummy3=fgetc(fi);
        //printf("%c\n",dummy3);	
        //fscanf(fi,"%s",dummy2);
        //printf("\n%d\n%d\n%Lf\n",iir.number,iir.order,iir.g);
        if(feof(fi))
        {   
            //printf("\nBreaking Loop\n");
            break;
        }
        //printf("\n\n\n\n\nEntered Loop continue\n\n\n");
    }
    fclose(fi);
       

        //allocate colums and set value
        //file read to extract signal and online_filters structure

        //printf("\n\n\n\n\nEntered Loop dd\n\n\n");
        
	

	//now reading signal

	fs=fopen("take_data_signal.bin","rb");
	if(fs==NULL)
	{
		printf("\nError Reading File2 \n");
	}
    fread(len,sizeof(int),1,fs);
    fread(iir_len,sizeof(int),1,fs);
	//printf("\n%dlen=\n",length);
	fread(signal_d,sizeof(double),length,fs);
       
	fclose(fs);
    
    /*printf("\nPrinting Signal from 1 to 10\n");
    for(i=0;i<10;i++)
	{
	
        printf("\t%g",signal_d[i]);
			
	}*/
	
	
	//printf("\nsig = %d\n",length);
	
	
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
	       // iir[i].sos_bqf = zeros(size(iir(i).sos)); //initiate sos_bqf array as an element of structure iir_filters with all zeros. 			

		for(k=0;k<times;k++)
		{

		        iir[i].sos_bqf[k][0] = -iir[i].sos[k][0] - 1; //start filling in values of sos_bqf
		        iir[i].sos_bqf[k][1] = -iir[i].sos[k][0] - iir[i].sos[k][1] - 1;
		        iir[i].sos_bqf[k][2] = iir[i].sos[k][2] - iir[i].sos[k][0];
		        iir[i].sos_bqf[k][3] = iir[i].sos[k][3] - iir[i].sos[k][1] + iir[i].sos[k][2] - iir[i].sos[k][0];
		}
	}
    
	  // iir[i].sos_bqf = zeros(size(iir(i).sos)); //initiate sos_bqf array as an element of structure iir_filters with all zeros. 			
  	*/
	//printf("\n\n\n\n\nEntered Loop1\n\n\n");
	for(i=0;i<iir_length;i++)
	{	
        //printf("\n\n\n\n\nEntered Loop2\n\n\n");
        for(j=0; j<iir[i].order; j++)
        {
                //printf("\n\n\n\n\nEntered Loop3\n\n\n");
                iir[i].sos_bqf[j][0] = -iir[i].sos[j][0] - 1; //start filling in values of sos_bqf
                //printf("\n\n\n\n\nEntered Loop4\n\n\n");
                iir[i].sos_bqf[j][1] = -iir[i].sos[j][0] - iir[i].sos[j][1] - 1;
                iir[i].sos_bqf[j][2] = iir[i].sos[j][2] - iir[i].sos[j][0];
                iir[i].sos_bqf[j][3] = iir[i].sos[j][3] - iir[i].sos[j][1] + iir[i].sos[j][2] - iir[i].sos[j][0];
                //printf("\n\n\n\n\nEntered Loop5\n\n\n");
        }
        //printf("\n\n\n\n\nEntered Loop6\n\n\n");
	}
    /*
    for(i=0;i<iir_length;i++)
    {
        for(k=0; k<iir[i].order; k++) 
        {
            //printf("\n\n\n\n\nEntered Loop7\n\n\n");
            for(j=0; j<size; j++) 
            {

                //printf("sos_bqf: %lf\n",iir[i].sos_bqf[k][j]);
                printf("sos[%d][%d]: %g\t",k,j,iir[i].sos[k][j]);
                printf("sos_bqf[%d][%d]: %g\t",k,j,iir[i].sos_bqf[k][j]);
            }
            printf("\n");
        }
        printf("\nNext\n");
    }
 	*/
	

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
       
		signal[i]=signal_d[i];
        output_df2_longdouble[i]=signal[i];
        output_bqf_longdouble[i]=signal[i];
        output_df2[i]=signal_d[i];
        output_bqf[i]=signal_d[i];
        
		//output_df2_d[i]=(double)output_df2[i];
		//output_bqf_d[i]=(double)output_bqf[i];
	}
	for (i=0; i<iir_length; i++)
	{
        //printf("\n\n\n\n\nEntered Loop calling funcnow1\n\n\n");
        iir_df2_longdouble(output_df2_longdouble, output_df2_longdouble, length, iir[i].sos, iir[i].g, iir[i].order);
        //printf("\n\n\n\n\nEntered Loop calling funcnow12\n\n\n");
        iir_df2_double(output_df2, output_df2, length,iir[i].sos, iir[i].g, iir[i].order);
        iir_bqf_longdouble(output_bqf_longdouble, output_bqf_longdouble, length, iir[i].sos_bqf, iir[i].g, iir[i].order);
        iir_bqf_double(output_bqf, output_bqf, length, iir[i].sos_bqf, iir[i].g, iir[i].order);
        //iir_df2_single(signal_d,output_df2_single,length,sos,g,times);
        //iir_bqf_single(signal_d,output_bqf_single,length,sos,   g,times);
        //printf("\n\n\n\n\nEntered Loop calling funcnow13\n\n\n");
	}
    /*
    printf("\nPrinting output from 1 to 10\n");
    for(i=0;i<10;i++)
	{
	
        printf("\t%g",output_df2[i]);
        printf("\t%g",output_bqf[i]);
			
	}*/
    //Calculate filter noise
	for(i=0;i<length;i++)
    {
        	//printf("\n\n\n\n\nEntered Loop assigning noise now5\n\n\n");
        	noise_df2[i] = output_df2_longdouble[i] - output_df2[i];
        	noise_bqf[i] = output_bqf_longdouble[i] - output_bqf[i];
        	//noise_df2_single[i]=float_double*(output_df2_single[i]-output_df2[i]);
        	//noise_bqf_single[i]=float_double*(output_bqf_single[i]-output_bqf[i]);
            noise_df2_d[i]=(double)noise_df2[i];
            noise_bqf_d[i]=(double)noise_bqf[i];
	}
	/*Write outputs to file, viz. the outputs and the noises. This file give_data.txt will be read by matlab. 
     Hence, file names have been used with reference to C code and not matlab */
	//printf("\n%lf\n",output_df2[1]);
	//printf("\n%lf\n",output_bqf[1]);
	//printf("\n%Lf\n",absLD(noise_df2[1]));
	//printf("\n%Lf\n",absLD(noise_bqf[1]));
	fo=fopen("give_data.bin","wb");
	//printing output of df2 to the file
    
    printf("\n\nWriting Back to file\n");
    fwrite(output_df2,sizeof(double),length,fo);

    fwrite(output_bqf,sizeof(double),length,fo);

    fwrite(noise_df2_d,sizeof(double),length,fo);

    fwrite(noise_bqf_d,sizeof(double),length,fo);

    //fprintf(fo,"%lf\n",float_double);

    //fprintf(fo,"%lf\n",noise_bqf_single[i]);
	
		
	fclose(fo);
    printf("Noise Calculation Completed with High Precision\n");
	
/*The plan is to get long double output from the filter_modified.c file. Then calculate noise using the double and the long double output in this code, 
 * finally printing out double output (or long double) and noise to a file which then matlab will read. When to call which function? You have to call 
 * all of them, one by one, storing their outputs in their own arrays. Now, what do the functions need? Input? From where does that come?
 * From a file? its 54k long array. But that's the only way I guess. So, MATLAB (the first step) : writes in a file 
 * the input signal and the online_filters structure. our code (this one) reads that file to take out iir structure and the input.
 * Now, our code calls the iir_d...functions giving it the pointer of output array for each and supplying input. This way you get the outputs.
 * Once you have the output, calculate the noise and then print to a file the noise and the output, this completes the second step. 
 * The third and final step would be MATLAB reading this file for noise and output and giving it to plot_psd to complete the task. 
 *The challenges that I might face:

 	1. The data is too too big, maybe that can cause problems (memory related maybe?). We'll see. 
	2. What was calculate_noise.c doing initially? The memory allocations ? If we would be skipping all that, won't it be a problem? We'll see. 

Rest is all fine I guess. File parsing in C and in MATLAB have been done previously (for other related/unrelated tasks. Now, just have to use everything nicely. Starting with step 1. */


	
// 	return 0;
}
