#include<stdio.h>
#include<stdlib.h>
#include<math.h>

#include "noise_shaping_filter.c"

#define order 2 //The high pass filter SOS matrix Order

//The C function implements noise shaping to drive the DAC.
int noise_shaper(double sample, int num,double* history,double *quantErr,double *sos_shaper)
{
 
    double td,quantIn,filterOut,quantOut;
    int tdOut1,tdOut2;
    int i,j,k;
   
//define input sample
    td=sample;

// %     length(td)
   

    
    
//     pass_freq=5000;
//     [b, a] = cheby1(3, 3, pass_freq/(rate_Hz/2), 'high');
    
     //allocate table
   
    
    //print the cutoff frequency
// %     display(strcat('stop band is between ',num2str(band_stop/rate_Hz),' Hz and ',num2str(band_pass/rate_Hz),' Hz'));

    //Initialize Outputs to zero
    tdOut1=0;
    tdOut2=0;
    
//initialize history in the main function and also quantErr

//         % variant 1: ordinary quantization
    tdOut1 = (int)(td);

//         % variant 2: quantization with noise shaping
//         [filterOut, filterState] = filter(bb, a, quantErr, filterState);
        // Call iir_df2_double over here to filter the quantErr value. Change it so that it returns filterOut and filterState values, filter 
        //array has two elements one, filterOut and other is filterState
        
    filterOut=iir_filter(quantErr[num-1],sos_shaper,2,history);
        
    quantIn = td + filterOut;
    quantOut = (int)(quantIn);
    quantErr[num] = quantOut - quantIn;
    tdOut2 = quantOut;
//     end

    return tdOut2;
}

void main()
{
    double *sos_shaper,in,*history,*quantErr;
    int cutoff,i,j,k,rate_Hz,time,len;
    rate_Hz=16384;
    time=5;
    len=rate_Hz*time;
    double signal[len],output[len];
    for(i=0;i<len;i++)
    {
        signal[i]=0;
        output[i]=0;
    }
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
  
    
    
    sos_shaper = (double*) calloc(4*2+1,sizeof(double));
   
    sos_shaper[0]=-1.21288029783148e+000;    
    sos_shaper[1]=-1.00983263655467e+000;
    sos_shaper[2]=490.690130890380e-003;
    sos_shaper[3]=-479.960130094104e-003;
    sos_shaper[4]=0.00000000000000e+000;
    
    sos_shaper[5]=-1.77728706561385e+000;
    sos_shaper[6]=932.086144148644e-003;
    sos_shaper[7]=-1.81413372776837e+000;
    sos_shaper[8]=932.146816677966e-003;
    
    history= (double*) calloc(2*order,sizeof(double));
 	quantErr=(double*) calloc(len,sizeof(double));
    //initialize to zero
   
    for(k=0; k<2*order; k++) 
    {

        history[k] = 0;
        quantErr[k]=0;

    }
    cutoff=1000;
    printf("The cut off frequency for the high pass noise shaping filter is %d Hz\n",cutoff);

    for(i=0;i<len;i++)
    {
        output[i]=noise_shaper(in,i+1,history,quantErr,sos_shaper);
    }
}