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

#include "game.h"
#include "iminib3d.h"

class Game{

public:

	Pivot* piv;
	Camera* cam;
	Light* light;

	Mesh* level;
	Mesh* zombie;
	Mesh* zombie2;

	// controls

	Camera* control_cam;

	Pivot* stick1_piv;
	Pivot* stick2_piv;
	
	Mesh* stick1;
	Mesh* stick2;

	Mesh* pick_quad;

	//

	Game(){
	
		piv=new Pivot;
		cam=NULL;
		light=NULL;
	
		level=NULL;
		zombie=NULL;
		zombie2=NULL;
		
		 // controls
		
		control_cam=NULL;
		
		stick1_piv=NULL;
		stick2_piv=NULL;
	
		stick1=NULL;
		stick2=NULL;
		
		//
	
	}
	
	void Init();
	void Run();
	void End();

};

#endif