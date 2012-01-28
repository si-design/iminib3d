/*
 *  misc.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "misc.h"
#include "string_helper.h"

#include "MachTimer.h"

#import <UIKit/UIKit.h>

#include <cstdlib>

#include <string>
#include <sstream>
#include <iostream>
using namespace std;

template <class T>
bool from_string(T& t,const string& s,ios_base& (*f)(std::ios_base&)){

  istringstream iss(s);
  return !(iss >> f >> t).fail();
}

// string to int
int ToInt(string s){

	int i=0;

	from_string<int>(i,std::string(s),std::dec);
	
	return i;

}

// string to float
float ToFloat(string s){

	float f=0;

	from_string<float>(f,std::string(s),std::dec);
	
	return f;

}

string ToString(int i){

	std::string s;
	std::stringstream out;
	out << i;
	s = out.str();
	return s;
	
}

string ToString(float f){

	std::string s;
	std::stringstream out;
	out << f;
	s = out.str();
	return s;
	
}

string ToString(NSString* str){

	const char* c=[str UTF8String];

	string s=c;

	return s;

}

NSString* ToNSString(string str){

	const char* c=str.c_str();

	NSString* s = [NSString stringWithUTF8String: c];

	return s;

}

int Sgn(int i){

	return (i>0)-(i<0);

}

int Sgn(float f){

	return (f>0)-(f<0);

}

float Round(float n, unsigned d){

	return floor(n * pow(10., d) + .5) / pow(10., d);
	
}

// returns a string representation of an int number (n) that is the specified no of digits in length (d)
// if n>d, then d number of 9s are returned
// if n<d, and f (fraction)=false then n with 0s at the start are returned
// if n<d, and f (fraction)=true then n with 0s at the end are returned
string Digits(int n, int d, int f){

	int l=Len(ToString(n));
	
	if(l<1) return "";
	
	if(l==d) return ToString(n);

	if(l>d){
		string nines="";
		for(int i=1;i<=d;i++){
			nines=nines+"9";
		}
		return nines;
	}
	
	// l is less than d and f=false
	if(f==false){
		string no=ToString(n);
		for(int i=l;i<d;i++){
			no="0"+no;
		}
		return no;
	}
	
	// l is less than d and f=true
	string no=ToString(n);
	for(int i=l;i<d;i++){
		no=no+"0";
	}
	return no;
	
}

id mt=[MachTimer new];

float Secs(){

	return [mt elapsedSec];

}

int Millisecs(){

	return static_cast<int>([mt elapsedSec]*1000.0);

}

float Rnd(float min,float max){

	if(max==0.0){
		max=min;
		min=0.0;
	}

	float temp=0.0;

	if(min>max){
		temp = min;
		min = max;
		max = temp;
	}

	temp = (rand()/(static_cast<double>(RAND_MAX)+1.0))*(max - min)+min;
	return temp;

}

int Rand(int min,int max){

	if(max==0.0){
		max=min;
		min=0.0;
	}

	int temp=0;

	if(min>max){
		temp=min;
		min=max;
		max=temp;
	}

	temp=(rand()/(static_cast<double>(RAND_MAX)+1.0))*(max+1-min)+min;
	return temp;

}

void SeedRnd(int seed){

	srand(seed);

}

void RuntimeError(string error_message){

	const char* c=error_message.c_str();

	fputs(c,stderr);
	exit (1);

}