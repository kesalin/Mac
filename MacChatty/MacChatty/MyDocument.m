//
//  MyDocument.m
//  MacChatty
//
//  Created by kesalin on 9/14/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "MyDocument.h"
#import "ChattyViewController.h"
#import "ChatRoomViewController.h"

static MyDocument* _instance;

@implementation MyDocument

@synthesize box;

- (NSString *)adjustRateString:(NSString *)ratesString
{
    if (ratesString == nil || [ratesString isEqualToString:@""])
        return ratesString;
    
    NSString *temp = ratesString;
    NSRange range;
    range.location = 1;
    range.length = [temp length] - 1;
    temp = [temp stringByReplacingOccurrencesOfString:@"-"
                                           withString:@"."
                                              options:0
                                                range:range];
    
    temp = [temp stringByReplacingOccurrencesOfString:@"+"
                                           withString:@"4"];
    
    return temp;
}

- (NSInteger)decimalCount:(NSString *)ratesString
{
    if (ratesString == nil || [ratesString isEqualToString:@""])
        return 0;
    
    NSInteger count = 0;
    NSRange range = [ratesString rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSInteger length = [ratesString length];
        
        count = (length - 1 - range.location);
    }
    
    return count;
}

- (int) ratesStringToInt:(NSString *) ratesString decimalCount:(NSInteger)decimalCount
{
    if (ratesString == nil || [ratesString isEqualToString:@""])
        return 0;
    
    NSString *temp = ratesString;
    NSInteger count = [self decimalCount:temp];
    for (NSInteger i = count;  i < decimalCount; i++) {
        temp = [NSString stringWithFormat:@"%@0", temp];
    }

    temp = [temp stringByReplacingOccurrencesOfString:@"."
                                           withString:@""];
    
    int retValue = [temp intValue];
    
    NSLog(@" %@ --> %d", ratesString, retValue);
    return retValue;
}

+ (MyDocument*)sharedInstance
{
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        // create view controllers
        //
        viewControllers = [[NSMutableArray alloc] init];
        
        BaseViewController * mvc;
        mvc = [[ChattyViewController alloc] init];
        [viewControllers addObject:mvc];
        [mvc release];
        
        mvc = [[ChatRoomViewController alloc] init];
        [viewControllers addObject:mvc];
        [mvc release];
        
        _instance = self;
        
        NSString *str1 = @"0-005";
        NSString *str2 = @"1.99";
        
        str1 = [self adjustRateString:str1];
        str2 = [self adjustRateString:str2];
        
        NSInteger decimalCount = MAX([self decimalCount:str1], [self decimalCount:str2]);
        
        NSInteger value1 = [self ratesStringToInt:str1 decimalCount:decimalCount];
        NSInteger value2 = [self ratesStringToInt:str2 decimalCount:decimalCount];
        
        NSLog(@" >> %@ -> %ld, %@ -> %ld", str1, value1, str2, value2);
    }

    return self;
}

- (void) dealloc
{
    self.box = nil;
    [viewControllers release];

    [super dealloc];
}

- (NSString *)windowNibName
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    // display the first controller
    //
    [self showRoomSelection];
}

- (NSString *)displayName
{
    NSString *docTitle = @"Untitled";
    NSArray *windowControllers = [self windowControllers];
    
    if ([windowControllers count] > 0)
    {
        NSWindowController *controller = [windowControllers objectAtIndex: 0];
        NSWindow *window = [controller window];
        docTitle = [window title];
    }
    
    return docTitle;  
}

- (void) displayViewController:(BaseViewController *)mvc
{
    NSWindow *window = [box window];
    BOOL ended = [window makeFirstResponder:window];
    if (!ended) {
        NSBeep();
        return;
    }

    NSView *mvcView = [mvc view];
    
    // Adjust window's size and position
    //
    NSSize currentSize      = [[box contentView] frame].size;
    NSSize newSize          =  [mvcView frame].size;
    float deltaWidth        = newSize.width - currentSize.width;
    float deltaHeight       = newSize.height - currentSize.height;
    
    NSRect windowFrame      = [window frame];
    windowFrame.size.width  += deltaWidth;
    windowFrame.size.height += deltaHeight;
    windowFrame.origin.y    -= deltaHeight;
    
    [box setContentView:nil];
    [window setFrame:windowFrame display:YES animate:YES];
    
    [box setContentView:mvcView];
    
    // add viewController to the responder-chain
    //
    [mvcView setNextResponder:mvc];
    [mvc setNextResponder:box];
}

// Show chat room
- (void)showChatRoom:(Room *)room
{
    ChatRoomViewController * chatRoomViewController = [viewControllers objectAtIndex:1];
    
    [self displayViewController:chatRoomViewController];
    
    chatRoomViewController.chatRoom = room;
    [chatRoomViewController activate];
}


// Show screen with room selection
- (void)showRoomSelection
{
    ChattyViewController * chattyViewController = [viewControllers objectAtIndex:0];
    
    [self displayViewController:chattyViewController];
    
    [chattyViewController activate];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return YES;
}

@end
