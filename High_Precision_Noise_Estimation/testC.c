#include<stdio.h>
#include<stdlib.h>
#include<math.h>

void main()

{

	FILE *fi, *fo;
	int i,j;
	long double filter[5]={1.345,2.34512123,1.34512332e-4,1.23e3,1e3};
	double check[5]={1.345123123,2.345121231231,1.34512332e-4,1.23e3,1e3},data[4],sos[2][4];
// 	fi=fopen("binary_write.bin","wb");
// 	fwrite(filter, sizeof(long double),5,fi);
// 	fclose(fi);
// 	fi=fopen("binary_write_double.bin","wb");
// 	fwrite(check,sizeof(double), 5, fi);
// 	fclose(fi);

	//Read Now
	fo=fopen("test.bin","rb");
	
	for(i=0;i<2;i++)
	{
        fread(data,sizeof(double),4,fo);
        for(j=0;j<4;j++)
        {
            sos[i][j]=data[j];
            printf("sos[%d][%d]:%g\n%lf",i,j,sos[i][j],sos[0][2]-1.24242);
        }
	}
	//printf("%e\n",data[0]);
}
