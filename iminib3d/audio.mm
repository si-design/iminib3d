/*
 *  audio.mm
 *  iminib3d
 *
 *  Created by Simon Harrison on 15/10/2009.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "audio.h"

#include "string_helper.h"

// loads audio. one audio file per channel. specify more than one channel to play multiple sounds at once.
Audio* Audio::LoadAudio(string filename,int no_channels){

	Audio* audio=new Audio;

	string filename_left=Left(filename,Len(filename)-4);
	string filename_right=Right(filename,3);
	
	const char* c_filename_left=filename_left.c_str();
	const char* c_filename_right=filename_right.c_str();
		
	NSString* n_filename_left = [NSString stringWithUTF8String: c_filename_left];
	NSString* n_filename_right = [NSString stringWithUTF8String: c_filename_right];

	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:n_filename_left ofType:n_filename_right]];
	
	if(no_channels<1) no_channels=1;
	
	for(int i=1;i<=no_channels;i++){
	
		audio->audio_player.push_back( [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil] );
	
	}
	
	//delete c_filename_left;
	//delete c_filename_right;
	//[n_filename_left release];
	//[n_filename_right release];
	[fileURL release];

	return audio;
	
}

// frees audio
void Audio::FreeAudio(){

	for(int i=1;i<=audio_player.size();i++){
	
		[audio_player[i-1] release];
	
	}

	delete this;

	return;
	
}

// plays audio. if no channel specified, channel is automatically chosen. returns channel no used
int Audio::PlayAudio(int channel){

	if(channel>audio_player.size()) channel=0;

	if(channel==0) channel=FindFreeChannel();

	if(channel!=0){
	
		last_channel=channel;
	
		[audio_player[channel-1] play];
		
	}

	return channel;

}

// plays and loops audio. if no channel specified, channel is automatically chosen. returns channel no used
int Audio::LoopAudio(int channel){

	if(channel>audio_player.size()) channel=0;
	
	if(channel==0) channel=FindFreeChannel();

	if(channel!=0){

		last_channel=channel;

		audio_player[channel-1].numberOfLoops = -1;

		[audio_player[channel-1] play];
		
	}
	
	return channel;

}

// pauses audio. if no channel specified, last channel used is selected
void Audio::PauseAudio(int channel){

	if(channel==0) channel=last_channel;

	[audio_player[channel-1] pause];

}

// stops audio
void Audio::StopAudio(int channel){

	if(channel==0) channel=last_channel;

	[audio_player[channel-1] stop];

}

// sets audio volume, or returns audio volume if v is a negative value
float Audio::AudioVolume(float v,int channel){

	if(channel==0) channel=last_channel;

	if(v>=0.0){
	
		audio_player[channel-1].volume=v;

	}
	
	return audio_player[channel-1].volume;

}

// sets audio position, or returns audio position if v is a negative value
float Audio::AudioPosition(float secs,int channel){

	if(channel==0) channel=last_channel;

	if(secs>=0.0){

		audio_player[channel-1].currentTime=secs;

	}
	
	return audio_player[channel-1].currentTime;

}

// returns true if audio is playing
int Audio::AudioPlaying(int channel){

	if(channel==0) channel=last_channel;

	return audio_player[channel-1].playing;

}

// finds and returns a free channel no, or 0 if no free channels
int Audio::FindFreeChannel(){

	int channel=0;

	// find free channel
	for(int i=1;i<=audio_player.size();i++){
	
		if(AudioPlaying(i)==false){
		
			channel=i;
			break;
		
		}
	
	}
	
	return channel;

}

// returns last channel used
int Audio::LastChannel(){

	return last_channel;

}