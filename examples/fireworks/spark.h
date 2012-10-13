/*
 *  spark.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef SPARK_H
#define SPARK_H

#include "iminib3d.h"

class Spark{

public:
	
	//static Sprite* spark_sprite;
	float alpha;
	Sprite* sprite;

	Spark(){

		alpha=1.0;
		sprite=NULL;
		
	}
	
	void Update(){
	
		sprite->MoveEntity(0.0,0.0,0.2);
		sprite->TranslateEntity(0,0,-0.2,0.0);
		
		alpha=alpha-.01;
		sprite->EntityAlpha(alpha);

	}
	
};

#endif