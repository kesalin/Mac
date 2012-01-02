//
//  ChattyViewController.h
//  MacChatty
//
//  Created by kesalin on 9/14/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ServerBrowserDelegate.h"
#import "ServerBrowser.h"

@interface ChattyViewController : BaseViewController <NSTableViewDelegate, NSTableViewDataSource, ServerBrowserDelegate>
{
@private
    NSTableView * serverList;
    NSTextField * nameTextField;
    
    ServerBrowser* serverBrowser;
}

@property (nonatomic, retain) IBOutlet NSTableView * serverList;
@property (nonatomic, retain) IBOutlet NSTextField * nameTextField;

- (IBAction) createNewChatRoom:(id)sender;
- (IBAction) jionChatRoom:(id)sender;
- (IBAction) newName:(id)sender;

// View is active, start everything up
- (void)activate;

@end
