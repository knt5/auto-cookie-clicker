//
//  AppDelegate.h
//  AutoClick
//
//  Created by apple on 13/10/25.
//  Copyright (c) 2013 Kenta Motomura. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *posxField;
@property (weak) IBOutlet NSTextField *posyField;
@property (weak) IBOutlet NSTextField *periodField;
@property (weak) IBOutlet NSTextField *intervalField;
@property (weak) IBOutlet NSTextField *statusField;
@property (weak) IBOutlet NSButton *startButon;
- (IBAction)pushStart:(id)sender;

@property (nonatomic) id mouseMovedHandler;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGEventRef mouseDown;
@property (nonatomic) CGEventRef mouseUp;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval nowTime;
@property (nonatomic) NSTimeInterval deltaTime;
@property (nonatomic) NSTimeInterval periodTime;
@property (nonatomic) int prevSec;
@property (nonatomic) int clickCount;
@property (nonatomic) MainWindowDelegate *mainWindowDelegate;
@end
