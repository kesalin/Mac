//
//  BaseViewController.m
//  MacChatty
//
//  Created by kesalin on 9/14/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController

- (void)dealloc
{
    [super dealloc];
}

- (void) activate
{
    // Crude way to emulate "abstract" class
    [self doesNotRecognizeSelector:_cmd];
}

@end
