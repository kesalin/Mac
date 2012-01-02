//
//  ClassEntity.m
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright (c) 2011 kesalin@gmail.com. All rights reserved.
//

#import "ClassEntity.h"
#import "StudentEntity.h"


@implementation ClassEntity
@dynamic name;
@dynamic students;
@dynamic monitor;

- (void)addStudentsObject:(StudentEntity *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"students" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"students"] addObject:value];
    [self didChangeValueForKey:@"students" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeStudentsObject:(StudentEntity *)value {
    if (value == [self monitor])
        [self setMonitor:nil];

    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"students" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"students"] removeObject:value];
    [self didChangeValueForKey:@"students" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addStudents:(NSSet *)value {    
    [self willChangeValueForKey:@"students" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"students"] unionSet:value];
    [self didChangeValueForKey:@"students" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeStudents:(NSSet *)value {
    if ([value containsObject:[self monitor]])
        [self setMonitor:nil];
    
    [self willChangeValueForKey:@"students" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"students"] minusSet:value];
    [self didChangeValueForKey:@"students" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
