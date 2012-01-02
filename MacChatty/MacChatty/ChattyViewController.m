//
//  ChattyViewController.m
//  MacChatty
//
//  Created by kesalin on 9/14/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "ChattyViewController.h"
#import "AppConfig.h"
#import "LocalRoom.h"
#import "RemoteRoom.h"
#import "MyDocument.h"

#pragma mark -
#pragma mark Private properties

@interface ChattyViewController ()

@property(nonatomic, retain) ServerBrowser* serverBrowser;

@end

@implementation ChattyViewController

@synthesize nameTextField;
@synthesize serverList;
@synthesize serverBrowser;

- (id)init
{
    self = [super initWithNibName:@"ChattyViewController" bundle:nil];
    if (self) {
        [self setTitle:@"ChattyView"];
        
        serverBrowser = [[ServerBrowser alloc] init];
        serverBrowser.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    self.nameTextField  = nil;
    self.serverList     = nil;
    self.serverBrowser  = nil;

    [super dealloc];
}

// View became active, start your engines
- (void)activate
{
    [nameTextField setStringValue:[AppConfig sharedInstance].name];

    // Start browsing for services
    [serverBrowser start];
}

#pragma mark -
#pragma mark Actions

- (IBAction) newName:(id)sender
{
    NSTextField * textField = (NSTextField *)sender;
    NSString *text = [textField stringValue];
    NSString *currentName = [AppConfig sharedInstance].name;
    
    if (![currentName isEqualToString:text]) {
        [AppConfig sharedInstance].name = text;
    }
}

- (IBAction) createNewChatRoom:(id)sender
{
    // Stop browsing for servers
    [serverBrowser stop];
    
    // Create local chat room and go
    LocalRoom* room = [[[LocalRoom alloc] init] autorelease];
    [[MyDocument sharedInstance] showChatRoom:room];
}

- (IBAction) jionChatRoom:(id)sender
{
    // Figure out which server is selected
    NSInteger currentRow = [serverList selectedRow];
    if ( currentRow == -1 ) {
        return;
    }
    
    NSNetService* selectedServer = [serverBrowser.servers objectAtIndex:currentRow];
    
    // Create chat room that will connect to that chat server
    RemoteRoom* room = [[[RemoteRoom alloc] initWithNetService:selectedServer] autorelease];
    
    // Stop browsing and switch over to chat room
    [serverBrowser stop];
    
    [[MyDocument sharedInstance] showChatRoom:room];
}

#pragma mark -
#pragma mark ServerBrowserDelegate

- (void) updateServerList
{
    [serverList reloadData];
}


#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [serverBrowser.servers count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSNetService* server = [serverBrowser.servers objectAtIndex:row];
    NSString *text = [server name];
    return text;
}

@end
