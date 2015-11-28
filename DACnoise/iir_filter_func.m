function output=iir_filter_func(input,coef,n,history)
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

}
