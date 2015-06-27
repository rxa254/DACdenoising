/*=============================================================================*\
Compile with
>> mex estimate_test.c
\*=============================================================================*/

#include <stdio.h>
#include "mex.h"
#include <math.h>

/*===========================================================================*\
  Estimating Noise using Long double
\*===========================================================================*/

#include "noise_try_estimate.c"

void mexFunction(int nlhs, mxArray *output[], //output variable
				int nrhs, const mxArray *input[]) //input variables
{
	mexPrintf("Entered into MEX function!\n");
  //  int i, j;
    int N = mxGetM(input[0]);
    //int mSos = mxGetM(input[1]);
    //int nSos = mxGetN(input[1]);
    //if(nSos != 4 || mSos < 1) mexErrMsgTxt("Wrong sos matrix!");
   
    long double *signal = mxGetPr(input[0]);
 	long double *iir = mxGetData(input[1]);
   // double **sos = (double**) malloc(mSos*sizeof(double*));
   // for(i=0; i<mSos; i++) sos[i] = (double*) malloc (nSos * sizeof(double));
   // for(i=0; i<mSos; i++) for(j=0; j<nSos; j++) sos[i][j] = mxGetPr(input[1])[i+mSos*j];
   // double g = mxGetPr(input[2])[0];
   // int key = mxGetPr(input[3])[0];

    output[0] = mxCreateDoubleMatrix(N, 1, mxREAL);
    output[1] = mxCreateDoubleMatrix(N, 1, mxREAL);
    output[2] = mxCreateDoubleMatrix(N, 1, mxREAL);
    output[3] = mxCreateDoubleMatrix(N, 1, mxREAL);
    output_df2_longdouble=mxGetPr(output[0]);
    output_bqf_longdouble=mxGetPr(output[1]);
    noise_df2=mxGetPr(output[2]);
    noise_bqf=mxGetPr(output[3]);
       
   
	noise_try_estimate(signal, iir, output_df2_longdouble, output_bqf_longdouble, noise_df2, noise_bqf)
}