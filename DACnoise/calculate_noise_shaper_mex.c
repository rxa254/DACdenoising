/*=============================================================================*\
Compile with
>> mex calculate_noise.c
\*=============================================================================*/

#include <stdio.h>
#include "mex.h"
#include <math.h>

/*===========================================================================*\
  Sos implementation
\*===========================================================================*/

#include "noise_shaping_filter.c"

void mexFunction(int nOutput, mxArray *output[], int nInput, const mxArray *input[])
{
    int i, j,order;
    int N = mxGetM(input[0]);
    double *out;
    int mSos = mxGetM(input[1]);
    int nSos = mxGetN(input[1]);
    order=(mxGetPr(input[2])[0]);
    /*printf("%d \t %d",mSos,nSos); */
    /*size of coef matrix will be twice n added one
    ///The first element would be gain. */
    if(nSos != (4*order+1) || mSos != 1) mexErrMsgTxt("Wrong sos matrix!");
   
    double signal = mxGetPr(input[0])[0]; 
    double *sos= mxGetPr(input[1]); 
    double *history= mxGetPr(input[3]); 
    output[0] = mxCreateDoubleMatrix(N, 1, mxREAL);
    out=mxGetPr(output[0]);
    out[0]=iir_filter(signal, sos,order,history);
}