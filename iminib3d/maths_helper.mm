/*
 *  maths_helper.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "maths_helper.h"

double cosdeg(double degrees)
{
	return cos(deg2rad(degrees));
}

double sindeg(double degrees)
{
	return sin(deg2rad(degrees));
}

double tandeg(double degrees)
{
	return tan(deg2rad(degrees));
}

double acosdeg(double val)
{
	return rad2deg(acos(val));
}

double asindeg(double val)
{
	return rad2deg(asin(val));
}

double atandeg(double val)
{
	return rad2deg(atan(val));
}

double atan2deg(double val,double val2)
{
	return rad2deg(atan2(val,val2));
}

float InvSqrt(float x)
{
	union {
		float f;
		int i;
	} tmp;
	tmp.f = x;
	tmp.i = 0x5f3759df - (tmp.i >> 1);
	float y = tmp.f;
	return y * (1.5f - 0.5f * x * y * y);
}