
#include <stdlib.h>

double iir_df2_double(double input, double **sos, double g, int n)
{
    int i,j;
    double **w = malloc(n*sizeof(double*));
    for(i=0; i<n; i++) w[i] = malloc (3 * sizeof(double));
    for(i=0; i<n; i++) for(j=0; j<3; j++) w[i][j] = 0;

    double out;

//     for(j=0; j<s; j++) {
        out = g*input;

        for(i=0; i<n; i++) {
            w[i][2] = w[i][1];
            w[i][1] = w[i][0];
            w[i][0] = out - sos[i][0]*w[i][1] - sos[i][1]*w[i][2];
            out = w[i][0] + sos[i][2]*w[i][1] + sos[i][3]*w[i][2];
            printf("\t%g",out);
        }
//         output[j] = out;
//     }
    return out;
}

inline double iir_filter(double input,double *coef,int n,double *history)
{

  int i;
  double *coef_ptr;
  double *hist1_ptr,*hist2_ptr;
  double output,new_hist,history1,history2;

  coef_ptr = coef;                /* coefficient pointer */
  
  hist1_ptr = history;            /* first history */
  hist2_ptr = hist1_ptr + 1;      /* next history */
  
  output = input * (*coef_ptr++); /* overall input scale factor */
  
  for(i = 0 ; i < n ; i++) {
    
    history1 = *hist1_ptr;        /* history values */
    history2 = *hist2_ptr;
    
    
    output = output - history1 * (*coef_ptr++);
    new_hist = output - history2 * (*coef_ptr++);    /* poles */
    
    output = new_hist + history1 * (*coef_ptr++);
    output = output + history2 * (*coef_ptr++);      /* zeros */

    *hist2_ptr++ = *hist1_ptr;
    *hist1_ptr++ = new_hist;
    hist1_ptr++;
    hist2_ptr++;
    
  }
  
  return(output);
}
