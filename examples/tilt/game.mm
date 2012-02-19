/*
 *  game.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright 2009 Si Design. All rights reserved.
 *
 */

#include "game.h"

void Game::Init(){

	Global::Graphics();

	piv=Pivot::CreatePivot();
	piv->PositionEntity(0.0,0.0,0.0);

	cam=Camera::CreateCamera(piv);
	cam->RotateEntity(0.0,0.0,90.0);

	light=Light::CreateLight(1);
	light->PositionEntity(0.0,0.0,0.0);
	light->LightRange(20.0);
	
	tex=Texture::LoadTexture("test.png");
	
	mesh[0]=Mesh::CreateCone();
	mesh[0]->PositionEntity(-3,0,5);
	mesh[0]->NameEntity("cone0");
	mesh[0]->EntityTexture(tex);

	mesh[1]=Mesh::CreateCone();
	mesh[1]->PositionEntity(0,0,5);
	mesh[1]->NameEntity("cone1");
	mesh[1]->EntityTexture(tex);
	
	mesh[2]=Mesh::CreateCone();
	mesh[2]->PositionEntity(3,0,5);
	mesh[2]->NameEntity("cone2");
	mesh[2]->EntityTexture(tex);
	
}

void Game::Run(){

	float pitch=Tilt::TiltPitch();
	float yaw=Tilt::TiltYaw();
	float roll=Tilt::TiltRoll();
	//float z=Tilt::TiltZ();

	mesh[0]->RotateEntity(pitch,0,0);
	mesh[1]->RotateEntity(0,yaw,0);
	mesh[2]->RotateEntity(0,0,roll);

	Global::UpdateWorld();
	Global::RenderWorld();
	
}

void Game::End(){

	Global::ClearWorld();

}