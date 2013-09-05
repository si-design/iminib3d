//
//  EAGLView.m
//  iminib3d
//
//  Created by Simon Harrison.
//  Copyright Si Design. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
//#import "AppDelegate.h"

#include "game.h"
#include "touch.h"

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

#define USE_DEPTH_BUFFER 1

extern Game* game;

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end



@implementation EAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;

@synthesize  location;
@synthesize  previousLocation;


// You must implement this
+ (Class)layerClass {
	return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {

	if ((self = [super initWithCoder:coder])) {
	
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [self respondsToSelector:@selector(setContentScaleFactor:)]) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale]; // activate scaling
    }
    #endif
    
		// Set up the ability to track multiple touches.
		[self setMultipleTouchEnabled:YES];
	
		// Get the layer
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) {
			[self release];
			return nil;
		}
		
		animationInterval = 1.0 / 60.0;
	}
	return self;
}

- (void)drawView { // RenderWorld

	// Replace the implementation of this method to do your own custom drawing
	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	game->Run();

	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
}

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches1 withEvent:(UIEvent *)event
{

	Touch::ClearTouches();

  NSSet *touches = [event allTouches];
  for (UITouch *myTouch in touches)
  {
	
		int touch_type=0;
	
    if(myTouch.phase == UITouchPhaseBegan){
			touch_type=1;
    }
    if(myTouch.phase == UITouchPhaseMoved){
			touch_type=2;
    }
    if(myTouch.phase == UITouchPhaseStationary){
			touch_type=3;
    }
    if(myTouch.phase == UITouchPhaseEnded) {
			touch_type=4;
		}
    if(myTouch.phase == UITouchPhaseCancelled) {
			touch_type=5;
		}
		
		if(touch_type){
		
			CGRect bounds = [self bounds];

			location = [myTouch locationInView:self];
			location.y = bounds.size.height - location.y;

			previousLocation = [myTouch previousLocationInView:self];
			previousLocation.y = bounds.size.height - previousLocation.y;
			
			new Touch(location.x,location.y,previousLocation.x,previousLocation.y,touch_type);
		
		}

  }

}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches1 withEvent:(UIEvent *)event
{  

	Touch::ClearTouches();

  NSSet *touches = [event allTouches];
  for (UITouch *myTouch in touches)
  {

    int touch_type=0;

    if(myTouch.phase == UITouchPhaseBegan){
      touch_type=1;
    }
    if(myTouch.phase == UITouchPhaseMoved){
      touch_type=2;
    }
    if(myTouch.phase == UITouchPhaseStationary){
      touch_type=3;
    }
    if(myTouch.phase == UITouchPhaseEnded) {
      touch_type=4;
    }
    if(myTouch.phase == UITouchPhaseCancelled) {
      touch_type=5;
    }
  
    if(touch_type){
  
      CGRect bounds = [self bounds];

      location = [myTouch locationInView:self];
      location.y = bounds.size.height - location.y;

      previousLocation = [myTouch previousLocationInView:self];
      previousLocation.y = bounds.size.height - previousLocation.y;
    
      new Touch(location.x,location.y,previousLocation.x,previousLocation.y,touch_type);
  
    }

  }

}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches1 withEvent:(UIEvent *)event
{

	Touch::ClearTouches();

  NSSet *touches = [event allTouches];
  for (UITouch *myTouch in touches)
  {
	
		int touch_type=0;
	
    if(myTouch.phase == UITouchPhaseBegan){
			touch_type=1;
    }
    if(myTouch.phase == UITouchPhaseMoved){
			touch_type=2;
    }
    if(myTouch.phase == UITouchPhaseStationary){
			touch_type=3;
    }
    if(myTouch.phase == UITouchPhaseEnded) {
			touch_type=4;
		}
    if(myTouch.phase == UITouchPhaseCancelled) {
			touch_type=5;
		}
		
		if(touch_type){
		
			CGRect bounds = [self bounds];

			location = [myTouch locationInView:self];
			location.y = bounds.size.height - location.y;

			previousLocation = [myTouch previousLocationInView:self];
			previousLocation.y = bounds.size.height - previousLocation.y;
			
			new Touch(location.x,location.y,previousLocation.x,previousLocation.y,touch_type);
		
		}

  }

}

- (void)touchesCancelled:(NSSet *)touches1 withEvent:(UIEvent *)event
{

	Touch::ClearTouches();

  NSSet *touches = [event allTouches];
  for (UITouch *myTouch in touches)
  {
	
		int touch_type=0;
	
    if(myTouch.phase == UITouchPhaseBegan){
			touch_type=1;
    }
    if(myTouch.phase == UITouchPhaseMoved){
			touch_type=2;
    }
    if(myTouch.phase == UITouchPhaseStationary){
			touch_type=3;
    }
    if(myTouch.phase == UITouchPhaseEnded) {
			touch_type=4;
		}
    if(myTouch.phase == UITouchPhaseCancelled) {
			touch_type=5;
		}
		
		if(touch_type){
		
			CGRect bounds = [self bounds];

			location = [myTouch locationInView:self];
			location.y = bounds.size.height - location.y;

			previousLocation = [myTouch previousLocationInView:self];
			previousLocation.y = bounds.size.height - previousLocation.y;
			
			new Touch(location.x,location.y,previousLocation.x,previousLocation.y,touch_type);
		
		}

  }

}

- (void)layoutSubviews {
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self drawView];
}

- (BOOL)createFramebuffer {
	
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	if (USE_DEPTH_BUFFER) {
		glGenRenderbuffersOES(1, &depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	}

	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}


- (void)destroyFramebuffer {
	
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}


- (void)startAnimation {
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
	self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
	[animationTimer invalidate];
	animationTimer = newTimer;
}

/*
- (void)setAnimationInterval:(NSTimeInterval)interval {
	
	animationInterval = interval;
	if (animationTimer) {
		[self stopAnimation];
		[self startAnimation];
	}
}
*/

- (void)dealloc {
	
	[self stopAnimation];
	
	if ([EAGLContext currentContext] == context) {
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];	
	[super dealloc];
}

@end


