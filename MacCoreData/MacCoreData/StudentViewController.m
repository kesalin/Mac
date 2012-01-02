//
//  StudentViewController.m
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "StudentViewController.h"


@implementation StudentViewController

- (id)init
{
    self = [super initWithNibName:@"StudentView" bundle:nil];
    if (self) {
        [self setTitle:@"学生"];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
