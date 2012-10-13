//
//  AppDelegate.m
//  iminib3d
//
//  Created by Simon Harrison.
//  Copyright Si Design. All rights reserved.
//

#import "AppDelegate.h"
#import "EAGLView.h"

#include "game.h"
#include "tilt.h"

#include <iostream>
using namespace std;

#define kAccelerometerFrequency		60 // Hz

Game* game;

@implementation b3dAppDelegate

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	[window makeKeyAndVisible];

	glView.animationInterval = 1.0 / 60.0;
	[glView startAnimation];

	UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
	theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
		
	theAccelerometer.delegate = self;
	
    // set root view controller - 4.0 and above only
    NSString *reqSysVer = @"4.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        //UIViewController* vc = [[[UIViewController alloc] init] autorelease];
        //vc.view = glView;
        //window.rootViewController = vc;
    }
    
	game=new Game;
	game->Init();

}


- (void)applicationWillTerminate:(UIApplication *)application
{
	game->End();
	delete game;

}


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 5.0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 60.0;
}

- (void)dealloc {

	game->End();
	delete game;

	[window release];
	[glView release];
	[super dealloc];

}

// Implement this method to get the lastest data from the accelerometer 
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {

	Tilt::SetTilt(acceleration.x,acceleration.y,acceleration.z);
	
}

@end