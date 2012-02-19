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

	Pivot* piv;
	Camera* cam;
	Mesh* teapot;
	Texture* tex;
	Pivot* vertex_piv;

	Game(){

		piv=NULL;
		cam=NULL;
		teapot=NULL;
		tex=NULL;
		vertex_piv=NULL;

	}
	
	void Init();
	void Run();
	void End();
	void SphereMap(Mesh* mesh,Camera* cam);
	float InvSqrt(float x);

};

#endif