#include<stdio.h>
#include<stdlib.h>
#include<math.h>

void main()
{

	long double float_longdouble;
	double float_double;
	float float_single;
	float_longdouble=1.123213435e-120;
	float_double=1.33432321e-120;
	float_single=1.0e-22;
	printf("\nLD: %Lg \t D: %lg \t D2: %g \t S: %f \t Diff: %g \n",float_longdouble,float_double,float_double,float_single,1e42*float_double);
}

