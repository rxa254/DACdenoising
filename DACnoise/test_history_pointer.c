#include<stdio.h>

void main()
{


int i,k,order=1;
  double *coef_ptr;
  double *hist1_ptr,*hist2_ptr;
  double output,new_hist,history1,history2;

 double *history;
   
    for(k=0; k<2*order; k++) 
    {

        history[k] = 0;
      

    }
    history[0]=1.5;
    history[1]=2;
  
  hist1_ptr = history;            /* first history */
	
	
   for(k=0; k<2*order; k++) 
    {

        printf("\n%g",hist1_ptr[k]);
      

    }
    hist1_ptr[0]=123;
    hist1_ptr[1]=2345;
      for(k=0; k<2*order; k++) 
    {

        printf("\n%g",hist1_ptr[k]);
      

    }  for(k=0; k<2*order; k++) 
    {

        printf("\n%g",history[k]);
      

    }
    
    
    }
