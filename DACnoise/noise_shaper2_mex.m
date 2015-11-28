function output= noise_shaper2_mex(signal,sos,order,history)
    output = calculate_noise(signal,sos,order,history);      
end
