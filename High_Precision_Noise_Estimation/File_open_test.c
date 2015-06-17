#include<stdlib.h>
#include<math.h>
#include<stdio.h>

void main()
{

FILE *fi;
	fi=fopen("\home\ayush\DACdenoising\High_Precision_Noise_Estimation\take_data.txt","r");
	if(fi==NULL)
	{
		printf("\nError Reading File \n");
	}
	while(!feof(fi))
	{
		count=count+1;
	}

return 0;
}
