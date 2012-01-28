/*
 *  model.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef MODEL_H
#define MODEL_H

#include "entity.h"
#include "mesh.h"
#include "file.h"
#include "bank.h"

#include <iostream>
//#include <fstream>
#include <string>
using namespace std;

Mesh* LoadAnimB3DFile(string f_name,Entity* parent_ent_ext=NULL);
Mesh* LoadAnimB3D(string f_name,Entity* parent_ent_ext=NULL);

string b3dReadString(File* file);
string ReadTag(File* file);
string b3dReadString(Bank* bank,int &offset);
string ReadTag(Bank* bank,int offset);
int NewTag(string tag);
int TagID(string tag);

/*
const int BRUS;
const int NODE;
const int ANIM;
const int MESH;
const int VRTS;
const int TRIS;
const int BONE;
const int KEYS;
*/

#endif