/*
 *  game.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "game.h"

#include "firework.h"

void Game::Init(){

	Global::Graphics();
	
	cam=Camera::CreateCamera();
	//cam->CameraClsMode(0,0);
	cam=Camera::CreateCamera();

	pick_quad=Mesh::CreateQuad();
	pick_quad->ScaleEntity(20.0,20.0,1.0);
	pick_quad->PositionEntity(0.0,0.0,20.0);
	pick_quad->EntityAlpha(0.0);
	pick_quad->EntityPickMode(2);
	
	spark_sprite=Sprite::LoadSprite("spark.png");
	spark_sprite->SpriteRenderMode(2);

}


void Game::Run(){

	for(int i=0;i<Touch::CountTouches();i++){

		if(Touch::TouchHit(i)){

			float x=Touch::TouchX(i);
			float y=Touch::TouchY(i);
			float z=0.0;
	
			Entity* ent=Pick::CameraPick(cam,x,y);
		
			if(ent){
		
				x=Pick::PickedX();
				y=Pick::PickedY();
				z=Pick::PickedZ();
				Firework::Create(x,y,z);
		
			}
		
		}
	
	}
	
	Firework::UpdateFireworks();

	Global::RenderWorld();

}


void Game::End(){

	Global::ClearWorld();

}