//
//  MyDocument.h
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ManagedViewController;

@interface MyDocument : NSPersistentDocument {
@private
    NSBox *         box;
    NSPopUpButton * popup;
    
    NSMutableArray *viewControllers;
    NSInteger       currentIndex;
}

@property (nonatomic, retain) IBOutlet NSBox *          box;
@property (nonatomic, retain) IBOutlet NSPopUpButton *  popup;

- (IBAction) changeViewController:(id)sender;
- (void) displayViewController:(ManagedViewController *)mvc;

@end
