#include<stdio.h>
#include<stdlib.h>
#include<math.h>

#include "noise_shaping_filter.c"

#define order 2 //The high pass filter SOS matrix Order

double quant(double in)
{
    //clipping quantizer model for 18bit conversion from double to drive the DAC
    int out;
    if(in>=pow(2,17)-1)
    {
        out=(int)(pow(2,17)-1);
        printf("Clipping11\n");
    }
    else if (in<=-pow(2,17))
    {
        out=(int)-pow(2,17);
        printf("Clipping\n");
    }
    else
    {
        if(in<0)
        {
            out=(int)(in-0.5);
        }
        else
        {
            out=(int)(in+0.5);
        }
    }
//         out=(int)in;
    
    return out;
}
//The C function implements noise shaping to drive the DAC.
int noise_shaper(double sample, int num,double* history,double *quantErr,double *sos_shaper)
{
    
    double quantIn,filterOut;
    int tdOut2,quantOut;


// %     length(td)
   
    //initialize to zero, output.
    tdOut2=0;
    
//initialize history in the main function and also quantErr


//         % variant 2: quantization with noise shaping
//         [filterOut, filterState] = filter(bb, a, quantErr, filterState);
        // Call iir_df2_double over here to filter the quantErr value. Change it so that it returns filterOut and filterState values, filter 
        //array has two elements one, filterOut and other is filterState
    if(num==0) quantErr[num-1]=0;
    filterOut=iir_filter(quantErr[num-1],sos_shaper,order,history);
        
    quantIn = sample + filterOut;
 
//     quantIn = sample + quantErr[num];
   
    quantOut = quant(quantIn);
    quantErr[num] = quantOut - quantIn;
    tdOut2 = quantOut;
//     end

    return tdOut2;
    
}

void main()
{
    double *sos_shaper,*history,*quantErr,*sos_bqf;
    int cutoff,i,j,k,rate_Hz,time,len;
    rate_Hz=16.384e3;
    time=32;
    len=rate_Hz*time;
    double *signal;
    int output[len];
    
    signal = (double*) calloc(len,sizeof(double));
//     output = (int*) calloc(len,sizeof(double));
    
    for(i=0;i<len;i++)
    {
        signal[i]=0;
        output[i]=0;
    }
    FILE *fp,*fo;
    fp=fopen("take_signal_shape.bin","rb");
    if(fp==NULL)
	{
		printf("\nError Reading File Signal \n");
	}
    
    fread(signal,sizeof(double),len,fp);
    fclose(fp);
//     for(i=0;i<10;i++)
//     {
//        printf("%e\t",signal[i]);
// //         output[i]=0;
//     }
    //     % *********************************************
//     % Design a filter that reflects the shape of the desired
//     % noise spectrum
//     % *********************************************    


// Write the specifications

    //Define sos matrix here for
//     sos = (double*) calloc(4*2+1,sizeof(double));
    //iir[i].sos_bqf = (double**) malloc(iir[i].order*sizeof(double*));	
    //allocate rows		
//  	sos[0]=410.403788879422e-003;		
//     sos[1] = -1.77728706561384e+000;
//     sos[2]=932.086144148631e-003;
//     sos[3]=-2.00000000000000e+000;
//     sos[4]=1.00000000000000e+000;
// 
//     sos[5]=-1.00983263655468e+000;
//     sos[6]=490.690130890386e-003;
//     sos[7]=-2.00000000000000e+000;
//     sos[8]=1.00000000000000e+000;
    //     % *********************************************
//     % Derive the noise shaper filter from the desired
//     % noise frequency response
//     % Note: a unit delay is removed by shortening bb.
//     % *********************************************    
    //Derive the H_{shaper} from H_{target} defined above. So, basically, you have to change the SOS matrix over here. 
//     bb = b / b(1);
//     bb = bb(2:end) - a(2:end);
  

    sos_shaper = (double*) calloc(4*order+1,sizeof(double));
    sos_bqf = (double*) calloc(4*order+1,sizeof(double));
    for(i=0;i<4*order+1;i++)
    {
        sos_shaper[i]=0;
        sos_bqf[i]=0;
    }
    
    /**********High Pass Filter **********/
       
    sos_shaper[0]= -7.26916646278976e+000;    
    sos_shaper[1]=1.69678853197248e+000;
    sos_shaper[2]=768.485604426078e-003;
    sos_shaper[3]=-45.7163559823221e-003;
    sos_shaper[4]=0.00000000000000e+000;
    sos_shaper[5]=1.57237793081728e+000;
    sos_shaper[6]=903.801801036295e-003;
    sos_shaper[7]=-182.606899798957e-003;
    sos_shaper[8]=919.118647398404e-003;
    
    /*********Notch Shaping filter at around 1kHz ***********/
    
//     sos_shaper[0]= -175.452722729356e-003;
//     sos_shaper[1]=-1.76364342887013e+000;
//     sos_shaper[2]=838.759683598930e-003;
//     sos_shaper[3]=-1.04259152020130e+000;
//     sos_shaper[4]=0.00000000000000e+000;
//     sos_shaper[5]=-1.89110415579484e+000;
//     sos_shaper[6]=989.854849734713e-003;
//     sos_shaper[7]=-1.88487386166615e+000;
//     sos_shaper[8]=981.415668736020e-003;
//     sos_shaper[9]=-1.92469015904608e+000;
//     sos_shaper[10]=991.610502124898e-003;
//     sos_shaper[11]=-1.91642029410082e+000;
//     sos_shaper[12]=984.342490934734e-003;
    

//     sos_shaper[0]=-1.21288029783148e+000;    
//     sos_shaper[1]=-1.00983263655467e+000;
//     sos_shaper[2]=490.690130890380e-003;
//     sos_shaper[3]=-479.960130094104e-003;
//     sos_shaper[4]=0.00000000000000e+000;
//     
//     sos_shaper[5]=-1.77728706561385e+000;
//     sos_shaper[6]=932.086144148644e-003;
//     sos_shaper[7]=-1.81413372776837e+000;
//     sos_shaper[8]=932.146816677966e-003;
//     
    sos_bqf[0]=sos_shaper[0];
    sos_bqf[1] = sos_shaper[1] - 1;
    sos_bqf[2] =sos_shaper[1] - sos_shaper[2] - 1;
    sos_bqf[3] = sos_shaper[3] - sos_shaper[1];
    sos_bqf[4] =sos_shaper[4] - sos_shaper[2] + sos_shaper[3] -sos_shaper[1];
    sos_bqf[5] = sos_shaper[5] - 1; 
    sos_bqf[6] =sos_shaper[5] - sos_shaper[6] - 1;
    sos_bqf[7] = sos_shaper[7] - sos_shaper[5];
    sos_bqf[8] =sos_shaper[8] - sos_shaper[6] + sos_shaper[7] -sos_shaper[5];

    history= (double*) calloc(2*order,sizeof(double));
 	quantErr=(double*) calloc(len-1,sizeof(double));
    //initialize to zero
   
    for(k=0; k<2*order; k++) 
    {

        history[k] = 0;
      

    }
    for(k=0; k<len; k++) 
    {

       quantErr[k] = 0;
      

    }
//     cutoff=100;
//     printf("The cut off frequency for the high pass noise shaping filter is %d Hz\n",cutoff);

    for(i=0;i<len;i++)
    {
        if(i<len)
        {
        output[i]=noise_shaper(signal[i],i,history,quantErr,sos_shaper);
        }
    }
    for(i=0;i<10;i++)
    {
       printf("%e\t",signal[i]);
       printf("%d\t",output[i]);
//         output[i]=0;
    }
//     for(i=0;i<len;i++)
//     {
//         err[i]=output[i]-signal[i];
//     }
    fo=fopen("shaped_out.txt","w");
	//printing output of df2 to the file
    if(fo==NULL)
	{
		printf("\nError Reading File Signal \n");
	}
    printf("\n\nWriting Back to file\n");
    for(i=0;i<len;i++)
    {
        fprintf(fo,"%d\n",output[i]);
    }
	fclose(fo);
    printf("Noise shaping completed and output written to file for debugging\n");
	
}