/*
 *  game.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef GAME_H
#define GAME_H

#include "iminib3d.h"

//-------------------------------------------------------------------------------------
//									VARIABLES
//-------------------------------------------------------------------------------------

const int nkeyframes=50;				// maximum number of keyframes per motion
const int nchannels=9;					// number of channel values

class KeyFrame{

public:

	int fstep;						//frame number
	float cv[nchannels-1+1];		//array of channel values (x y z h p b sx sy sz)
	int linear;						//linear flag
	int tens;						//Kochanek-Bartels parameters
	int cont;
	float bias;

	KeyFrame(){
		//KeyFrame_list.push_back(this);
		
		fstep=0;
		linear=0;
		tens=0;
		cont=0;
		bias=0.0;
		
	}

};

class Motion{

public:

	int nkeys;						//number of keyframes
	int nsteps;						//last frame number
	KeyFrame* keylist[nkeyframes-1];//array of keyframes

	Motion(){
		//Motion_list.push_back(this);
		
		nkeys=0;
		nsteps=0;
		
	}

};

float Parse(string s,int o);
int Load_Motion(string file,Motion* m);
void Apply_Motion(Motion* m,float tstep,Entity* e,int rot,int rot2=0);

class Game{

public:

	float fstep;
	float anim_time;
	
	Motion* cmot;
	Motion* b1mot;
	Motion* b2mot;

	Pivot* piv;
	Camera* camera;
	Light* light_sun;

	Mesh* mesh_canyon;
	Mesh* mesh_skybox;
	Mesh* mesh_bird;
	Mesh* mesh_bird2;
	
	Game(){
	
		fstep=0;
		anim_time=0;
		
		cmot=NULL;
		b1mot=NULL;
		b2mot=NULL;
	
		piv=NULL;
		camera=NULL;
		light_sun=NULL;
	
		mesh_canyon=NULL;
		mesh_skybox=NULL;
		mesh_bird=NULL;
		mesh_bird2=NULL;
	
	}
	
	void Init();
	void Run();
	void End();
	
	Mesh* MakeSkyBox(string file);

};

#endif