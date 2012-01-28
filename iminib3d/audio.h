/*
 *  audio.h
 *  iminib3d
 *
 *  Created by Simon Harrison on 15/10/2009.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef AUDIO_H
#define AUDIO_H

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Audio{
 
public:
 
	Audio(){
	
		last_channel=1;
	
	};

	vector<AVAudioPlayer*> audio_player;
	int last_channel;

	static Audio* LoadAudio(string filename,int no_channels=1);
	void FreeAudio();
	int PlayAudio(int channel=0);
	int LoopAudio(int channel=0);
	void PauseAudio(int channel=0);
	void StopAudio(int channel=0);
	float AudioVolume(float v=-1.0,int channel=0);
	float AudioPosition(float secs=-1.0,int channel=0);
	int AudioPlaying(int channel=0);
	int FindFreeChannel();
	int LastChannel();

};
 
#endif