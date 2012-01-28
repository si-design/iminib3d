/*
 *  matrix.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "maths_helper.h"

#include <cmath>
using namespace std;

#ifndef MATRIX_H
#define MATRIX_H

class Matrix{

public:
	
	float grid[4][4];
	
	Matrix(){
	
		LoadIdentity();
	
	}
	
	void LoadIdentity(){
	
		grid[0][0]=1.0;
		grid[1][0]=0.0;
		grid[2][0]=0.0;
		grid[3][0]=0.0;
		grid[0][1]=0.0;
		grid[1][1]=1.0;
		grid[2][1]=0.0;
		grid[3][1]=0.0;
		grid[0][2]=0.0;
		grid[1][2]=0.0;
		grid[2][2]=1.0;
		grid[3][2]=0.0;
	
		grid[0][3]=0.0;
		grid[1][3]=0.0;
		grid[2][3]=0.0;
		grid[3][3]=1.0;

	}
	
	// copy - create new copy and returns it
	
	Matrix* Copy(){
	
		Matrix* mat=new Matrix();
	
		mat->grid[0][0]=grid[0][0];
		mat->grid[1][0]=grid[1][0];
		mat->grid[2][0]=grid[2][0];
		mat->grid[3][0]=grid[3][0];
		mat->grid[0][1]=grid[0][1];
		mat->grid[1][1]=grid[1][1];
		mat->grid[2][1]=grid[2][1];
		mat->grid[3][1]=grid[3][1];
		mat->grid[0][2]=grid[0][2];
		mat->grid[1][2]=grid[1][2];
		mat->grid[2][2]=grid[2][2];
		mat->grid[3][2]=grid[3][2];
	
		// do not remove
		mat->grid[0][3]=grid[0][3];
		mat->grid[1][3]=grid[1][3];
		mat->grid[2][3]=grid[2][3];
		mat->grid[3][3]=grid[3][3];
		
		return mat;
		
	}
		
	// overwrite - overwrites self with matrix passed as parameter
		
	void Overwrite(Matrix &mat){
		
		grid[0][0]=mat.grid[0][0];
		grid[1][0]=mat.grid[1][0];
		grid[2][0]=mat.grid[2][0];
		grid[3][0]=mat.grid[3][0];
		grid[0][1]=mat.grid[0][1];
		grid[1][1]=mat.grid[1][1];
		grid[2][1]=mat.grid[2][1];
		grid[3][1]=mat.grid[3][1];
		grid[0][2]=mat.grid[0][2];
		grid[1][2]=mat.grid[1][2];
		grid[2][2]=mat.grid[2][2];
		grid[3][2]=mat.grid[3][2];
		
		grid[0][3]=mat.grid[0][3];
		grid[1][3]=mat.grid[1][3];
		grid[2][3]=mat.grid[2][3];
		grid[3][3]=mat.grid[3][3];
		
	}
		
	Matrix* Inverse(){
		
		Matrix* mat=new Matrix;
		
		float tx=0;
		float ty=0;
		float tz=0;
	
	  	// the rotational part of the matrix is simply the transpose of the
	  	// original matrix.
	  	mat->grid[0][0] = grid[0][0];
	  	mat->grid[1][0] = grid[0][1];
	  	mat->grid[2][0] = grid[0][2];
		
		mat->grid[0][1] = grid[1][0];
		mat->grid[1][1] = grid[1][1];
		mat->grid[2][1] = grid[1][2];
		
		mat->grid[0][2] = grid[2][0];
		mat->grid[1][2] = grid[2][1];
		mat->grid[2][2] = grid[2][2];
		
		// The right column vector of the matrix should always be [ 0 0 0 1 ]
		// in most cases. . . you don't need this column at all because it'll 
		// never be used in the program, but since this code is used with GL
		// and it does consider this column, it is here.
		mat->grid[0][3] = 0;
		mat->grid[1][3] = 0;
		mat->grid[2][3] = 0;
		mat->grid[3][3] = 1;
		
		// The translation components of the original matrix.
		tx = grid[3][0];
		ty = grid[3][1];
		tz = grid[3][2];
		
		// result = -(Tm * Rm) To get the translation part of the inverse
		mat->grid[3][0] = -( (grid[0][0] * tx) + (grid[0][1] * ty) + (grid[0][2] * tz) );
		mat->grid[3][1] = -( (grid[1][0] * tx) + (grid[1][1] * ty) + (grid[1][2] * tz) );
		mat->grid[3][2] = -( (grid[2][0] * tx) + (grid[2][1] * ty) + (grid[2][2] * tz) );
		
		return mat;
		
	}
		
	void Multiply(Matrix &mat){
		
		float m00 = grid[0][0]*mat.grid[0][0] + grid[1][0]*mat.grid[0][1] + grid[2][0]*mat.grid[0][2] + grid[3][0]*mat.grid[0][3];
		float m01 = grid[0][1]*mat.grid[0][0] + grid[1][1]*mat.grid[0][1] + grid[2][1]*mat.grid[0][2] + grid[3][1]*mat.grid[0][3];
		float m02 = grid[0][2]*mat.grid[0][0] + grid[1][2]*mat.grid[0][1] + grid[2][2]*mat.grid[0][2] + grid[3][2]*mat.grid[0][3];
		//float m03 = grid[0][3]*mat.grid[0][0] + grid[1,3]*mat.grid[0][1] + grid[2,3]*mat.grid[0][2] + grid[3][3]*mat.grid[0][3];
		float m10 = grid[0][0]*mat.grid[1][0] + grid[1][0]*mat.grid[1][1] + grid[2][0]*mat.grid[1][2] + grid[3][0]*mat.grid[1][3];
		float m11 = grid[0][1]*mat.grid[1][0] + grid[1][1]*mat.grid[1][1] + grid[2][1]*mat.grid[1][2] + grid[3][1]*mat.grid[1][3];
		float m12 = grid[0][2]*mat.grid[1][0] + grid[1][2]*mat.grid[1][1] + grid[2][2]*mat.grid[1][2] + grid[3][2]*mat.grid[1][3];
		//float m13 = grid[0][3]*mat.grid[1][0] + grid[1][3]*mat.grid[1][1] + grid[2][3]*mat.grid[1][2] + grid[3][3]*mat.grid[1][3];
		float m20 = grid[0][0]*mat.grid[2][0] + grid[1][0]*mat.grid[2][1] + grid[2][0]*mat.grid[2][2] + grid[3][0]*mat.grid[2][3];
		float m21 = grid[0][1]*mat.grid[2][0] + grid[1][1]*mat.grid[2][1] + grid[2][1]*mat.grid[2][2] + grid[3][1]*mat.grid[2][3];
		float m22 = grid[0][2]*mat.grid[2][0] + grid[1][2]*mat.grid[2][1] + grid[2][2]*mat.grid[2][2] + grid[3][2]*mat.grid[2][3];
		//float m23 = grid[0][3]*mat.grid[2][0] + grid[1][3]*mat.grid[2][1] + grid[2][3]*mat.grid[2][2] + grid[3][3]*mat.grid[2][3];
		float m30 = grid[0][0]*mat.grid[3][0] + grid[1][0]*mat.grid[3][1] + grid[2][0]*mat.grid[3][2] + grid[3][0]*mat.grid[3][3];
		float m31 = grid[0][1]*mat.grid[3][0] + grid[1][1]*mat.grid[3][1] + grid[2][1]*mat.grid[3][2] + grid[3][1]*mat.grid[3][3];
		float m32 = grid[0][2]*mat.grid[3][0] + grid[1][2]*mat.grid[3][1] + grid[2][2]*mat.grid[3][2] + grid[3][2]*mat.grid[3][3];
		//float m33 = grid[0][3]*mat.grid[3][0] + grid[1][3]*mat.grid[3][1] + grid[2][3]*mat.grid[3][2] + grid[3][3]*mat.grid[3][3];
		
		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;
		//grid[0,3]=m03;
		grid[1][0]=m10;
		grid[1][1]=m11;
		grid[1][2]=m12;
		//grid[1,3]=m13;
		grid[2][0]=m20;
		grid[2][1]=m21;
		grid[2][2]=m22;
		//grid[2,3]=m23;
		grid[3][0]=m30;
		grid[3][1]=m31;
		grid[3][2]=m32;
		//grid[3,3]=m33;
		
	}
		
	void Translate(float x,float y,float z){
		
		grid[3][0] = grid[0][0]*x + grid[1][0]*y + grid[2][0]*z + grid[3][0];
		grid[3][1] = grid[0][1]*x + grid[1][1]*y + grid[2][1]*z + grid[3][1];
		grid[3][2] = grid[0][2]*x + grid[1][2]*y + grid[2][2]*z + grid[3][2];
		
	}
		
	void Scale(float x,float y,float z){
		
		grid[0][0] = grid[0][0]*x;
		grid[0][1] = grid[0][1]*x;
		grid[0][2] = grid[0][2]*x;
		
		grid[1][0] = grid[1][0]*y;
		grid[1][1] = grid[1][1]*y;
		grid[1][2] = grid[1][2]*y;
		
		grid[2][0] = grid[2][0]*z;
		grid[2][1] = grid[2][1]*z;
		grid[2][2] = grid[2][2]*z;
		
	}
		
	void Rotate(float rx,float ry,float rz){
		
		float cos_ang,sin_ang;
		
		// yaw
		
		cos_ang=cosdeg(ry);
		sin_ang=sindeg(ry);
		
		float m00 = grid[0][0]*cos_ang + grid[2][0]*-sin_ang;
		float m01 = grid[0][1]*cos_ang + grid[2][1]*-sin_ang;
		float m02 = grid[0][2]*cos_ang + grid[2][2]*-sin_ang;
		
		grid[2][0] = grid[0][0]*sin_ang + grid[2][0]*cos_ang;
		grid[2][1] = grid[0][1]*sin_ang + grid[2][1]*cos_ang;
		grid[2][2] = grid[0][2]*sin_ang + grid[2][2]*cos_ang;
		
		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;
		
		// pitch
		
		cos_ang=cosdeg(rx);
		sin_ang=sindeg(rx);
		
		float m10 = grid[1][0]*cos_ang + grid[2][0]*sin_ang;
		float m11 = grid[1][1]*cos_ang + grid[2][1]*sin_ang;
		float m12 = grid[1][2]*cos_ang + grid[2][2]*sin_ang;
		
		grid[2][0] = grid[1][0]*-sin_ang + grid[2][0]*cos_ang;
		grid[2][1] = grid[1][1]*-sin_ang + grid[2][1]*cos_ang;
		grid[2][2] = grid[1][2]*-sin_ang + grid[2][2]*cos_ang;
		
		grid[1][0]=m10;
		grid[1][1]=m11;
		grid[1][2]=m12;
		
		// roll
		
		cos_ang=cosdeg(rz);
		sin_ang=sindeg(rz);
		
		m00 = grid[0][0]*cos_ang + grid[1][0]*sin_ang;
		m01 = grid[0][1]*cos_ang + grid[1][1]*sin_ang;
		m02 = grid[0][2]*cos_ang + grid[1][2]*sin_ang;
		
		grid[1][0] = grid[0][0]*-sin_ang + grid[1][0]*cos_ang;
		grid[1][1] = grid[0][1]*-sin_ang + grid[1][1]*cos_ang;
		grid[1][2] = grid[0][2]*-sin_ang + grid[1][2]*cos_ang;
		
		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;
		
	}
		
	void RotatePitch(float ang){
		
		// pitch
		
		float cos_ang=cosdeg(ang);
		float sin_ang=sindeg(ang);
		
		float m10 = grid[1][0]*cos_ang + grid[2][0]*sin_ang;
		float m11 = grid[1][1]*cos_ang + grid[2][1]*sin_ang;
		float m12 = grid[1][2]*cos_ang + grid[2][2]*sin_ang;
		
		grid[2][0] = grid[1][0]*-sin_ang + grid[2][0]*cos_ang;
		grid[2][1] = grid[1][1]*-sin_ang + grid[2][1]*cos_ang;
		grid[2][2] = grid[1][2]*-sin_ang + grid[2][2]*cos_ang;
		
		grid[1][0]=m10;
		grid[1][1]=m11;
		grid[1][2]=m12;

	}
		
	void RotateYaw(float ang){
		
		// yaw
		
		float cos_ang=cosdeg(ang);
		float sin_ang=sindeg(ang);
		
		float m00 = grid[0][0]*cos_ang + grid[2][0]*-sin_ang;
		float m01 = grid[0][1]*cos_ang + grid[2][1]*-sin_ang;
		float m02 = grid[0][2]*cos_ang + grid[2][2]*-sin_ang;
		
		grid[2][0] = grid[0][0]*sin_ang + grid[2][0]*cos_ang;
		grid[2][1] = grid[0][1]*sin_ang + grid[2][1]*cos_ang;
		grid[2][2] = grid[0][2]*sin_ang + grid[2][2]*cos_ang;
		
		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;
		
	}
		
	void RotateRoll(float ang){
		
		// roll
		
		float cos_ang=cosdeg(ang);
		float sin_ang=sindeg(ang);
		
		float m00 = grid[0][0]*cos_ang + grid[1][0]*sin_ang;
		float m01 = grid[0][1]*cos_ang + grid[1][1]*sin_ang;
		float m02 = grid[0][2]*cos_ang + grid[1][2]*sin_ang;
		
		grid[1][0] = grid[0][0]*-sin_ang + grid[1][0]*cos_ang;
		grid[1][1] = grid[0][1]*-sin_ang + grid[1][1]*cos_ang;
		grid[1][2] = grid[0][2]*-sin_ang + grid[1][2]*cos_ang;
		
		grid[0][0]=m00;
		grid[0][1]=m01;
		grid[0][2]=m02;

	}
		
};

#endif

