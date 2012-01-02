//
//  ManagedViewController.h
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ManagedViewController : NSViewController {
@private
    NSManagedObjectContext * managedObjectContext;
    NSArrayController * contentArrayController;
    
}

@property (nonatomic, retain) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, retain) IBOutlet NSArrayController *contentArrayController;

@end
