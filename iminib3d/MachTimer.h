//
//  MachTimer.h
//
 
#import <UIKit/UIKit.h>
 
#include <assert.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <unistd.h>
 
@interface MachTimer : NSObject {
	uint64_t t0;
}
 
- (void)start;
- (uint64_t)elapsed;
- (float)elapsedSec;
 
@end