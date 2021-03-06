#include<stdio.h>

#define size 4
void iir_bqf_double(double* input, double* output, int s, double **sos, double g, int n)
{
    int i,j;

    double **w = (double **) malloc(n*sizeof(double*));
    for(i=0; i<n; i++) w[i] = (double *)malloc (2 * sizeof(double));
    for(i=0; i<n; i++) for(j=0; j<2; j++) w[i][j] = 0;

    double **u = malloc(n*sizeof(double*));
    for(i=0; i<n; i++) u[i] = malloc (2 * sizeof(double));
    for(i=0; i<n; i++) for(j=0; j<2; j++) u[i][j] = 0;

    double out;

    for(j=0; j<s; j++) {
        out = g*input[j];
        for(i=0; i<n; i++) {
            w[i][1] = w[i][0];
            u[i][1] = u[i][0];
            w[i][0] = out + sos[i][0]*w[i][1] + sos[i][1]*u[i][1];
            u[i][0] = w[i][1] + u[i][1];
            out += sos[i][2]*w[i][1] + sos[i][3]*u[i][1];
        }
        output[j] = out;
    }
}
void iir_df2_double(double* input, double* output, int s, double **sos, double g, int n)
{
    int i,j;
    double **w = malloc(n*sizeof(double*));
    for(i=0; i<n; i++) w[i] = malloc (3 * sizeof(double));
    for(i=0; i<n; i++) for(j=0; j<3; j++) w[i][j] = 0;

    double out;

    for(j=0; j<s; j++) {
        out = g*input[j];
        for(i=0; i<n; i++) {
            w[i][2] = w[i][1];
            w[i][1] = w[i][0];
            w[i][0] = out - sos[i][0]*w[i][1] - sos[i][1]*w[i][2];
            out = w[i][0] + sos[i][2]*w[i][1] + sos[i][3]*w[i][2];
        }
        output[j] = out;
    }
}

void invert_df2_double(double* input, double* output, int s, double **sos, double g, int n)
{
    int i,j;
    double **w = malloc(n*sizeof(double*));
    for(i=0; i<n; i++) w[i] = malloc (3 * sizeof(double));
    for(i=0; i<n; i++) for(j=0; j<3; j++) w[i][j] = 0;

    double in;

    for(j=0; j<s; j++) {
       // out = g*input[j];
        in=output[j];
        
        for(i=0; i<n; i++) {
         	in = w[i][0] - sos[i][2]*w[i][1] - sos[i][3]*w[i][2];
         	w[i][0] = in + sos[i][0]*w[i][1] + sos[i][1]*w[i][2];
         	w[i][1] = w[i][0];
            w[i][2] = w[i][1];
            
            
           
        }
       // output[j] = out;
       input[j]=in/g;
    }
}

void invert_bqf_double(double* input, double* output, int s, double **sos, double g, int n)
{
    int i,j;

    double **w = (double **) malloc(n*sizeof(double*));
    for(i=0; i<n; i++) w[i] = (double *)malloc (2 * sizeof(double));
    for(i=0; i<n; i++) for(j=0; j<2; j++) w[i][j] = 0;

    double **u = malloc(n*sizeof(double*));
    for(i=0; i<n; i++) u[i] = malloc (2 * sizeof(double));
    for(i=0; i<n; i++) for(j=0; j<2; j++) u[i][j] = 0;

    double in;

    for(j=0; j<s; j++) {
        //out = g*input[j];
        in=output[j];
        for(i=0; i<n; i++) {
    	 	in=in-sos[i][2]*w[i][1]-sos[i][3]*u[i][1];
    	 	
    	  	w[i][0] = in + sos[i][0]*w[i][1] + sos[i][1]*u[i][1];
    	  	u[i][0] = w[i][1] + u[i][1];
    	    u[i][1] = u[i][0];
            w[i][1] = w[i][0];
            
          
            
           
            
            //out = out + sos[i][2]*w[i][1] + sos[i][3]*u[i][1];
           
        }
        //output[j] = out;
        input[j]=in/g;
    }
}
void main()
{
	int length=10,gain=2,number=1,order=2;
	int i,j;
	double *input,*output;
	double **sos=(double **)malloc(order*(sizeof(double *)));
	input=(double *)calloc(length, sizeof(double));
	output=(double *)calloc(length, sizeof(double));
	for(i=0;i<order;i++) sos[i]=(double *)malloc(size*sizeof(double));
	for(i=0;i<order;i++) {
		for(j=0;j<size;j++) sos[i][j]=0;
	}
	sos[0][0]=0;
	sos[0][1]=1;
	sos[0][2]=2;
	sos[0][3]=3;
	sos[1][0]=4;
	sos[1][1]=5;
	sos[1][2]=6;
	sos[1][3]=7;
	
	input[0]=0.1;
	input[1]=0.2;
	input[2]=0.3;
	input[3]=0.4;
	input[4]=0.5;
	input[5]=0.6;
	input[6]=0.7;
	input[7]=0.8;
	input[8]=0.9;
	input[9]=1;
	/*
	output[0]=0.2;
	output[1]=2;
	output[2]=13;
	output[3]=73.2;
	output[4]=391.2;
	output[5]=2051.6;
	output[6]=10688.6;
	output[7]=55562;
	output[8]=288612;
	output[9]=1.49881e+06;
	*/
	iir_df2_double(input,output,length,sos,gain,order);
	for(i=0;i<length;i++)
	{
		//printf("%g\t",input[i]);
		printf("%g\t",output[i]);
	}
	invert_df2_double(input,output,length,sos,gain,order);
	for(i=0;i<length;i++)
	{
		printf("%g\t",input[i]);
		//printf("%g\t",output[i]);
	}
	
}
