//
//  MainWindowDelegate.m
//  AutoClick
//
//  Created by apple on 13/10/28.
//  Copyright (c) 2013 Kenta Motomura. All rights reserved.
//

#import "MainWindowDelegate.h"

@implementation MainWindowDelegate

-(void)windowWillClose:(NSNotification *)notification {
	[NSApp terminate:self];
}

@end
