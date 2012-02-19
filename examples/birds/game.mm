/*
 *  game.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "game.h"

float icv[nchannels-1+1];				// stores interpolated channel values
KeyFrame* key0=NULL;
KeyFrame* key1=NULL;

void Game::Init(){

	Global::Graphics();

	cmot=new Motion;
	b2mot=new Motion;
	b1mot=new Motion;

	if(Load_Motion("Cam.bbm",cmot)==false) RuntimeError("Error loading file");
	if(Load_Motion("Bird1.bbm",b1mot)==false) RuntimeError("Error loading file");
	if(Load_Motion("Bird2.bbm",b2mot)==false) RuntimeError("Error loading file");

	piv=Pivot::CreatePivot();
	piv->PositionEntity(0.0,0.0,0.0);

	camera=Camera::CreateCamera(piv);
	camera->RotateEntity(0.0,0.0,0);
	camera->CameraRange(1,3000);

	Global::AmbientLight(90,90,90);
	light_sun=Light::CreateLight(1);
	light_sun->LightColor(200,200,100);
	light_sun->RotateEntity(60,-90,0);

	mesh_canyon=Mesh::LoadMesh("Canyon.b3d");
	mesh_canyon->RotateEntity(0,180,0);

	mesh_skybox=MakeSkyBox("sky");

	mesh_bird=Mesh::LoadAnimMesh("Bird.b3d");
	mesh_bird2=mesh_bird->CopyEntity();

	Apply_Motion(cmot,0,camera,0);
	Apply_Motion(b1mot,0,mesh_bird,180);
	Apply_Motion(b2mot,0,mesh_bird2,180);
	
	fstep=1;

}

void Game::Run(){

	fstep=fstep+0.25;
	anim_time=anim_time+0.5;
	
	if(fstep>cmot->nsteps) fstep=1;

	mesh_bird->SetAnimTime(anim_time);
	mesh_bird2->SetAnimTime(anim_time+10.0);
	
	Apply_Motion(cmot,fstep,camera,0,90);
	Apply_Motion(b1mot,fstep,mesh_bird,180);
	Apply_Motion(b2mot,fstep,mesh_bird2,180);
	
	mesh_skybox->PositionEntity(camera->EntityX(1),camera->EntityY(1),camera->EntityZ(1));

	Global::RenderWorld();

}

Mesh* Game::MakeSkyBox( string file ){

	Mesh* m=Mesh::CreateMesh();
	
	// front face
	Brush* b=Brush::LoadBrush(file+"_FR.bmp",49);
	Surface* s=m->CreateSurface();
	s->AddVertex(-1,+1,-1,0,0);
	s->AddVertex( 1, 1,-1,1,0);
	s->AddVertex( 1,-1,-1,1,1);
	s->AddVertex(-1,-1,-1,0,1);
	s->AddTriangle(0,1,2);
	s->AddTriangle(0,2,3);
	s->PaintSurface(b);
	b->FreeBrush();
	
	// right face
	b=Brush::LoadBrush(file+"_LF.bmp",49);
	s=m->CreateSurface();
	s->AddVertex( 1, 1,-1,0,0);
	s->AddVertex( 1, 1, 1,1,0);
	s->AddVertex( 1,-1, 1,1,1);
	s->AddVertex( 1,-1,-1,0,1);
	s->AddTriangle(0,1,2);
	s->AddTriangle(0,2,3);
	s->PaintSurface(b);
	b->FreeBrush();
	
	// back face
	b=Brush::LoadBrush(file+"_BK.bmp",49);
	s=m->CreateSurface();
	s->AddVertex( 1, 1, 1,0,0);
	s->AddVertex(-1, 1, 1,1,0);
	s->AddVertex(-1,-1, 1,1,1);
	s->AddVertex( 1,-1, 1,0,1);
	s->AddTriangle(0,1,2);
	s->AddTriangle(0,2,3);
	s->PaintSurface(b);
	b->FreeBrush();
	
	// left face
	b=Brush::LoadBrush(file+"_RT.bmp",49);
	s=m->CreateSurface();
	s->AddVertex(-1, 1, 1,0,0);
	s->AddVertex(-1, 1,-1,1,0);
	s->AddVertex(-1,-1,-1,1,1);
	s->AddVertex(-1,-1,+1,0,1);
	s->AddTriangle(0,1,2);
	s->AddTriangle(0,2,3);
	s->PaintSurface(b);
	b->FreeBrush();
	
	// top face
	b=Brush::LoadBrush(file+"_UP.bmp",49);
	s=m->CreateSurface();
	s->AddVertex(-1, 1, 1,0,1);
	s->AddVertex( 1, 1, 1,0,0);
	s->AddVertex( 1, 1,-1,1,0);
	s->AddVertex(-1, 1,-1,1,1);
	s->AddTriangle(0,1,2);
	s->AddTriangle(0,2,3);
	s->PaintSurface(b);
	b->FreeBrush();

	m->ScaleMesh(1700,1700,1700);
	m->FlipMesh();
	m->EntityFX(1);
	return m;
	
}

void Game::End(){

	Global::ClearWorld();

}

//-------------------------------------------------------------------------------------
//									FUNCTIONS
//-------------------------------------------------------------------------------------

float Parse(string s,int o){

	string a,d;
	int bb,b;
	float e,even;
	s=Trim(s)+" ";
	d="";
	bb=0;
	e=0;
	even=true;

	for(b=1;b<=Len(s);b++){

		a=Mid(s,b,1);

		if(a=="'"){
			e=e+1;
			even=((e/2)==int(e/2));
		}
	
		if(a==" "){
			if(even==true){
				bb=bb+1;
				if(bb==o){
					//string s=Trim(Replace(d,"'"," "));
					string ss=Trim(d);
					float f=ToFloat(ss);
					return f;
				}else{
					d="";
				}
			}
		}

		d=d+a;

	}

	return 0.0;

}

int Load_Motion(string file,Motion* m){

	File* f;
	string s="";
	int i=0,ii=0;

	f=File::ReadResourceFile(file);
	if(f==false) return false;

	string line1=f->ReadLine();
	string line2=f->ReadLine();
	string line3=f->ReadLine(); // dummy

	if(line1!="B3D Motion") return false;
	if(line2!="1") return false;

	m->nkeys = ToInt(f->ReadLine());

	for(i=0;i<=m->nkeys;i++){									// read keyframe data
	
		string s=f->ReadLine();
		m->keylist[i]=new KeyFrame;
		m->keylist[i]->fstep=int(Parse(s,1));

		for(ii=0;ii<=nchannels-1;ii++){
			m->keylist[i]->cv[ii]=float(Parse(s,2+ii));
		}
		
		m->keylist[i]->linear=int(Parse(s,11));
		m->keylist[i]->tens=float(Parse(s,12));
		m->keylist[i]->cont=float(Parse(s,13));
		m->keylist[i]->bias=float(Parse(s,14));

	}
	
	m->nsteps=m->keylist[m->nkeys-1]->fstep;

	f->CloseFile();
	return true;

}
//------------------------------------------------------------------------

//------------------------------------------------------------------------
void Apply_Motion(Motion* m,float tstep,Entity* e,int rot,int rot2){

	float dd0a=0.0,dd0b=0.0,ds1a=0.0,ds1b=0.0;
	float adj0=0.0,adj1=0.0,dd0=0.0,ds1=0.0,d2=0.0,t=0.0,d10=0.0;
	float t2=0.0,t3=0.0,z=0.0,h[3+1]={0.0};
	int i=0,tlen=0,key=0;

	//*** If there's only one key, the channel values are constant ***

	if(m->nkeys==1){
		for(i=0;i<=nchannels-1;i++){
			icv[i]=m->keylist[0]->cv[i];
		}
		return;
	}

	//*** find keyframe pair to interpolate between ***

	if(tstep<m->keylist[0]->fstep) return;

	for(key=1;key<=m->nkeys;key++){
		//cout << "tstep: " << tstep << " fstep: " << m->keylist[key]->fstep << endl;
		if(tstep<=m->keylist[key]->fstep) break;
	}
	if(key>m->nkeys){
		key=m->nkeys;
	}
	
	key1=m->keylist[key];

	//cout << "key: " << key << "m->nkeys: " << m->nkeys << endl;
	if(key==m->nkeys) return;

	key0=m->keylist[key-1];

	tlen=key1->fstep-key0->fstep;
	t=(tstep-key0->fstep)/tlen;

	if(key1->linear==0){
   
		//*** precompute hermite spline coefficients ***

		t2=t*t;
		t3=t*t2;
		z=3*t2-t3-t3;

		h[0]=1-z;
		h[1]=z;
		h[2]=t3-t2-t2+t;
		h[3]=t3-t2;
		  
		dd0a=(1-key0->tens)*(1+key0->cont)*(1+key0->bias);
		dd0b=(1-key0->tens)*(1-key0->cont)*(1-key0->bias);
		ds1a=(1-key1->tens)*(1-key1->cont)*(1+key1->bias);
		ds1b=(1-key1->tens)*(1+key1->cont)*(1-key1->bias);

		if(key0->fstep!=0){
			d2=(key1->fstep-m->keylist[key - 2]->fstep);
			adj0=tlen/d2;
		}
	  
		if(key1->fstep!=m->nsteps){
			d2=(m->keylist[key+1]->fstep-key0->fstep);
			adj1=tlen/d2;
		}
      
	}

	//*** compute channel components And store in icv() ***

	for(i=0;i<=nchannels-1;i++){

		d10=key1->cv[i]-key0->cv[i];

		if(key1->linear==0){
         
			if(key0->fstep==0){
				dd0=0.5*(dd0a+dd0b)*d10;
			}else{
				dd0=adj0*(dd0a*(key0->cv[i]-m->keylist[key-2]->cv[i])+dd0b*d10);
			}
         
			if(key1->fstep==m->nsteps){
				ds1=0.5*(ds1a+ds1b)*d10;
			}else{
				ds1=adj1*(ds1a*d10+ds1b*(m->keylist[key+1]->cv[i]-key1->cv[i]));
			}
         
			icv[i]=(h[0]*key0->cv[i])+(h[1]*key1->cv[i])+(h[2]*dd0)+(h[3]*ds1);

		}else{
		
			icv[i]=key0->cv[i]+t*d10;

		}

	}

	e->PositionEntity(icv[0],icv[1],icv[2]);
	e->RotateEntity(icv[3],icv[4]+rot,icv[5]+rot2);
	e->ScaleEntity(icv[6],icv[7],icv[8]);

}

