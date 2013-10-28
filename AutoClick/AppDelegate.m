//
//  AppDelegate.m
//  AutoClick
//
//  Created by apple on 13/10/25.
//  Copyright (c) 2013 Kenta Motomura. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// init
	self.timer = nil;
	
	// customize text field formatter to split comma
	[[self.posxField formatter] setGroupingSeparator:@""];
	[[self.posyField formatter] setGroupingSeparator:@""];
	[[self.periodField formatter] setGroupingSeparator:@""];
	[[self.intervalField formatter] setGroupingSeparator:@""];
	
	// set focus
	[self.periodField becomeFirstResponder];
	
	// set window delegate
	self.mainWindowDelegate = [[MainWindowDelegate alloc] init];
	[self.window setDelegate:self.mainWindowDelegate];
}

- (IBAction)pushStart:(id)sender {
	// stop timer if timer is running
	if(self.timer) {
		[self stop];
		return;
	}
	
	// get values
	int posx = [self.posxField intValue];
	int posy = [self.posyField intValue];
	int period = [self.periodField intValue];
	int interval = [self.intervalField intValue];
	[self.statusField setStringValue:@""];
	
	// get date time
	self.startTime = [NSDate timeIntervalSinceReferenceDate];
	self.nowTime = [NSDate timeIntervalSinceReferenceDate];
	self.prevSec = 0;
	
	// create event object
	CGPoint point;
	point.x = (float)posx;
	point.y = (float)posy;
	self.mouseDown = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, point, kCGMouseButtonLeft);
	self.mouseUp = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseUp, point, kCGMouseButtonLeft);
	
	// Esc key handler to exit from burst click
	//self.keyDownHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
	//	if(self.timer != nil && [event keyCode] == (unsigned short)53) {
	//		[self stop];
	//	}
	//}];
	// mouse moving handler to exit from burst click
	self.mouseMovedHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *event) {
		if(self.timer != nil) {
			[self stop];
		}
	}];
	
	// change button text
	[self.startButon setTitle:@"Stop"];
	
	// setup for click
	self.deltaTime = 0.0;
	self.periodTime = (double)period;
	self.clickCount = 0;
	double intervalTime = (double)interval / 1000000.0;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(click:) userInfo:nil repeats:YES];
	
}

- (void)click:(NSTimer *)timer {
	// click
	CGEventPost(kCGHIDEventTap, self.mouseDown);
	CGEventPost(kCGHIDEventTap, self.mouseUp);
	
	// count
	self.clickCount ++;
	
	// update time
	self.nowTime = [NSDate timeIntervalSinceReferenceDate];
	self.deltaTime = self.nowTime - self.startTime;
	
	// show time
	if((int)self.deltaTime > self.prevSec) {
		self.prevSec = (int)self.deltaTime;
		[[self statusField] setStringValue:[[NSString alloc] initWithFormat:@"%d click / %d sec", self.clickCount, self.prevSec]];
	}
	
	// exit if period has finished
	if(self.deltaTime > self.periodTime) {
		[self stop];
	}
	
}

- (void)stop {
	// show click count
	[[self statusField] setStringValue:[[NSString alloc] initWithFormat:@"%d click / %d sec done.", self.clickCount, (int)self.deltaTime]];
	
	// destroy timer
	[self.timer invalidate];
	self.timer = nil;
	
	// stop handling mouse
	[NSEvent removeMonitor:self.mouseMovedHandler];
	self.mouseMovedHandler = nil;
	
	// free
	CFRelease(self.mouseDown);
	CFRelease(self.mouseUp);
	
	// change button text
	[self.startButon setTitle:@"Start"];
}

@end
