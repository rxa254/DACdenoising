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
	struct 	iir_filters iir;
	int count=0,num,ord,i;
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
		iir.number=num;
		fscanf(fi,"%s",dummy2);
		fscanf(fi,"%d",&ord);
		iir.order=ord;
		fscanf(fi,"%s",dummy2);
		fscanf(fi,"%Lf",&t);
		iir.g=t;
		fscanf(fi,"%s",dummy2);
		//fscanf(fi,"%s",dummy2);		
		//dummy3=fgetc(fi);
		//printf("%c\n",dummy3);
		for(i=0;i<4;i++)
		{
			fscanf(fi,"%Lf",&s[i]);
			iir.sos[i]=s[i];
			//printf("sos: %Lf",iir.sos[i]);
		}
		//dummy3=fgetc(fi);
		//printf("%c\n",dummy3);	
		//fscanf(fi,"%s",dummy2);
		//printf("\n%d\n%d\n%Lf\n",iir.number,iir.order,iir.g);
		count=count+1;
	}
	printf("\n%d\n",count);
	fclose(fi);
	return 0;
}	
