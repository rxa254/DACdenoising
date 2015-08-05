
//The call should look like: noise_shaper(input,history,&quantErr,sos_shaper)


int noise_shaper(double sample,double *history,double *quantErr, double *sos_shaper,int order)
{
    //**************************************************//
    //sos_shaper is the coefficients array having 4*order + 1 elements (gain) ,
    //Gain is the first element, and the coefficients need to be defined in the main function before calling this shaper function
    //initialize and allocate memory for history in the main function and also quantErr
    //***********************************************//
                          
    double quantIn,filterOut;
    int quantOut=0;
    //filtering noise
    filterOut=iir_filter(*quantErr,sos_shaper,order,history); //need to replace the order variable with the appropriate variable in the main code.
    quantIn = sample + filterOut;
      /// - ---- Smooth out some of the double > short roundoff errors                                                         
    if(quantIn > 0.0) quantIn += 0.5;
    else quantIn -= 0.5;
    quantOut = quantIn;

//     quantOut = quant(quantIn);
    *quantErr= quantOut - quantIn; //noise updated
//     tdOut2 = quantOut;
    return quantOut;
}
