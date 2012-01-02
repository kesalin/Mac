//
//  ChatRoomViewController.h
//  MacChatty
//
//  Created by kesalin on 9/14/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "BaseViewController.h"
#import "Room.h"
#import "RoomDelegate.h"

@interface ChatRoomViewController : BaseViewController <RoomDelegate>
{
@private

    NSTextView * chatMsg;
    NSTextField * nameLabel;
    
    Room * chatRoom;
}

@property (nonatomic, retain) IBOutlet NSTextView * chatMsg;
@property (nonatomic, retain) IBOutlet NSTextField * nameLabel;
@property (nonatomic, retain) Room * chatRoom;

- (void) activate;

// Exit back to the welcome screen
- (IBAction) backToChatty:(id)sender;
- (IBAction) newMessage:(id)sender;

@end
