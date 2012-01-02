//
//  ManagedViewController.m
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "ManagedViewController.h"

@implementation ManagedViewController

@synthesize managedObjectContext;
@synthesize contentArrayController;

- (void)dealloc
{
    self.contentArrayController = nil;
    self.managedObjectContext = nil;

    [super dealloc];
}

// deal with "Delete" key event.
//
- (void) keyDown:(NSEvent *)theEvent
{
    if (contentArrayController) {
        if ([theEvent keyCode] == 51) {
            [contentArrayController remove:nil];
        }
        else {
            [super keyDown:theEvent];
        }
    }
    else {
        [super keyDown:theEvent];
    }
}

@end
