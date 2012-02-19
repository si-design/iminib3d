/*
 *  game.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "game.h"

void Game::Init(){

	Global::Graphics();

	piv=Pivot::CreatePivot();
	piv->PositionEntity(0.0,0.0,0.0);

	cam=Camera::CreateCamera(piv);
	cam->PositionEntity(0,5,-10);
	cam->RotateEntity(15.0,0.0,90.0);
	cam->CameraZoom(1.5);

	light=Light::CreateLight();
	light->RotateEntity(30,30,0);
	
	mesh[0]=Mesh::CreateCube();
	mesh[0]->PositionEntity(0.0,9.0,0.0);
	mesh[0]->ScaleEntity(50.0,10.0,50.0);
	mesh[0]->FlipMesh();
	mesh[0]->EntityColor(0.0,127.0,0.0);
	mesh[0]->EntityPickMode(2);
	mesh[0]->EntityType(2);
	mesh[0]->NameEntity("plane");

	mesh[1]=Mesh::CreateCylinder();
	mesh[1]->PositionEntity(-5.0,-5.0,0.0);
	mesh[1]->ScaleMesh(1.0,5.0,1.0); // use scalemesh rather than scaleentity for any dynamic destination entities
	mesh[1]->EntityColor(255.0,255.0,0.0);
	mesh[1]->EntityType(2);
	mesh[1]->dynamic=true; // the secret to activating dynamic sphere -> dynamic mesh collisions - set 'dynamic' to true for any destination entities
	mesh[1]->NameEntity("cylinder");

	mesh[2]=Mesh::CreateCube();
	mesh[2]->PositionEntity(5.0,0.0,5.0);
	mesh[2]->EntityColor(255.0,0.0,0.0);
	mesh[2]->EntityType(2);
	mesh[2]->dynamic=true;
	mesh[2]->NameEntity("cube");

	mesh[3]=Mesh::CreateSphere();
	mesh[3]->PositionEntity(0,0,0);
	//mesh[3]->ScaleEntity(.5,.5,.5);
	mesh[3]->EntityColor(0.0,0.0,255.0);
	mesh[3]->EntityPickMode(1);
	mesh[3]->EntityRadius(1.0);
	mesh[3]->EntityType(1);
	mesh[3]->NameEntity("sphere");

	Global::Collisions(1,2,2,2);

}

void Game::Run(){

	static int sphere_bond=false;

	float sphere_px,sphere_py,sphere_pz;

		if(sphere_bond==false){

		for(int i=0;i<Touch::CountTouches();i++){

			Entity* ent=Pick::CameraPick(cam,Touch::TouchX(i),Touch::TouchY(i));

			if(ent==mesh[3]){
			
				sphere_bond=true;
				break;
				
			}
			
		}
	
	}
		
	if(sphere_bond==true){

		for(int i=0;i<Touch::CountTouches();i++){
		
			mesh[3]->HideEntity();
			Entity* ent=Pick::CameraPick(cam,Touch::TouchX(i),Touch::TouchY(i));
			mesh[3]->ShowEntity();

			// sphere touched - now pick plane underneath - use these pick coords to position sphere later
			if(ent==mesh[0]){

				sphere_px=Pick::PickedX();
				sphere_py=Pick::PickedY();
				sphere_pz=Pick::PickedZ();
				break;
				
			}
			
		}
	
	}
		
	// sphere not touched - reset
	if(Touch::TouchesDown()==false){
	
		sphere_bond=false;
	
	}

	// sphere being touched - move sphere
	if(sphere_bond){

		mesh[3]->PositionEntity(sphere_px,sphere_py,sphere_pz,true);
		
	}
	
	static float ang=0.0;
	ang=ang+1;
	
	mesh[1]->PositionEntity(-5,(sindeg(ang)*5.0)-5.0,0.0);
	mesh[2]->PositionEntity(5,0,(sindeg(ang)*5.0)+5.0);
	
	Global::UpdateWorld();
	Global::RenderWorld();
	
}

void Game::End(){

	Global::ClearWorld();

}