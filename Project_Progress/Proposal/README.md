The folder consists of .tex files and other supporting files which constitute the Project Report for the project titled:
**Quantization Noise in Digital Control Systems**. 

The image folder consists of the .jpeg files used for diagrams in the report.

***
Some Issues:
 1. There should be a table of contents in the report.
 1. Use vector graphics (like SVG or PDF)
 1. I think the ADC quantization operation is not actually 'round' but instead something like 'floor'. Is this true?
 1. Please give us a calculation which recovers the classic expression for the quantization noise of an ADC. i.e. proportional to 1/sqrt(12 *f_sample)
 1. Then we want to have a numerical (matlab) simulation which reproduces the same noise spectrum to make sure that we are doing this OK.
 2. Then we want to change the characteristics of the dither noise to change the shape of the digitized noise.


*****
********
This is the Acknowledgement for all the issues you have raised! I'll come up with the changes and additions asap.

Added to that, I have completed the following: (already pushed before reading your comments, so please wait until I push again with the changes you have suggested)

1. ADC Noise Shaping Derivations 
2. Simlation in Simulink for Sigma Delta architecture design of an ADC
3. Frequency Spectrum for the same (of the error, noise shaped)
4. LaTeX document covering all the above.

***
Update (on 25th May): All changes mentioned above have been made and pushed.
