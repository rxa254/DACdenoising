#include<stdio.h>
#include<stdlib.h>
#include<math.h>

void main()

{

	FILE *fi, *fo;
	int i;
	long double filter[5]={1.345,2.34512123,1.34512332e-4,1.23e3,1e3};
	double check[5]={1.345123123,2.345121231231,1.34512332e-4,1.23e3,1e3},data[4];
	fi=fopen("binary_write.bin","wb");
	fwrite(filter, sizeof(long double),5,fi);
	fclose(fi);
	fi=fopen("binary_write_double.bin","wb");
	fwrite(check,sizeof(double), 5, fi);
	fclose(fi);

	//Read Now
	fo=fopen("take_test.bin","rb");
	fread(data,sizeof(double),4,fo);
	for(i=0;i<4;i++)
	{
		printf("signal[%d]:%lg\n",i,data[i]);
	}
	printf("%e\n",data[0]);
}

