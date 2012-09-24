/*
 *  iminib3d.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

// iMiniB3D v0.6
// -------------

// iMiniB3D Terms of Use
// ---------------------

// You are free to use iMiniB3D as you wish.

// iMiniB3D Info
// ------------- 

// You will more than likely need a good grasp of C++ to use iMiniB3D effectively.
// There's no iMiniB3D-specific documentation except what you're reading at the moment.
// Please see the header files for a list of available functions.
// There's mostly the same functions available as in MiniB3D for BlitzMax, with a few differences here and there. See 'MiniB3D -> iMiniB3D Differences' below.
// See the Blitz3D online manual at www.blitzbasic.com for Blitz3D documentation (which MiniB3D and iMiniB3D is based on)

// iMiniB3D is objected-oriented. There's no procedural interface available like there is for MiniB3D.
// So instead of PositionEntity(entity,x,y,z), you must always use entity->PositionEntity(x,y,z).
// For the 'Create' commands, static functions are used, e.g. Mesh* mesh=Mesh::CreateMesh(), Sprite* sprite=Sprite::CreateSprite()

// Please feel free to email me at si@si-design.co.uk about anything. I will try to help if possible.

// Hints and Tips
// --------------

// By default the OpenGL view is displayed in portrait mode
// For landscape mode, rotate your camera on the z axis by 90 degrees - e.g. cam->RotateEntity(0,0,90)
// For best camera FOV, you will need to change your camera's CameraZoom - for Portrait set it to 1.75, for landscape set it to 1.5

// MiniB3D -> iMiniB3D Differences
// -------------------------------

// + iMiniB3D features built-in support for dynamic sphere -> dynamic mesh collisions - set any destination mesh's 'dynamic' flag to true to activate. See test app for example. Don't expect miracles, however!
// - Spheremapping, cubemapping not available in iMiniB3D
// - Anim textures not supported in iMiniB3D
// ~ TextureFilter has been renamed to AddTextureFilter in iMiniB3D
// ~ CopyEntity fully copies a mesh, so there is no shared surface data like there is in Blitz3D. You now cannot use the Mesh commands to affect all copied entities that share the same surface data

// v0.6
// ----

// added iPhone 5 display support
// replaced CreateCube/Sphere/Cylinder/Cone functions with actual Blitz3D code - more efficient

// v0.5
// ----

// new project structure for Xcode 4
// added retina display support
// added new EntityBlend mode - no. 4, pre-multiplied alpha - use this for drawing sprites without black edges
// added teapot example - performs software sphere mapping - slow!
// changed Global::Graphics - now defaults to screen size of device
// fixed FreeEntity bug - freeing anim meshes directly would cause a crash
// fixed FreeEntity bug - freeing lights would cause a crash
// fixed Game::End bug - ClearWorld was called twice
// fixed Camera::Update mem leak - was not freeing new matrix
// fixed CopyEntity mem leak - mem leak when copying meshes and sprites - thanks to ima747
// fixed iOS 5/LLVM problems with LoadAnimMesh/LoadMesh - thanks to Yasha

// v0.4
// ----

// added EntityAutoFade to entity.mm
// added AnimSeq, AnimLength, AnimTime and Animating to entity.mm
// added LoadBank, PokeString, PeekString to bank.mm
// changed Global::Graphics - added optional width and height parameters for iPad support. Defaults to iPhone screen size.
// changed LoadAnimB3D - now loads from bank instead of file - faster
// changed Global::UpdateWorld - split into UpdateCollisions and UpdateAnimations, which you can call separately
// fixed CameraPick bug - first CameraPick didn't work
// fixed banks bug - peeking/poking didn't always work correctly

// v0.3
// ----

// fixed Rnd, Rand
// tidied string helper commands, added Split
// added MeshColor, MeshRed, MeshGreen, MeshBlue, MeshAlpha and SurfaceColor, etc, commands for setting all vertex colors in a mesh/surface at once
// optimised Mesh->Render() so that less OpenGL funcitons calls are made
// fixed AddMesh - was adding duplicate triangles.
// fixed ClearWorld - didn't work
// added applicationWillTerminate method to application delegate, which calls game->End() just before program quits
// changed ReadFile/WriteFile - they now return a NULL File object is unsuccessful, rather than ending program 
// fixed Millisecs - didn't work
// fixed CopyEntity bug - meshes are now fully copied - i.e. no shared surface data.
// fixed EntityScaleY bug (non-global call returned EntityScaleX)
// added TextureFilter functions (TextureFilter renamed to AddTextureFilter)
// added recursive flag to all entity material functions
// added EntityRed, EntityGreen, EntityBlue for when you wish to set entity color components separately
// added 'sprite batch rendering' - will render all sprites using the same texture at once, using a single surface. To activate, use SpriteRenderMode sprite,2

// v0.2
// ----

// added Rnd, Rand, SeedRnd
// added CameraProject, ProjectedX/Y/Z
// reenabled vbo=true as default behaviour
// reenabled LoadMesh. LoadAnimMesh was used in place before
// added UpdateAllEntities, for faster UpdateWorld/RenderWorld - instead of iterating through every entity, only 'root' entities are iterated through (attached to hidden 'root root' entity) and their children - if an entity is hidden, that entities' children aren't iterated through
// added file write functions
// added CopyEntity
// added CreateCone
// added Tilt functions - see tilt app
// added various Touch functions
// fixed FreeEntity bug - camera wasn't being freed from camera list
// added SpriteViewModes 3,4
// fixed Instr bug
// renamed text to string_helper and helper to maths_helper
// added CountAllChildren, GetChildFromAll
// added FindEntity
// fixed FreeEntity bug
// added missing picking commands
// fixed blue ambient light bug
// added Texture::CreateTextTexture
// added EntityClass
// added mipmapping

#ifndef IMINIB3D_H
#define IMINIB3D_H

#include "global.h"
#include "entity.h"
#include "camera.h"
#include "light.h"
#include "pivot.h"
#include "bone.h"
#include "mesh.h"
#include "sprite.h"
#include "sprite_batch.h"
#include "surface.h"
#include "brush.h"
#include "texture.h"
#include "texture_filter.h"
#include "animation.h"
#include "animation_keys.h"
#include "model.h"
#include "pick.h"
#include "collision2.h"
#include "tree.h"
#include "collision.h"
#include "matrix.h"
#include "quaternion.h"
#include "geom.h"
#include "project.h"
#include "maths_helper.h"
#include "string_helper.h"
#include "file.h"
#include "bank.h"
#include "audio.h"
#include "misc.h"
#include "touch.h"
#include "tilt.h"
#include "Texture2D.h"
#include "MachTimer.h"

#include <iostream>
using namespace std;

#endif