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
	cam->CameraClsColor(63,63,63);
	cam->RotateEntity(0.0,0.0,90.0);
	cam->PositionEntity(0.0,0.0,-3.0);
	cam->CameraZoom(1.5); // 1.5 for landscape, 1.75 for portrait

	teapot=Mesh::LoadMesh("teapot.b3d");
	teapot->UpdateNormals();

	tex=Texture::LoadTexture("spheremap.png");
	teapot->EntityTexture(tex);

	vertex_piv=Pivot::CreatePivot();

}

void Game::Run(){

	float x=Touch::TouchesXSpeed();
	float y=Touch::TouchesYSpeed();
	
	//cam->TranslateEntity(y/30.0,-x/30.0,0);
	piv->TurnEntity(x,-y,0);

	teapot->TurnEntity(0,0.1,0);
	
	SphereMap(teapot,cam);

	Global::RenderWorld();
	
}

void Game::End(){

	Global::ClearWorld();

}

void Game::SphereMap(Mesh* mesh,Camera* cam){

	for(int s=1;s<=mesh->CountSurfaces();s++){
	
		Surface* surf=mesh->GetSurface(s);

		for(int v=0;v<surf->CountVertices();v++){

			// position
			Entity::TFormPoint(surf->VertexX(v),surf->VertexY(v),surf->VertexZ(v),mesh,cam);
			Vector viewVec(Entity::TFormedX(),Entity::TFormedY(),Entity::TFormedZ());
			viewVec.normalize();
			
			// normal
			Entity::TFormNormal(surf->VertexNX(v),surf->VertexNY(v),surf->VertexNZ(v),mesh,cam);
			Vector norm(Entity::TFormedX(),Entity::TFormedY(),Entity::TFormedZ());

			// reflect
			float d = viewVec.dot( norm );
			Vector r = norm * (2.0*d) - viewVec;
			
			/*
			float m = 2.0 * sqrt( r.x*r.x + r.y*r.y + (r.z+1.0)*(r.z+1.0) );
			float tex_u = r.x/m + 0.5;
			float tex_v = r.y/m + 0.5;
			*/
	
			float p = InvSqrt(
			r[0] * r[0] +
			r[1] * r[1] +
			(r[2]+1) * (r[2]+1) ) * .5f;
			float tex_u = .5f + r[0] * p;
			float tex_v = .5f + r[1] * p;

			surf->VertexTexCoords(v,tex_u,tex_v,0.0,0);
			
		}

	}

}

float Game::InvSqrt(float x){

	union {
		float f;
		int i;
	} tmp;
	tmp.f = x;
	tmp.i = 0x5f3759df - (tmp.i >> 1);
	float y = tmp.f;
	return y * (1.5f - 0.5f * x * y * y);
}