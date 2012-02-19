/*
 *  firework.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef FIREWORK_H
#define FIREWORK_H

#import <UIKit/UIKit.h>

#include "iminib3d.h"

#include "spark.h"

#include "game.h"

extern Game* game;

class Firework{

public:
	
	static list<Firework*> fireworks_list;
	list<Spark*> sparks_list;

	Firework(){

	}
	
	static void Create(float x,float y,float z,int no_sparks=100){
	
		Firework* firework=new Firework;
		fireworks_list.push_back(firework);
	
		float red=Rand(0,255);
		float green=Rand(0,255);
		float blue=Rand(0,255);
	
		for(int i=0;i<=no_sparks;i++){
		
			Spark* spark=new Spark;
			firework->sparks_list.push_back(spark);
			spark->sprite=game->spark_sprite->CopyEntity();
			spark->sprite->PositionEntity(x,y,z);
			spark->sprite->RotateEntity(Rnd(360.0),Rnd(360.0),0.0);
			spark->sprite->EntityColor(red,green,blue);
			
		}
	
	}
	
	static void UpdateFireworks(){
	
		list<Firework*>::iterator it;
		for(it=fireworks_list.begin();it!=fireworks_list.end();it++){
		
			Firework* firework=*it;
			
			firework->UpdateSparks();
			
			if(firework->sparks_list.size()==0){
			
				it=fireworks_list.erase(it);
				
				delete firework;
			
			}
			
		}
	
	}
	
	void UpdateSparks(){
	
		list<Spark*>::iterator it;
		for(it=sparks_list.begin();it!=sparks_list.end();it++){
		
			Spark* spark=*it;
			
			spark->Update();
		
			if(spark->alpha<=0.0){
			
				spark->sprite->FreeEntity();
			
				it=sparks_list.erase(it);
				
				delete spark;
			
			}
		
		}
	
	}
	
};

#endif