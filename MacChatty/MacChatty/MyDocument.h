//
//  MyDocument.h
//  MacChatty
//
//  Created by kesalin on 9/14/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Room.h"

@class BaseViewController;

typedef NSInteger ChatView;

@interface MyDocument : NSDocument {
@private
    NSBox *         box;
    
    NSMutableArray *viewControllers;
    NSInteger       currentIndex;
}

@property (nonatomic, retain) IBOutlet NSBox * box;

- (void) displayViewController:(BaseViewController *)mvc;

// Main instance of the MyDocument
+ (MyDocument*)sharedInstance;

// Show chat room
- (void)showChatRoom:(Room *)room;

// Go back to the room selection
- (void)showRoomSelection;

@end
