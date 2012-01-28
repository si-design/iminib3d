/*
 *  misc.h
 *  b3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef MISC_H
#define MISC_H

#import <UIKit/UIKit.h>

#include <string>
using namespace std;

int ToInt(string s);
float ToFloat(string s);
string ToString(int i);
string ToString(float f);
string ToString(NSString* str);
NSString* ToNSString(string str);
int Sgn(int i);
int Sgn(float f);
float Round(float n, unsigned d);
string Digits(int n, int d, int f);
float Secs();
int Millisecs();
float Rnd(float min,float max=0.0);
int Rand(int min,int max=0);
void SeedRnd(int seed);
void RuntimeError(string error_message);

#endif
