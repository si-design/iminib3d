/*
 *  entity.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "entity.h"
#include "camera.h"
#include "mesh.h"
#include "animation.h"
#include "pick.h"
#include "maths_helper.h"

list<Entity*> Entity::entity_list;
list<Entity*> Entity::animate_list;

float Entity::tformed_x=0.0;
float Entity::tformed_y=0.0;
float Entity::tformed_z=0.0;

void Entity::FreeEntity(void){

	entity_list.remove(this);
	
	// remove from animate list
	if(anim_update) animate_list.remove(this);
	
	// remove from collision entity lists
	if(collision_type!=0) CollisionPair::ent_lists[collision_type].remove(this);
	
	// remove from pick entity list
	if(pick_mode!=0){
		Pick::ent_list.remove(this);
	}
		
	// free self from parent's child_list
	if(parent!=NULL){
		parent->child_list.remove(this);
	}
	
	// free child entities
	list<Entity*>::iterator it;
	
	for(it=child_list.begin();it!=child_list.end();it++){
		
		if(child_list.size()){
		
			Entity* ent=*it;
		
			ent->FreeEntity();
						
			it=child_list.begin();
			it--;
			
		}else{
		
			break;
		
		}

	}

	return;

}

// relations

void Entity::EntityParent(Entity* parent_ent,int glob){

	if(parent_ent==NULL) parent_ent=Global::root_ent;

	// remove old parent

	// get global values
	float gpx=EntityX(true);
	float gpy=EntityY(true);
	float gpz=EntityZ(true);
	
	float grx=EntityPitch(true);
	float gry=EntityYaw(true);
	float grz=EntityRoll(true);
	
	float gsx=EntityScaleX(true);
	float gsy=EntityScaleY(true);
	float gsz=EntityScaleZ(true);

	// remove self from parent's child list
	if(parent){
		list<Entity*>::iterator it;
		for(it=parent->child_list.begin();it!=parent->child_list.end();it++){
			Entity* ent=*it;
			if(ent==this){
				parent->child_list.remove(this);
				break;
			}
		}
		parent=NULL;
	}

	// entity no longer has parent, so set local values to equal global values
	// must get global values before we reset transform matrix with UpdateMat
	px=gpx;
	py=gpy;
	pz=-gpz;
	rx=-grx;
	ry=gry;
	rz=grz;
	sx=gsx;
	sy=gsy;
	sz=gsz;
	
	//
	
	// No new parent
	if(parent_ent==NULL){
		UpdateMat(true);
		return;
	}
	
	// New parent

	if(parent_ent!=NULL){
		
		if(glob==true){

			AddParent(*parent_ent);

			PositionEntity(gpx,gpy,gpz,true);
			RotateEntity(grx,gry,grz,true);
			///ScaleEntity(gsx,gsy,gsz,true); ***todo*** recursive crash

		}else{
		
			AddParent(*parent_ent);
			UpdateMat();
			
		}
		
	}

}
		
Entity* Entity::GetParent(){
	
	return parent;
	
}

int Entity::CountChildren(){

	int no_children=0;
	
	list<Entity*>::iterator it;
	
	for(it=child_list.begin();it!=child_list.end();it++){

		no_children=no_children+1;

	}

	return no_children;

	//return child_list.size();

}
	
Entity* Entity::GetChild(int child_no){
	
	int no_children=0;
		
	list<Entity*>::iterator it;
	
	for(it=child_list.begin();it!=child_list.end();it++){

		Entity* ent=*it;

		no_children=no_children+1;
		if(no_children==child_no) return ent;

	}

	return NULL;
	
}

Entity* Entity::FindChild(string child_name){
	
	Entity* cent;

	list<Entity*>::iterator it;
	
	for(it=child_list.begin();it!=child_list.end();it++){

		Entity* ent=*it;

		if(ent->EntityName()==child_name) return ent;

		cent=ent->FindChild(child_name);
		
		if(cent!=NULL) return cent;

	}

	return NULL;

}

int Entity::CountAllChildren(int no_children){

	list<Entity*>::iterator it;
	
	for(it=child_list.begin();it!=child_list.end();it++){

		Entity* ent2=*it;

		no_children=no_children+1;
		
		no_children=ent2->CountAllChildren(no_children);

	}

	return no_children;

}

Entity* Entity::GetChildFromAll(int child_no,int &no_children,Entity* ent){

	if(ent==NULL) ent=this;
	
	Entity* ent3=NULL;
	
	list<Entity*>::iterator it;
	
	for(it=ent->child_list.begin();it!=ent->child_list.end();it++){

		Entity* ent2=*it;

		no_children=no_children+1;
		
		if(no_children==child_no) return ent2;
		
		if(ent3==NULL){
		
			ent3=GetChildFromAll(child_no,no_children,ent2);

		}

	}

	return ent3;
		
}

void Entity::UpdateAllEntities(void(Update)(Entity* ent,Entity* ent2),Entity* ent2){

	if(Hidden()) return;

	list<Entity*>::iterator it;
	
	for(it=child_list.begin();it!=child_list.end();it++){

		Entity* child_ent=*it;

		Update(child_ent,ent2);

		child_ent->UpdateAllEntities(Update,ent2);

	}
	
	return;

}

// transform

void Entity::PositionEntity(float x,float y,float z,int global){

	px=x;
	py=y;
	pz=-z;
	
	// conv glob to local. x/y/z always local to parent or global if no parent
	if(global==true && parent!=0){
	
		px=px-parent->EntityX(true);
		py=py-parent->EntityY(true);
		pz=pz+parent->EntityZ(true); // z reversed
	
		float prx=-parent->EntityPitch(true);
		float pry=parent->EntityYaw(true);
		float prz=parent->EntityRoll(true);
	
		float psx=1.0;//parent->EntityScaleX(true);
		float psy=1.0;//parent->EntityScaleY(true);
		float psz=1.0;//parent->EntityScaleZ(true);
	
		Matrix new_mat;
		new_mat.LoadIdentity();
		new_mat.Scale(1.0/psx,1.0/psy,1.0/psz);
		new_mat.RotateRoll(-prz);
		new_mat.RotatePitch(-prx);
		new_mat.RotateYaw(-pry);
		new_mat.Translate(px,py,pz);
	
		px=new_mat.grid[3][0];
		py=new_mat.grid[3][1];
		pz=new_mat.grid[3][2];
	
	}
	
	if(parent!=NULL){
	
		mat.Overwrite(parent->mat);
		UpdateMat();
	
	}else{ // glob=true or false
	
		UpdateMat(true);
	
	}
	
	if(!child_list.empty()){
		Entity::UpdateChildren(this);
	}
	
}

void Entity::MoveEntity(float mx,float my,float mz){

	mz=-mz;

	Matrix new_mat;
	new_mat.LoadIdentity();
	new_mat.RotateYaw(ry);
	new_mat.RotatePitch(rx);
	new_mat.RotateRoll(rz);
	new_mat.Translate(mx,my,mz);

	mx=new_mat.grid[3][0];
	my=new_mat.grid[3][1];
	mz=new_mat.grid[3][2];
	
	px=px+mx;
	py=py+my;
	pz=pz+mz;

	if(parent!=NULL){
	
		mat.Overwrite(parent->mat);
		UpdateMat();
	
	}else{ // glob=true or false
	
		UpdateMat(true);
	
	}
	
	if(!child_list.empty()){
		Entity::UpdateChildren(this);
	}

}

void Entity::TranslateEntity(float tx,float ty,float tz,int glob){

	//tx=x;
	//ty=y;
	tz=-tz;

	// conv glob to local. x/y/z always local to parent or global if no parent
	if(glob==true && parent!=NULL){

		float ax=-parent->EntityPitch(true);
		float ay=parent->EntityYaw(true);
		float az=parent->EntityRoll(true);
					
		Matrix new_mat;
		new_mat.LoadIdentity();
		new_mat.RotateRoll(-az);
		new_mat.RotatePitch(-ax);
		new_mat.RotateYaw(-ay);
		new_mat.Translate(tx,ty,tz);

		tx=new_mat.grid[3][0];
		ty=new_mat.grid[3][1];
		tz=new_mat.grid[3][2];
		
	}
	
	px=px+tx;
	py=py+ty;
	pz=pz+tz;

	if(parent!=NULL){
	
		mat.Overwrite(parent->mat);
		UpdateMat();
	
	}else{ // glob=true or false
	
		UpdateMat(true);
	
	}
	
	if(!child_list.empty()){
		Entity::UpdateChildren(this);
	}

}

void Entity::ScaleEntity(float x,float y,float z,int glob){

	sx=x;
	sy=y;
	sz=z;

	// conv glob to local. x/y/z always local to parent or global if no parent
	if(glob==true && parent!=NULL){
		
		Entity& ent=*this;
					
		do{

			sx=sx/ent.parent->sx;
			sy=sy/ent.parent->sy;
			sz=sz/ent.parent->sz;

			ent=*ent.parent;
								
		}while(ent.parent!=NULL);	

	}

	if(parent!=NULL){
	
		mat.Overwrite(parent->mat);
		UpdateMat();
	
	}else{ // glob=true or false
	
		UpdateMat(true);
	
	}
	
	if(!child_list.empty()){
		Entity::UpdateChildren(this);
	}

}

void Entity::RotateEntity(float x,float y,float z,int global){
	
	rx=-x;
	ry=y;
	rz=z;
	
	// conv glob to local. x/y/z always local to parent or global if no parent
	if(global==true && parent!=0){

		rx=rx+parent->EntityPitch(true);
		ry=ry-parent->EntityYaw(true);
		rz=rz-parent->EntityRoll(true);
	
	}
	
	if(parent!=NULL){
		
		mat.Overwrite(parent->mat);
		UpdateMat();
		
	}else{ // glob=true or false
		
		UpdateMat(true);
		
	}
	
	if(!child_list.empty()){
		Entity::UpdateChildren(this);
	}
	
}

void Entity::TurnEntity(float x,float y,float z,int glob){

	float tx=-x;
	float ty=y;
	float tz=z;

	// conv glob to local. x/y/z always local to parent or global if no parent
	if(glob==true && parent!=NULL){

		//
		
	}
			
	rx=rx+tx;
	ry=ry+ty;
	rz=rz+tz;

	if(parent!=NULL){
		
		mat.Overwrite(parent->mat);
		UpdateMat();
		
	}else{ // glob=true or false
		
		UpdateMat(true);
		
	}
	
	if(!child_list.empty()){
		Entity::UpdateChildren(this);
	}

}

void Entity::PointEntity(Entity* target_ent,float roll){

	float x=target_ent->EntityX(true);
	float y=target_ent->EntityY(true);
	float z=target_ent->EntityZ(true);

	float xdiff=this->EntityX(true)-x;
	float ydiff=this->EntityY(true)-y;
	float zdiff=this->EntityZ(true)-z;

	float dist22=sqrt((xdiff*xdiff)+(zdiff*zdiff));
	float pitch=atan2deg(ydiff,dist22);
	float yaw=atan2deg(xdiff,-zdiff);
	
	this->RotateEntity(pitch,yaw,roll,true);

}

float Entity::EntityX(int global){

	if(global==false){

		return px;

	}else{

		return mat.grid[3][0];

	}

}

float Entity::EntityY(int global){
	
	if(global==false){
		
		return py;
		
	}else{
		
		return mat.grid[3][1];
		
	}
	
}

float Entity::EntityZ(int global){
	
	if(global==false){
		
		return -pz;
		
	}else{
		
		return -mat.grid[3][2];
		
	}
	
}

float Entity::EntityPitch(int global){

	if(global==false){

		return -rx;

	}else{

		float ang=atan2deg( mat.grid[2][1],sqrt( mat.grid[2][0]*mat.grid[2][0]+mat.grid[2][2]*mat.grid[2][2] ) );

		if(ang<=0.0001 && ang>=-0.0001) ang=0;

		return ang;

	}

}

float Entity::EntityYaw(int global){

	if(global==false){

		return ry;

	}else{

		float a=mat.grid[2][0];
		float b=mat.grid[2][2];
		if(a<=0.0001 && a>=-0.0001) a=0;
		if(b<=0.0001 && b>=-0.0001) b=0;
		
		return atan2deg(a,b);

	}

}

float Entity::EntityRoll(int global){

	if(global==false){

		return rz;

	}else{

		float a=mat.grid[0][1];
		float b=mat.grid[1][1];
		if(a<=0.0001 && a>=-0.0001) a=0;
		if(b<=0.0001 && b>=-0.0001) b=0;
			
		return atan2deg(a,b);
		
	}

}

float Entity::EntityScaleX(int glob){

	if(glob==true){

		if(parent){
			
			Entity* ent=this;
				
			float x=sx;
						
			do{

				x=x*ent->parent->sx;

				ent=ent->parent;
									
			}while(ent->parent);
			
			return x;
	
		}
		
	}
	
	return sx;
	
}

float Entity::EntityScaleY(int glob){

	if(glob==true){

		if(parent){
			
			Entity* ent=this;
				
			float y=sy;
						
			do{

				y=y*ent->parent->sy;

				ent=ent->parent;
									
			}while(ent->parent);
			
			return y;
	
		}
		
	}
	
	return sy;
	
}

float Entity::EntityScaleZ(int glob){

	if(glob==true){

		if(parent){
			
			Entity* ent=this;
				
			float z=sz;
						
			do{

				z=z*ent->parent->sz;

				ent=ent->parent;
									
			}while(ent->parent);
			
			return z;
	
		}
		
	}
	
	return sz;
	
}

// material

void Entity::EntityColor(float r,float g,float b,float a,int recursive){

	brush.red=r/255.0;
	brush.green=g/255.0;
	brush.blue=b/255.0;
	brush.alpha=a;
	
	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityColor(r,g,b,a,true);
		
		}
	
	}
		
}

void Entity::EntityColor(float r,float g,float b,int recursive){

	brush.red=r/255.0;
	brush.green=g/255.0;
	brush.blue=b/255.0;
	
	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityColor(r,g,b,true);
		
		}
	
	}
		
}

void Entity::EntityRed(float r,int recursive){

	brush.red=r/255.0;

	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityRed(r,true);
		
		}
	
	}
		
}

void Entity::EntityGreen(float g,int recursive){

	brush.green=g/255.0;

	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityGreen(g,true);
		
		}
	
	}
		
}

void Entity::EntityBlue(float b,int recursive){

	brush.blue=b/255.0;

	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityBlue(b,true);
		
		}
	
	}
		
}

void Entity::EntityAlpha(float a,int recursive){
	
	brush.alpha=a;
	
	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityAlpha(a,true);
		
		}
	
	}
			
}
	
void Entity::EntityShininess(float s,int recursive){
	
	brush.shine=s;
	
	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityShininess(s,true);
		
		}
	
	}
	
}
	
void Entity::EntityBlend(int blend_no,int recursive){
	
	brush.blend=blend_no;
	
	if(dynamic_cast<Mesh*>(this)){
	
		Mesh* mesh=dynamic_cast<Mesh*>(this);
		
		// overwrite surface blend modes with master blend mode
		list<Surface*>::iterator it;
		
		for(it=mesh->surf_list.begin();it!=mesh->surf_list.end();it++){
			
			Surface &surf=**it;
			
			//if(surf.brush!=NULL){
				surf.brush->blend=brush.blend;
			//}
			
		}
		
	}
	
	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityBlend(blend_no,true);
		
		}
	
	}
		
}
	
void Entity::EntityFX(int fx_no,int recursive){	
	
	brush.fx=fx_no;
	
	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityFX(fx_no,true);
		
		}
	
	}
		
}

void Entity::EntityTexture(Texture* texture,int frame,int index,int recursive){

	brush.tex[index]=texture;
	if(index+1>brush.no_texs) brush.no_texs=index+1;
	
	if(frame<0) frame=0;
	//if(frame>texture.no_frames-1) frame=texture.no_frames-1;
	brush.tex_frame=frame;
	
	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityTexture(texture,frame,index,true);
		
		}
	
	}
	
}

void Entity::PaintEntity(Brush& bru,int recursive){
	
	brush.no_texs=bru.no_texs;
	brush.name=bru.name;
	brush.red=bru.red;
	brush.green=bru.green;
	brush.blue=bru.blue;
	brush.alpha=bru.alpha;
	brush.shine=bru.shine;
	brush.blend=bru.blend;
	brush.fx=bru.fx;
	for(int i=0;i<7;i++){
		brush.tex[i]=bru.tex[i];
	}
	
}

Brush* Entity::GetEntityBrush(){

	return brush.Copy();
	
}

// visibility

void Entity::ShowEntity(){

	hide=false;
	
}

void Entity::HideEntity(){

	hide=true;

}

int Entity::Hidden(){

	if(hide==true) return true;
	
	Entity* ent=parent;
	while(ent){
		if(ent->hide==true) return true;
		ent=ent->parent;
	}
	
	return false;

}

void Entity::EntityOrder(int order_no,int recursive){

	order=order_no;

	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityOrder(order,true);
		
		}
	
	}

}

void Entity::EntityAutoFade(float near,float far){

	auto_fade=true;
	fade_near=near;
	fade_far=far;

}

// properties

void Entity::NameEntity(string e_name){
	
	name=e_name;
	
}

string Entity::EntityName(){
	
	return name;
	
}

string Entity::EntityClass(){
	
	return class_name;
	
}

// anim

void Entity::Animate(int mode,float speed,int seq,int trans){
	
	anim_mode=mode;
	anim_speed=speed;
	anim_seq=seq;
	anim_trans=trans;
	anim_time=anim_seqs_first[seq];
	anim_update=true; // update anim for all modes (including 0)
		
	if(trans>0){
		anim_time=0;
	}
	
	// add to animate list if not already in list
	if(anim_list==false){
		anim_list=true;
		animate_list.push_back(this);
	}
		
}

void Entity::SetAnimTime(float time,int seq){

	anim_mode=-1; // use a mode of -1 for setanimtime
	anim_speed=0.0;
	anim_seq=seq;
	anim_trans=0;
	anim_time=time;
	anim_update=false; // set anim_update to false so UpdateWorld won't animate entity

	int first=anim_seqs_first[anim_seq];
	int last=anim_seqs_last[anim_seq];
	int first2last=anim_seqs_last[anim_seq]-anim_seqs_first[anim_seq];
	
	time=time+first; // offset time so that anim time of 0 will equal first frame of sequence
	
	if(time>last && first2last>0){ // check that first2last>0 to prevent infinite loop
		do{
			time=time-first2last;
		}while(time>last);
	}
	if(time<first && first2last>0){ // check that first2last>0 to prevent infinite loop
		do{
			time=time+first2last;
		}while(time<first);
	}
	
	if(dynamic_cast<Mesh*>(this)!=NULL){
		Animation::AnimateMesh(dynamic_cast<Mesh*>(this),time,first,last);
	}

	anim_time=time; // update anim_time# to equal time#

}

int Entity::ExtractAnimSeq(int first_frame,int last_frame,int seq){

	no_seqs=no_seqs+1;

	// expand anim_seqs array
	anim_seqs_first.push_back(0);
	anim_seqs_last.push_back(0);

	// if seq specifed then extract anim sequence from within existing sequnce
	int offset=0;
	if(seq!=0){
		offset=anim_seqs_first[seq];
	}

	anim_seqs_first[no_seqs]=first_frame+offset;
	anim_seqs_last[no_seqs]=last_frame+offset;
	
	return no_seqs;

}

int Entity::AnimSeq(){

	return anim_seq; // current anim sequence

}

int Entity::AnimLength(){

	return anim_seqs_last[anim_seq]-anim_seqs_first[anim_seq]; // no of frames in anim sequence

}

float Entity::AnimTime(){

	// if animation in transition, return 0 (anim_time actually will be somewhere between 0 and 1)
	if(anim_trans>0) return 0;
	
	// for animate and setanimtime we want to return anim_time starting from 0 and ending at no. of frames in sequence
	if(anim_mode>0 || anim_mode==-1){
		return anim_time-anim_seqs_first[anim_seq];
	}

	return 0;

}

int Entity::Animating(){

	if(anim_trans>0) return true;
	if(anim_mode>0) return true;
	
	return false;

}

// collision

void Entity::CollisionsHide(){

	collisions_hide=true;

}

void Entity::CollisionsShow(){

	collisions_hide=false;

}

void Entity::EntityType(int type_no,int recursive){

	// add to collision entity list if new type no<>0 and not previously added
	if(collision_type==0 && type_no!=0){
			
		CollisionPair::ent_lists[type_no].push_back(this);
		
	}
	
	// remove from collision entity list if new type no=0 and previously added
	if(collision_type!=0 && type_no==0){
		CollisionPair::ent_lists[type_no].remove(this);
	}
	
	collision_type=type_no;
	
	old_x=EntityX(true);
	old_y=EntityY(true);
	old_z=EntityZ(true);

	if(recursive==true){
	
		list<Entity*>::iterator it;
	
		for(it=child_list.begin();it!=child_list.end();it++){
		
			Entity& ent=**it;
		
			ent.EntityType(type_no,true);
		
		}
	
	}
	
}

int Entity::GetEntityType(){

	return collision_type;

}

void Entity::EntityRadius(float rx,float ry){

	radius_x=rx;
	if(ry==0.0){
		radius_y=rx;
	}else{
		radius_y=ry;
	}

}

void Entity::EntityBox(float x,float y,float z,float w,float h,float d){

	box_x=x;
	box_y=y;
	box_z=z;
	box_w=w;
	box_h=h;
	box_d=d;

}

void Entity::ResetEntity(){

	no_collisions=0;
	for(int ix=0;ix<collision.size();ix++){
		delete collision[ix];
	}
	collision.clear();	

	old_x=EntityX(true);
	old_y=EntityY(true);
	old_z=EntityZ(true);
	old_pitch=EntityPitch(true);
	old_yaw=EntityYaw(true);
	old_roll=EntityRoll(true);
	new_x=old_x;
	new_y=old_y;
	new_z=old_z;

}

Entity* Entity::EntityCollided(int type_no){

	// if self is source entity and type_no is dest entity
	for(int i=1;i<=CountCollisions();i++){
		if(CollisionEntity(i)->collision_type==type_no) return CollisionEntity(i);
	}

	// if self is dest entity and type_no is src entity
	list<Entity*>::iterator it;
	
	for(it=CollisionPair::ent_lists[type_no].begin();it!=CollisionPair::ent_lists[type_no].end();it++){
	
		Entity* ent=*it;
	
		for(int i=1;i<=ent->CountCollisions();i++){
			if(CollisionEntity(i)==this) return ent;
		}
	}

	return NULL;

}

int Entity::CountCollisions(){

	return no_collisions;

}

float Entity::CollisionX(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->x;
	
	}
	
	return NULL;

}

float Entity::CollisionY(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->y;
	
	}
	
	return NULL;

}

float Entity::CollisionZ(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->z;
	
	}
	
	return NULL;

}

float Entity::CollisionNX(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->nx;
	
	}
	
	return NULL;

}

float Entity::CollisionNY(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->ny;
	
	}
	
	return NULL;

}

float Entity::CollisionNZ(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->nz;
	
	}
	
	return NULL;

}

float Entity::CollisionTime(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->time;
	
	}
	
	return NULL;

}

Entity* Entity::CollisionEntity(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->ent;
	
	}
	
	return NULL;

}

Surface* Entity::CollisionSurface(int index){

	if(index>0 && index<=no_collisions){

		return collision[index-1]->surf;
	
	}
	
	return NULL;

}

int Entity::CollisionTriangle(int index){

	if(index>0 && index<=no_collisions){
	
		return collision[index-1]->tri;
	
	}
	
	return NULL;

}

// picking

void Entity::EntityPickMode(int no,int obscure){

	// add to pick entity list if new mode no<>0 and not previously added
	if(pick_mode==0 && no!=0){
	
		Pick::ent_list.push_back(this);
		
	}
	
	// remove from pick entity list if new mode no=0 and previously added
	if(pick_mode!=0 && no==0){
	
		Pick::ent_list.remove(this);
		
	}

	pick_mode=no;
	obscurer=obscure;
			
}

// distance

float Entity::EntityDistance(Entity* ent2){

	return sqrt(EntityDistanceSquared(ent2));

}

// tform

void Entity::TFormPoint(float x,float y,float z,Entity* src_ent,Entity* dest_ent){

	Matrix mat;

	if(src_ent){

		mat.Overwrite(src_ent->mat);
		mat.Translate(x,y,-z);
		
		x=mat.grid[3][0];
		y=mat.grid[3][1];
		z=-mat.grid[3][2];
	
	}

	if(dest_ent){

		mat.LoadIdentity();
	
		Entity* ent=dest_ent;
		
		do{

			mat.Scale(1.0/ent->sx,1.0/ent->sy,1.0/ent->sz);
			mat.RotateRoll(-ent->rz);
			mat.RotatePitch(-ent->rx);
			mat.RotateYaw(-ent->ry);
			mat.Translate(-ent->px,-ent->py,-ent->pz);																																																																																																																																																																																																																																																																																																																																									

			ent=ent->parent;
		
		}while(ent);
	
		mat.Translate(x,y,-z);
		
		x=mat.grid[3][0];
		y=mat.grid[3][1];
		z=-mat.grid[3][2];
		
	}
	
	tformed_x=x;
	tformed_y=y;
	tformed_z=z;
	
}

void Entity::TFormVector(float x,float y,float z,Entity* src_ent,Entity* dest_ent){

	Matrix mat;

	if(src_ent){

		mat.Overwrite(src_ent->mat);
		
		mat.grid[3][0]=0;
		mat.grid[3][1]=0;
		mat.grid[3][2]=0;
		mat.grid[3][3]=1;
		mat.grid[0][3]=0;
		mat.grid[1][3]=0;
		mat.grid[2][3]=0;
			
		mat.Translate(x,y,-z);

		x=mat.grid[3][0];
		y=mat.grid[3][1];
		z=-mat.grid[3][2];
	
	}

	if(dest_ent){

		mat.LoadIdentity();
		//mat.Translate(x#,y#,z#)
	
		Entity* ent=dest_ent;
		
		do{

			mat.Scale(1.0/ent->sx,1.0/ent->sy,1.0/ent->sz);
			mat.RotateRoll(-ent->rz);
			mat.RotatePitch(-ent->rx);
			mat.RotateYaw(-ent->ry);
			//mat.Translate(-ent.px,-ent.py,-ent.pz)																																																																																																																																																																																																																																																																																																																																									

			ent=ent->parent;
		
		}while(ent);
	
		mat.Translate(x,y,-z);
		
		x=mat.grid[3][0];
		y=mat.grid[3][1];
		z=-mat.grid[3][2];
		
	}
	
	tformed_x=x;
	tformed_y=y;
	tformed_z=z;

}

void Entity::TFormNormal(float x,float y,float z,Entity* src_ent,Entity* dest_ent){

	TFormVector(x,y,z,src_ent,dest_ent);
	
	float uv=sqrt((tformed_x*tformed_x)+(tformed_y*tformed_y)+(tformed_z*tformed_z));
	
	tformed_x/=uv;
	tformed_y/=uv;
	tformed_z/=uv;

}

float Entity::TFormedX(){

	return tformed_x;

}

float Entity::TFormedY(){

	return tformed_y;

}

float Entity::TFormedZ(){

	return tformed_z;

}

// helper funcs

void Entity::UpdateMat(bool load_identity){

	if(load_identity==true){
		mat.LoadIdentity();
		mat.Translate(px,py,pz);
		mat.Rotate(rx,ry,rz);
		mat.Scale(sx,sy,sz);
	}else{
		mat.Translate(px,py,pz);
		mat.Rotate(rx,ry,rz);
		mat.Scale(sx,sy,sz);
	}

}

void Entity::AddParent(Entity &parent_ent){

	// self.parent = parent_ent
	parent=&parent_ent;

	//add self to parent_ent child list
	if(parent!=NULL){

		mat.Overwrite(parent->mat);

		parent->child_list.push_back(this);

	}
	
}

void Entity::UpdateChildren(Entity* ent_p){

	list<Entity*>::iterator it;
	
	for(it=ent_p->child_list.begin();it!=ent_p->child_list.end();it++){

		Entity* p=*it;
		
		p->mat.Overwrite(ent_p->mat);
		p->UpdateMat();

		UpdateChildren(p);

	}
	
}

float Entity::EntityDistanceSquared(Entity* ent2){

	float xd = ent2->mat.grid[3][0]-mat.grid[3][0];
	float yd = ent2->mat.grid[3][1]-mat.grid[3][1];
	float zd = -ent2->mat.grid[3][2]+mat.grid[3][2];
			
	return xd*xd + yd*yd + zd*zd;
	
}
