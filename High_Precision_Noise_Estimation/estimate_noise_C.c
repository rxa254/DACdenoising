#include<stdlib.h>
#include<math.h>
#include<stdio.h>


struct iir_filters
{
	int number, order;
	long double g, sos[4];
};


int main()
{
	struct 	iir_filters iir[5];
	int count=0,num,ord,j,i;
	long double signal, output_df2_longdouble, output_bqf_longdouble, noise_df2, noise_bqf;
	double output_df2,output_bqf;
	long double t, s[4];
	char dummy3;
	char dummy1[15],dummy2[15];
	FILE *fi;
	fi=fopen("take_data.txt","r");
	if(fi==NULL)
	{
		printf("\nError Reading File \n");
	}
	while(fscanf(fi, "%s", dummy1) != EOF)
	{
		fscanf(fi,"%s",dummy2);
		fscanf(fi,"%d",&num);
		iir[count].number=num;
		fscanf(fi,"%s",dummy2);
		fscanf(fi,"%d",&ord);
		iir[count].order=ord;
		fscanf(fi,"%s",dummy2);
		fscanf(fi,"%Lf",&t);
		iir[count].g=t;
		fscanf(fi,"%s",dummy2);
		//fscanf(fi,"%s",dummy2);		
		//dummy3=fgetc(fi);
		//printf("%c\n",dummy3);
		for(j=0;j<4;j++)
		{
			fscanf(fi,"%Lf",&s[j]);
			iir[count].sos[j]=s[j];
			//printf("sos: %Lf",iir.sos[i]);
		}
		//dummy3=fgetc(fi);
		//printf("%c\n",dummy3);	
		//fscanf(fi,"%s",dummy2);
		//printf("\n%d\n%d\n%Lf\n",iir.number,iir.order,iir.g);
		
		count=count+1;
		
	}
	printf("\n%d\n",count);
    for (i=1;i<=count;i++)
    {
        for(j=1;j<=sizeof(iir[i].sos);j++)
        {
            for(k=1;k<=sizeof(iir[i].sos);k++)
            {
                iir[i].sos_bqf[j][k] = 0;
            }
        }
        for(k=1;k<=sizeof(iir[i].sos);k++)
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
    for (i=1;i<=count;i++)
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
