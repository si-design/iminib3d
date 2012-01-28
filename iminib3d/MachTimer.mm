//
//  MachTimer.m
//
 
#import "MachTimer.h"
 
static mach_timebase_info_data_t timebase;
 
@implementation MachTimer
+ (void)initialize
{
	(void) mach_timebase_info(&timebase);
}
 
 
- init
{
	if(self = [super init]) {
		t0 = mach_absolute_time();
	}
	return self;
}
 
- (void)start
{
	t0 = mach_absolute_time();
}
 
- (uint64_t)elapsed {
	return mach_absolute_time() - t0;
}
 
- (float)elapsedSec {
	return ((float)(mach_absolute_time() - t0)) * ((float)timebase.numer) / ((float)timebase.denom) / 1000000000.0f;
}
@end