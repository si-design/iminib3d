/*
 *  quaternion.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef QUATERNION_H
#define QUATERNION_H

#include "matrix.h"

void QuatToMat(float w,float x,float y,float z,Matrix& mat);
void QuatToEuler(float w,float x,float y,float z,float &pitch,float &yaw,float &roll);
void Slerp(float Ax,float Ay,float Az,float Aw,float Bx,float By,float Bz,float Bw,float& Cx,float& Cy,float& Cz,float& Cw,float t);

#endif