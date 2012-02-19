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

}

void Game::Run(){

	Global::UpdateWorld();
	Global::RenderWorld();
	
}

void Game::End(){

	Global::ClearWorld();

}