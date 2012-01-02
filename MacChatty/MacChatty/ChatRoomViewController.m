//
//  ChatRoomViewController.m
//  MacChatty
//
//  Created by kesalin on 9/14/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "AppConfig.h"
#import "MyDocument.h"

@implementation ChatRoomViewController

@synthesize chatMsg;
@synthesize nameLabel;
@synthesize chatRoom;

- (id)init
{
    self = [super initWithNibName:@"ChatRoomViewController" bundle:nil];
    if (self) {
        [self setTitle:@"ChatView"];
    }
    
    return self;
}

- (void)dealloc
{
    self.nameLabel  = nil;
    self.chatMsg    = nil;
    self.chatRoom   = nil;
    
    [super dealloc];
}

- (void) activate
{
    if ( chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
    }
    
    NSString * name = [AppConfig sharedInstance].name;
    [nameLabel setStringValue:[NSString stringWithFormat:@"%@ >", name]];
}

- (IBAction) backToChatty:(id)sender
{
    // Close the room
    [chatRoom stop];

    [chatMsg setString:@""];
    
    [[MyDocument sharedInstance] showRoomSelection];
}

- (IBAction) newMessage:(id)sender
{
    NSTextField * textField = (NSTextField *)sender;
    NSString * text = [textField stringValue];

    if (text && [text length] > 0) {
        // send message
        NSString * name = [AppConfig sharedInstance].name;
        [chatRoom broadcastChatMessage:text fromUser:name];
        
        [textField setStringValue:@""];
    }
}


#pragma mark -
#pragma mark RoomDelegate

// We are being asked to display a chat message
- (void)displayChatMessage:(NSString *)message fromUser:(NSString *)userName
{    
    NSString * msg = [NSString stringWithFormat:@"%@: %@\n", userName, message];
    NSLog(@" >> %@", msg);

    NSString * currentString = [NSString stringWithFormat:@"%@%@", [chatMsg string], msg];
    [chatMsg setString:currentString];

    NSRange range = [currentString rangeOfString:msg options:NSBackwardsSearch];
    [chatMsg scrollRangeToVisible:range];
}


// Room closed from outside
- (void)roomTerminated:(id)room reason:(NSString*)reason
{
    NSLog(@" Room terminated:%@", reason);
    
    NSString * msg = [NSString stringWithFormat:@"Reason:%@", reason];
    NSAlert * alert = [NSAlert alertWithMessageText:@"Room terminated"
                                      defaultButton:@"OK"
                                    alternateButton:nil
                                        otherButton:nil
                          informativeTextWithFormat:msg];
    [alert runModal];
    
    [self backToChatty:nil];
}

@end
