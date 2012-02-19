//
//  EAGLView.h
//  iminib3d
//
//  Created by Simon Harrison.
//  Copyright Si Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#define kFilteringFactor			0.1 // For filtering out gravitational affects

/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView {
		
	CGPoint				location;
	CGPoint				previousLocation;
	Boolean				firstTouch;
	
@private
	/* The pixel dimensions of the backbuffer */
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	
	/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
	GLuint viewRenderbuffer, viewFramebuffer;
	
	/* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
	GLuint depthRenderbuffer;
	
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;
}

@property NSTimeInterval animationInterval;

@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end

