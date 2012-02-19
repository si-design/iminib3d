//
//  AppDelegate.h
//  bird
//
//  Created by Simon Harrison on 07/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface b3dAppDelegate : NSObject <UIApplicationDelegate,  UIAccelerometerDelegate> {
    
	IBOutlet UIWindow *window;
	IBOutlet EAGLView *glView;
    
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) EAGLView *glView;

@end