#include<stdio.h>
#include<stdlib.h>
#include<math.h>
int main()
{
	double a,d;
	long double c,b;
	//float a=0,b=0;
	a=1;
	b=sqrt(2);
	d=a/b;
	c=a/b;
	printf("%g %e %Le",a,d,c);
	if((d-c) == 0)
	{
		printf("\nzero");
	}		
	//return 0;	
}
