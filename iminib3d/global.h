/*
 *  global.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef GLOBAL_H
#define GLOBAL_H

#include "pivot.h"
#include "mesh.h"

class Global{

public:

	static int ipad;

	static int width,height;
	static float ambient_red,ambient_green,ambient_blue;

	static int vbo_enabled;
	static int vbo_min_tris;

	static float anim_speed;

	static int fog_enabled; // used to keep track of whether fog is enabled between camera update and mesh render

	static Pivot* root_ent;
	
	static int iPad();
  static int ScreenWidth();
  static int ScreenHeight();
	static float Scale();
	
	static void Graphics(int w=0,int h=0);
	
	static void AmbientLight(float r,float g,float b);
	
	static void ClearCollisions();
	static void Collisions(int src_no,int dest_no,int method_no,int response_no=0);
	static void ClearWorld(int entities=true,int brushes=true,int textures=true);
	static void UpdateWorld(float anim_speed=1.0);
	static void RenderWorld();
	static void UpdateAnimations(float anim_speed=1.0);
	static void UpdateEntityAnim(Mesh& mesh);
	
};

bool CompareEntityOrder(Entity* ent1,Entity* ent2);

#endif