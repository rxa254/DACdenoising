#include<stdlib.h>
#include<math.h>
#include<stdio.h>




void noise_try_estimate(long double* signal,struct iir iir, long double* output_df2_longdouble,long double* output_bqf_longdouble,long double* noise_df2,long double* noise_bqf)
{
    int n_iir,i,j,k;
    long double* output_df2, output_bqf;
    n_iir=length(iir);
    printf("Signal length is : %d",n_iir);
  
    for (i=1;i<=n_iir;i++)
    {
        for(j=1;j<=size(iir[i].sos);j++)
        {
            for(k=1;k<=size(iir[i].sos);k++)
            {
                iir[i].sos_bqf[j][k] = 0;
            }
        }
        for(k=1;k<=size(iir(i).sos);k++)
        {
                iir[i].sos_bqf[k][1]= -iir[i].sos[k][1] - 1;
	        iir[i].sos_bqf[k][2] = -iir[i].sos[k][1] - iir[i].sos[k][2] - 1;
	        iir[i].sos_bqf[k][3] = iir[i].sos[k][3] - iir[i].sos[k][1];
	        iir[i].sos_bqf[k][4] = iir[i].sos[k][4] - iir[i].sos[k][2] + iir[i].sos[k][3] - iir[i].sos[k][1];
	}

    }
    
    output_df2_longdouble = signal;
    output_df2 = signal;
    output_bqf_longdouble = signal;
    output_bqf = signal;

    //Calculate output from the filter bank using df2 and bqf, single
    //changed to long double
    for (i=1;i<=n_iir;i++)
    {
        output_df2_longdouble = calculate_noise(output_df2_longdouble, iir[i].sos, iir[i].g, 0);
        output_df2 = calculate_noise(output_df2, iir[i].sos, iir[i].g, 1);
        output_bqf_longdouble = calculate_noise(output_bqf_longdouble, iir[i].sos_bqf, iir[i].g, 2);
        output_bqf = calculate_noise(output_bqf, iir[i].sos_bqf, iir[i].g, 3);
        
    }
       
   //Calculate filter noise
        
        noise_df2 = output_df2- output_df2_longdouble;
        noise_bqf = output_bqf- output_bqf_longdouble;
// [output_df2, output_bqf, noise_df2, noise_bqf] 
}

