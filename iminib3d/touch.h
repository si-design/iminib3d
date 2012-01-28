/*
 *  touch.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef TOUCH_H
#define TOUCH_H

#import <UIKit/UIKit.h>

#include <iostream>
#include <vector>
using namespace std;

class Touch{

public:

	//static int no_touches;
	static vector<Touch*> touch_list; // includes active touches only
	static vector<Touch*> all_touch_list; // includes active and 'dead' touches - i.e. recently removed and cancelled touches
	
	float x,y;
	float old_x,old_y;
	int type;
	int hit;

	Touch(int xx,int yy,int old_xx,int old_yy,int touch_type);
	static void ClearTouches();
	static int CountTouches();
	static int CountAllTouches();
	static int TouchType(int touch_no,int all=false);
	static int TouchX(int touch_no,int all=false);
	static int TouchY(int touch_no,int all=false);
	static int TouchXPrev(int touch_no,int all=false);
	static int TouchYPrev(int touch_no,int all=false);
	static int TouchXSpeed(int touch_no);
	static int TouchYSpeed(int touch_no);
	static int TouchesXSpeed();
	static int TouchesYSpeed();
	static int TouchHit(int touch_no,int all=false);
	static int TouchesDown();
	static int TouchesHit();
	static int TouchesRelease();

};

#endif