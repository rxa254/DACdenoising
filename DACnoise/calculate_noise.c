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

#include "filter_forms.c"

void mexFunction(int nOutput, mxArray *output[], int nInput, const mxArray *input[])
{
    int i, j;
   
    int N = mxGetM(input[0]);
    int mSos = mxGetM(input[1]);
    int nSos = mxGetN(input[1]);
    if(nSos != 4 || mSos < 1) mexErrMsgTxt("Wrong sos matrix!");
   
    double *signal = mxGetPr(input[0]);
    double **sos = (double**) malloc(mSos*sizeof(double*));
    for(i=0; i<mSos; i++) sos[i] = (double*) malloc (nSos * sizeof(double));
    for(i=0; i<mSos; i++) for(j=0; j<nSos; j++) sos[i][j] = mxGetPr(input[1])[i+mSos*j];
    double g = mxGetPr(input[2])[0];
    int key = mxGetPr(input[3])[0];

    output[0] = mxCreateDoubleMatrix(N, 1, mxREAL);
   
    if(key==0) iir_df2_single(signal, mxGetPr(output[0]), N, sos, g, mSos);
    if(key==1) iir_df2_double(signal, mxGetPr(output[0]), N, sos, g, mSos);
    if(key==2) iir_bqf_single(signal, mxGetPr(output[0]), N, sos, g, mSos);
    if(key==3) iir_bqf_double(signal, mxGetPr(output[0]), N, sos, g, mSos);
}