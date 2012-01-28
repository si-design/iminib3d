/*
 *  entity.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef ENTITY_H
#define ENTITY_H

#include "surface.h"
#include "matrix.h"
#include "brush.h"
#include "texture.h"
#include "collision2.h"

#include <vector>
#include <list>
#include <cmath>
#include <string>
using namespace std;

class CollisionImpact;

class Entity{
	
public:
		
	// static entity list
	static list<Entity*> entity_list;
	
	// relations
	list<Entity*> child_list;
	Entity* parent;
	
	// transform
	Matrix mat;
	float px,py,pz;
	float sx,sy,sz;
	float rx,ry,rz;
	float qw,qx,qy,qz;

	// material
	Brush brush;
	
	// visibility
	int hide;
	int order;
	float alpha_order;
	int auto_fade;
	float fade_near,fade_far,fade_alpha;
	float cull_radius;

	// properties
	string name;
	string class_name;

	// anim
	static list<Entity*> animate_list;
	int anim; // true if mesh contains anim data
	int anim_render; // true to render as anim mesh
	float anim_mode;
	float anim_time;
	float anim_speed;
	int anim_seq;
	int anim_trans;
	int anim_dir; // 1=forward, -1=backward
	vector<int> anim_seqs_first;
	vector<int> anim_seqs_last;
	int no_seqs;
	int anim_update;
	int anim_list;
	
	// collisions
	int collisions_hide;
	int collision_type;
	float radius_x,radius_y;
	float box_x,box_y,box_z,box_w,box_h,box_d;
	int no_collisions;
	vector<CollisionImpact*> collision;
	float old_x;
	float old_y;
	float old_z;
	float old_pitch;
	float old_yaw;
	float old_roll;
	float new_x;
	float new_y;
	float new_z;
	int new_no;
	
	Matrix old_mat;
	int dynamic; // must be set to true if entity to be destination entity in dynamic->dynamic collisions
	float dynamic_x,dynamic_y,dynamic_z,dynamic_yaw,dynamic_pitch,dynamic_roll;
	
	// picking
	int pick_mode;
	int obscurer;
 
	// tform
	static float tformed_x;
	static float tformed_y;
	static float tformed_z;

	Entity(){
	
		// relations
		parent=NULL;
		
		// transform
		mat.LoadIdentity();
		px=0.0,py=0.0,pz=0.0;
		sx=1.0,sy=1.0,sz=1.0;
		rx=0.0,ry=0.0,rz=0.0;
		qw=1.0,qx=0.0,qy=0.0,qz=0.0;
		
		// material
		//brush=NULL;
		
		// visibility
		hide=false;
		order=0;
		alpha_order=0.0;
		auto_fade=false;
		fade_near=0.0;
		fade_far=0.0;
		fade_alpha=0.0;
		cull_radius=0.0;
		
		// properties
		name="";
		class_name="";
		
		// anim
		anim=false; // true if mesh contains anim data
		anim_render=false; // true to render as anim mesh
		anim_mode=0;
		anim_time=0.0;
		anim_speed=0.0;
		anim_seq=0;
		anim_trans=0;
		anim_dir=1; // 1=forward, -1=backward
		anim_seqs_first.push_back(0);
		anim_seqs_last.push_back(0);
		no_seqs=0;
		anim_update=0;
		anim_list=false;
		
		// collision
		collisions_hide=false;
		radius_x=1.0,radius_y=1.0;
		box_x=-1.0,box_y=-1.0,box_z=-1.0,box_w=2.0,box_h=2.0,box_d=2.0;
		collision_type=0;
		no_collisions=0;
		old_x=0.0;
		old_y=0.0;
		old_z=0.0;
		old_mat.LoadIdentity();
		dynamic=false;
		dynamic_x=0.0,dynamic_y=0.0,dynamic_z=0.0,dynamic_yaw=0.0,dynamic_pitch=0.0,dynamic_roll=0.0;
		new_x=0.0;
		new_y=0.0;
		new_z=0.0;
		new_no=0;
		
		// picking
		pick_mode=0;
		obscurer=false;
											
	}
	
	virtual Entity* CopyEntity(Entity* ent)=0;
	virtual void FreeEntity(void);
	// relations
	void EntityParent(Entity* parent_ent,int glob=true);
	Entity* GetParent();
	int CountChildren();
	Entity* GetChild(int child_no);
	Entity* FindChild(string child_name);
	int CountAllChildren(int no_children=0);
	Entity* GetChildFromAll(int child_no,int &no_children,Entity* ent=NULL);
	void UpdateAllEntities(void(Update)(Entity* ent,Entity* ent2),Entity* ent2=NULL);
	// position
	void PositionEntity(float x,float y,float z,int glob=false);
	void MoveEntity(float mx,float my,float mz);
	void TranslateEntity(float tx,float ty,float tz,int glob=false);
	void ScaleEntity(float x,float y,float z,int glob=false);
	void RotateEntity(float x,float y,float z,int glob=false);
	void TurnEntity(float x,float y,float z,int glob=false);
	void PointEntity(Entity* target_ent,float roll=0.0);
	float EntityX(int global=false);
	float EntityY(int global=false);
	float EntityZ(int global=false);
	float EntityYaw(int global=false);
	float EntityPitch(int global=false);
	float EntityRoll(int global=false);
	float EntityScaleX(int glob=false);
	float EntityScaleY(int glob=false);
	float EntityScaleZ(int glob=false);
	// material
	void EntityColor(float r,float g,float b,float a,int recursive=false);
	void EntityColor(float r,float g,float b,int recursive=false);
	void EntityRed(float r,int recursive=false);
	void EntityGreen(float g,int recursive=false);
	void EntityBlue(float b,int recursive=false);
	void EntityAlpha(float a,int recursive=false);
	void EntityShininess(float s,int recursive=false);
	void EntityBlend(int blend_no,int recursive=false);
	void EntityFX(int fx_no,int recursive=false);
	void EntityTexture(Texture* texture,int frame=0,int index=0,int recursive=false);
	void PaintEntity(Brush& bru,int recursive=false);
	Brush* GetEntityBrush();
	// visibility
	void ShowEntity();
	void HideEntity();
	int Hidden();
	void EntityOrder(int order_no,int recursive=false);
	void EntityAutoFade(float near,float far);
	// properties
	void NameEntity(string e_name);
	string EntityName();
	string EntityClass();
	// anim
	void Animate(int mode=1,float speed=1.0,int seq=0,int trans=0);
	void SetAnimTime(float time,int seq=0);
	int ExtractAnimSeq(int first_frame,int last_frame,int seq=0);
	int AnimSeq();
	int AnimLength();
	float AnimTime();
	int Animating();
	// collisions
	void CollisionsHide();
	void CollisionsShow();
	void EntityType(int type_no,int recursive=false);
	int GetEntityType();
	void EntityRadius(float rx,float ry=0.0);
	void EntityBox(float x,float y,float z,float w,float h,float d);
	void ResetEntity();
	Entity* EntityCollided(int type_no);
	int CountCollisions();
	float CollisionX(int index);
	float CollisionY(int index);
	float CollisionZ(int index);
	float CollisionNX(int index);
	float CollisionNY(int index);
	float CollisionNZ(int index);
	float CollisionTime(int index);
	Entity* CollisionEntity(int index);
	Surface* CollisionSurface(int index);
	int CollisionTriangle(int index);
	// picking	
	void EntityPickMode(int no,int obscure=true);
	// distance
	float EntityDistance(Entity* ent2);
	// tform
	static void TFormPoint(float x,float y,float z,Entity* src_ent,Entity* dest_ent);
	static void TFormVector(float x,float y,float z,Entity* src_ent,Entity* dest_ent);
	static void TFormNormal(float x,float y,float z,Entity* src_ent,Entity* dest_ent);
	static float TFormedX();
	static float TFormedY();
	static float TFormedZ();
	// helper funcs
	void UpdateMat(bool load_identity=false);
	void AddParent(Entity &parent_ent);
	static void UpdateChildren(Entity* ent_p);	
	float EntityDistanceSquared(Entity* ent2);	
	// virtual
	virtual void Update() {};
	virtual void Render() {};
	
};

#endif
