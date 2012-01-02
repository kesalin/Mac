//
//  MyDocument.m
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "MyDocument.h"
#import "ClassViewController.h"
#import "StudentViewController.h"

@implementation MyDocument

@synthesize popup;
@synthesize box;

- (id)init
{
    self = [super init];
    if (self) {
        // create view controllers
        //
        viewControllers = [[NSMutableArray alloc] init];
        
        ManagedViewController * mvc;
        mvc = [[ClassViewController alloc] init];
        [mvc setManagedObjectContext:[self managedObjectContext]];
        [viewControllers addObject:mvc];
        [mvc release];
        
        mvc = [[StudentViewController alloc] init];
        [mvc setManagedObjectContext:[self managedObjectContext]];
        [viewControllers addObject:mvc];
        [mvc release];
    }
    return self;
}

- (void) dealloc
{
    self.box = nil;
    self.popup = nil;
    [viewControllers release];
    
    [super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
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

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    // init popup
    //
    NSMenu *menu = [popup menu];
    NSInteger itemCount = [viewControllers count];
    
    for (NSInteger i = 0; i < itemCount; i++) {
        NSViewController *vc = [viewControllers objectAtIndex:i];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[vc title]
                                                      action:@selector(changeViewController:)
                                               keyEquivalent:@""];
        [item setTag:i];
        [menu addItem:item];
        [item release];
    }
    
    // display the first controller
    //
    currentIndex = 0;
    [self displayViewController:[viewControllers objectAtIndex:currentIndex]];
    [popup selectItemAtIndex:currentIndex];
}

#pragma mark -
#pragma mark Change Views

- (IBAction) changeViewController:(id)sender
{
    NSInteger tag = [sender tag];
    if (tag == currentIndex) {
        return;
    }
    
    currentIndex = tag;
    ManagedViewController *mvc = [viewControllers objectAtIndex:currentIndex];
    [self displayViewController:mvc];
}

- (void) displayViewController:(ManagedViewController *)mvc
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

@end
