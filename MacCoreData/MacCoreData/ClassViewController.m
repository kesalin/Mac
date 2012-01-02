//
//  ClassViewController.m
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "ClassViewController.h"


@implementation ClassViewController

- (id)init
{
    self = [super initWithNibName:@"ClassView" bundle:nil];
    if (self) {
        [self setTitle:@"班级"];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
