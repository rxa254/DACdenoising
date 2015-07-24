int noise_shaper(double sample, int num,double* history,double *quantErr,double *sos_shaper)
{
 
    double td,quantIn,filterOut;
    int tdOut1,tdOut2,quantOut;
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
    tdOut1 = quant(td);
    
//         % variant 2: quantization with noise shaping
//         [filterOut, filterState] = filter(bb, a, quantErr, filterState);
        // Call iir_df2_double over here to filter the quantErr value. Change it so that it returns filterOut and filterState values, filter 
        //array has two elements one, filterOut and other is filterState
        
    filterOut=iir_filter(quantErr[num-1],sos_shaper,order,history);
        
    quantIn = td + filterOut;
    quantOut = quant(quantIn);
    quantErr[num] = quantOut - quantIn;
    tdOut2 = quantOut;
//     end

    return tdOut2;
}