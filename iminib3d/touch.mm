/*
 *  touch.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "touch.h"

#include "string_helper.h"
#include "misc.h"

vector<Touch*> Touch::touch_list;
vector<Touch*> Touch::all_touch_list;

Touch::Touch(int xx,int yy,int old_xx,int old_yy,int touch_type){

	old_x=old_xx;
	old_y=old_yy;
	x=xx;
	y=yy;
	type=touch_type;
	if(type==1){
		hit=true;
	}else{
		hit=false;
	}
	
	if(type>=1 && type<=3){
		touch_list.push_back(this); // only add begin, stationary and move touches
	}
	
	all_touch_list.push_back(this); // add all touches, including dead touches end and cancel

};

void Touch::ClearTouches(){

	vector<Touch*>::iterator it;
	
	for(it=all_touch_list.begin();it!=all_touch_list.end();it++){
	
		Touch* touch=*it;
		delete touch;
		
	}
	
	touch_list.clear();
	all_touch_list.clear();

}

int Touch::CountTouches(){

	return touch_list.size();

}

int Touch::CountAllTouches(){ // includes dead touches

	return all_touch_list.size();

}

// returns touch type
// 1=began
// 2=moving
// 3=stationary
// 4=ended
// 5=cancelled
int Touch::TouchType(int touch_no,int all){

	if(!all){
		if(touch_list.size()>touch_no){
			return touch_list[touch_no]->type;
		}
	}else{
		if(all_touch_list.size()>touch_no){
			return all_touch_list[touch_no]->type;
		}
	}
	
	return 0;

}

int Touch::TouchX(int touch_no,int all){
	
	if(!all){
		if(touch_list.size()>touch_no){
			return touch_list[touch_no]->x;
		}
	}else{
		if(all_touch_list.size()>touch_no){
			return all_touch_list[touch_no]->x;
		}
	}
	
	return 0;

}

int Touch::TouchY(int touch_no,int all){

	if(!all){
		if(touch_list.size()>touch_no){
			return touch_list[touch_no]->y;
		}
	}else{
		if(all_touch_list.size()>touch_no){
			return all_touch_list[touch_no]->y;
		}
	}
	
	return 0;

}

int Touch::TouchXPrev(int touch_no,int all){
	
	if(!all){
		if(touch_list.size()>touch_no){
			return touch_list[touch_no]->old_x;
		}
	}else{
		if(all_touch_list.size()>touch_no){
			return all_touch_list[touch_no]->old_x;
		}
	}

	return 0;

}

int Touch::TouchYPrev(int touch_no,int all){

	if(!all){
		if(touch_list.size()>touch_no){
			return touch_list[touch_no]->old_y;
		}
	}else{
		if(all_touch_list.size()>touch_no){
			return all_touch_list[touch_no]->old_y;
		}
	}
	
	return 0;

}

int Touch::TouchXSpeed(int touch_no){

	if(touch_list.size()>touch_no){
		return touch_list[touch_no]->x-touch_list[touch_no]->old_x;
	}

	return 0;

}

int Touch::TouchYSpeed(int touch_no){

	if(touch_list.size()>touch_no){
		return touch_list[touch_no]->y-touch_list[touch_no]->old_y;
	}

	return 0;

}

// returns x speed of all touches since last time
int Touch::TouchesXSpeed(){

	int swipe_x=0;

	for(int i=0;i<touch_list.size();i++){

		swipe_x=swipe_x+(touch_list[i]->x-touch_list[i]->old_x);

	}
	
	return swipe_x;

}

// returns y speed of all touches since last time
int Touch::TouchesYSpeed(){

	int swipe_y=0;

	for(int i=0;i<touch_list.size();i++){

		swipe_y=swipe_y+(touch_list[i]->y-touch_list[i]->old_y);

	}
	
	return swipe_y;

}

int Touch::TouchHit(int touch_no,int all){

	if(!all){
		if(touch_list.size()>touch_no){
			int hit=touch_list[touch_no]->hit;
			touch_list[touch_no]->hit=false;
			return hit;
		}
	}else{
		if(all_touch_list.size()>touch_no){
			int hit=all_touch_list[touch_no]->hit;
			all_touch_list[touch_no]->hit=false;
			return hit;
		}
	}
	
	return 0;

}

 // returns true if any touch
int Touch::TouchesDown(){

	return touch_list.size();

}

// returns true if any touch hits after no touches last time
int Touch::TouchesHit(){

	static int down=false;

	if(touch_list.size()>0){

		if(down==false){
			down=true;
			return true;
		}
	}

	if(touch_list.size()==0){

		down=false;
		return false;
		
	}
	
	return false;

}

// returns true if no touches after a touch last time
int Touch::TouchesRelease(){

	static int down=false;

	if(touch_list.size()==0){

		if(down==true){
			down=false;
			return true;
		}
		
	}

	if(touch_list.size()>0){

		down=true;
		return false;
		
	}
	
	return false;

}