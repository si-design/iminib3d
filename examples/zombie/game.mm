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

	piv->PositionEntity(0.0,5.0,0.0);
	piv->EntityType(1);
	piv->EntityRadius(2,3);

	cam=Camera::CreateCamera(piv);
	cam->RotateEntity(0.0,0.0,90.0);
	cam->CameraZoom(1.5); // 1.5 for landscape, 1.75 for portrait

	light=Light::CreateLight(1);
	light->PositionEntity(0.0,0.0,0.0);
	light->LightRange(20.0);

	// Zombie model by Psionic
	zombie=Mesh::LoadAnimMesh("zombie.b3d",light);

	//2-20		Walk cycle 1
	//22-36		Walk Cycle 2
	//38-47		Zombie being Attacked 1
	//48-57		Zombie being Attacked 2
	//59-75		Blown away onto his back
	//78-88		Still lying down and twitching (OFFSET to where he landed)
	//91-103	Die and fall forwards
	//106-115	Kick Attack
	//117-128	Punch/Grab Attack
	//129-136	Head Butt :-)
	//137-169	Idle 1
	//170-200	Idle 2
	//int idle1=zombie->ExtractAnimSeq(137,169);
	int idle2=zombie->ExtractAnimSeq(170,200);
	
	zombie->ScaleEntity(.35,.35,.35);
	zombie->PositionEntity(0,0,10);
	zombie->NameEntity("zombie");

	zombie2=zombie->CopyEntity();
	zombie2->PositionEntity(4.5,32.0,54.0);
	zombie2->RotateEntity(0,90,0);
	zombie2->NameEntity("zombie2");
	
	zombie->Animate(1,0.25);
	zombie2->Animate(1,0.25,idle2);
	
	level=Mesh::LoadMesh("test.b3d");
	level->ScaleEntity(4,4,4);
	level->EntityFX(1);
	level->EntityType(2);
	
	// controls init start
	
	control_cam=Camera::CreateCamera();
	control_cam->RotateEntity(0.0,0.0,90.0);
	control_cam->PositionEntity(0.0,1000.0,-5,0);
	control_cam->CameraClsMode(false,true);

	stick1_piv=Pivot::CreatePivot();
	stick1_piv->PositionEntity(-5.0,1000.0-3.0,0.0);

	stick2_piv=Pivot::CreatePivot();
	stick2_piv->PositionEntity(5.0,1000.0-3.0,0.0);

	stick1=Mesh::CreateSphere(8,stick1_piv);
	stick1->PositionEntity(0.0,0.0,0.0);
	stick1->EntityColor(0,255,0);
	stick1->EntityPickMode(1,true);
	stick1->EntityRadius(2.0);

	stick2=Mesh::CreateSphere(8,stick2_piv);
	stick2->PositionEntity(0.0,0.0,0.0);
	stick2->EntityColor(0,255,255);
	stick2->EntityPickMode(1,true);
	stick2->EntityRadius(2.0);
	
	pick_quad=Mesh::CreateQuad(control_cam);
	pick_quad->PositionEntity(0,0,5);
	pick_quad->ScaleEntity(8.0,8.0,1.0);
	pick_quad->EntityAlpha(0.0);
	pick_quad->EntityPickMode(2);
	
	// controls init end
	
	Global::Collisions(1,2,2,2);

}

void Game::Run(){

	// controls start

	static int stick_bond1=false;
	static int stick_bond2=false;
		
	static float offx1=0.0;
	static float offy1=0.0;
	
	static float offx2=0.0;
	static float offy2=0.0;
	
	int stick1_picked=false;
	int stick2_picked=false;
	
	float px1,py1,pz1;
	float px2,py2,pz2;
	
	for(int i=0;i<Touch::CountTouches();i++){

		Entity* ent=Pick::CameraPick(control_cam,Touch::TouchX(i),Touch::TouchY(i));

		// left stick touched - now pick invisible 'pick quad' underneath - use these pick coords to position stick later
		if(ent==stick1){

			stick1->HideEntity();
			stick2->HideEntity();
			ent=Pick::CameraPick(control_cam,Touch::TouchX(i),Touch::TouchY(i));
			stick1->ShowEntity();
			stick2->ShowEntity();
		
			stick1_picked=true;
			px1=Pick::PickedX();
			py1=Pick::PickedY();
			pz1=Pick::PickedZ();
		
		}
			
		// right stick touched - now pick invisible 'pick quad' underneath - use these pick coords to position stick later
		if(ent==stick2){

			stick1->HideEntity();
			stick2->HideEntity();
			ent=Pick::CameraPick(control_cam,Touch::TouchX(i),Touch::TouchY(i));
			stick1->ShowEntity();
			stick2->ShowEntity();
		
			stick2_picked=true;
			px2=Pick::PickedX();
			py2=Pick::PickedY();
			pz2=Pick::PickedZ();
			
		}

	}

	// left stick first touch after reset - get offsets
	if(stick1_picked==true){
	
		if(stick_bond1==false){
		
			offx1=stick1->EntityX(true)-px1;
			offy1=stick1->EntityY(true)-py1;
		
		}
		
		stick_bond1=true;
	
	}
	
	// right stick first touch after reset - get offset
	if(stick2_picked==true){
	
		if(stick_bond2==false){
		
			offx2=stick2->EntityX(true)-px2;
			offy2=stick2->EntityY(true)-py2;
		
		}
		
		stick_bond2=true;
	
	}
	
	// left stick not touched - reset
	if(stick1_picked==false){
	
		stick_bond1=false;
		stick1->PositionEntity(0.0,0.0,0.0);
	
	}
	
	// right stick not touched - reset
	if(stick2_picked==false){
	
		stick_bond2=false;
		stick2->PositionEntity(0.0,0.0,0.0);
	
	}

	// left stick being touched - move stick and move cam (child of piv)
	if(stick_bond1){
	
		float smx=stick1->EntityX(true)-stick1_piv->EntityX(true);
		float smy=stick1->EntityY(true)-stick1_piv->EntityY(true);

		smx=smx/10.0;
		smy=smy/10.0;
	
		piv->MoveEntity(smx,0.0,smy);

		stick1->PositionEntity(px1+offx1,py1+offy1,pz1,true);
		
	}
	
	// right stick being touched - move stick and move cam (child of piv)
	if(stick_bond2){
	
		float smx=stick2->EntityX(true)-stick2_piv->EntityX(true);
		float smy=stick2->EntityY(true)-stick2_piv->EntityY(true);
		
		smx=smx*2.0;
		smy=smy*2.0;

		piv->TurnEntity(smy*-1,smx*-1,0);

		stick2->PositionEntity(px2+offx2,py2+offy2,pz2,true);
		
	}
	
	// controls end
	
	piv->TranslateEntity(0,-0.2,0);

	Global::UpdateWorld();
	Global::RenderWorld();
	
}

void Game::End(){

	Global::ClearWorld();

}