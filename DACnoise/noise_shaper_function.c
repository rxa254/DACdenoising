
//The call should look like: noise_shaper(input,history,&quantErr,sos_shaper)

#include<math.h>
#include<stdio.h>
#include "noise_shaping_filter.c"

#define order 2

int noise_shaper(double sample,double *history,double *quantErr, double *sos_shaper)
{
    //**************************************************//
    //sos_shaper is the coefficients array having 4*order + 1 elements (gain) ,
    //Gain is the first element, and the coefficients need to be defined in the main function before calling this shaper function
    //initialize and allocate memory for history in the main function and also quantErr
    //***********************************************//
    
    double quantIn,filterOut;
    int tdOut2=0,quantOut;
    //filtering noise
    filterOut=iir_filter(*quantErr,sos_shaper,order,history);
    printf("%f\n",*quantErr);
    quantIn = sample + filterOut;
    quantOut = quant(quantIn);
    *quantErr= quantOut - quantIn; //noise updated
    tdOut2 = quantOut;
    return tdOut2;
}

//The quant function can be replaced by another quantizer model 
double quant(double in)
{

    int out;

    out=(int)in;
    
    return out;
}