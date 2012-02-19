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

class Game{

public:

	Camera* cam;
	Mesh* pick_quad;
	
	Sprite* spark_sprite;

	Game(){
	
		cam=NULL;
		pick_quad=NULL;
		
		spark_sprite=NULL;
	
	}
	
	void Init();
	void Run();
	void End();

};

#endif