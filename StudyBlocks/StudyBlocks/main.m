//
//  main.m
//  StudyBlocks
//
//  Created by Simon on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Test Mode:
// a block              0
// block array          1
// modify var           2
// block recursion      3
// dispatch queue       4
// dispatch semaphore   5
// FIFO                 6
// dispatch iteration   7
// dispatch group       8

#define TestMode        8

static int global = 100;

static volatile BOOL flag = NO;

static const int Length = 100;
static int data[Length];
static void initData()
{
    for(int i = 0; i < Length; i++)
        data[i] = i + 1;
}

int main (int argc, const char * argv[])
{
#if (TestMode == 0)
    // a block
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    void (^aBlock)(void) = 0;
    aBlock = ^(void) {
        NSLog(@"Hello, World!");
    };

    aBlock();
    
    [pool drain];

#elif (TestMode == 1)
    // block array
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    void (^blocks[2])(void) = {
        ^(void){ NSLog(@" >> This is block 1!"); },
        ^(void){ NSLog(@" >> This is block 2!"); }
    };
    
    blocks[0]();
    blocks[1]();
    
    [pool drain];

#elif (TestMode == 2)
    // modify var
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    __block int blockLocal  = 100;
    static int staticLocal  = 100;
    
    void (^aBlock)(void) = ^(void){ 
        NSLog(@" >> Sum: %d\n", global + staticLocal);
        
        global++;
        blockLocal++;
        staticLocal++;
    };
    
    aBlock();

    NSLog(@"After modified, global: %d, block local: %d, static local: %d\n", global, blockLocal, staticLocal);

    [pool drain];
    
#elif (TestMode == 3)
    // block recursion
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // 1
    void (^aBlock)(int) = 0;
    static void (^ const staticBlock)(int) = ^(int i) {
        if (i > 0) {
            NSLog(@" >> static %d", i);
            staticBlock(i - 1);
        }
    };
    
    aBlock = staticBlock;
    aBlock(5);
    
    // 2
    __block void (^blockBlock)(int);
    blockBlock = ^(int i) {
        if (i > 0) {
            NSLog(@" >> block %d", i);
            blockBlock(i - 1);
        }
    };
    
    blockBlock(5);
    
    [pool drain];
    
#elif (TestMode == 4)
    // dispatch queue
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    initData();
    
    // create dispatch queue
    //
    dispatch_queue_t queue = dispatch_queue_create("StudyBlocks", NULL);
    
    dispatch_async(queue, ^(void) {
        int sum = 0;
        for(int i = 0; i < Length; i++)
            sum += data[i];
        
        NSLog(@" >> Sum: %d", sum);
        
        flag = YES;
    });
    
    // wait util work is done.
    //
    while (!flag);
    dispatch_release(queue);
    
    [pool drain];

#elif (TestMode == 5)
    // dispatch semaphore
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    initData();
    
    // Create a semaphore with 0 resource
    //
    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    // create dispatch semaphore
    //
    dispatch_queue_t queue = dispatch_queue_create("StudyBlocks", NULL);
    
    dispatch_async(queue, ^(void) {
        int sum = 0;
        for(int i = 0; i < Length; i++)
            sum += data[i];
        
        NSLog(@" >> Sum: %d", sum);
        
        // signal the semaphore: add 1 resource
        //
        dispatch_semaphore_signal(sem);
    });
    
    // wait for the semaphore: wait until resource is ready.
    //
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    dispatch_release(sem);
    dispatch_release(queue);
    
    [pool drain];

#elif (TestMode == 6)
    // FIFO
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    initData();
    
    __block int sum = 0;

    // Create a semaphore with 0 resource
    //
    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block dispatch_semaphore_t taskSem = dispatch_semaphore_create(0);
    
    // create dispatch semaphore
    //
    dispatch_queue_t queue = dispatch_queue_create("StudyBlocks", NULL);
    
    dispatch_block_t task1 = ^(void) {
        int s = 0;
        for (int i = 0; i < Length; i++)
            s += data[i];
        sum = s;
        
        NSLog(@" >> after add: %d", sum);

        dispatch_semaphore_signal(taskSem);
    };
    
    dispatch_block_t task2 = ^(void) {
        dispatch_semaphore_wait(taskSem, DISPATCH_TIME_FOREVER);
        
        int s = sum;
        for (int i = 0; i < Length; i++)
            s -= data[i];
        sum = s;

        NSLog(@" >> after subtract: %d", sum);
        dispatch_semaphore_signal(sem);
    };
    
    dispatch_async(queue, task1);
    dispatch_async(queue, task2);
    
    // wait for the semaphore: wait until resource is ready.
    //
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    dispatch_release(taskSem);
    dispatch_release(sem);
    dispatch_release(queue);
    
    [pool drain];

#elif (TestMode == 7)
    // dispatch iteration

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    initData();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block int sum = 0;
    __block int *pArray = data;
    
    // iterations
    //
    dispatch_apply(Length, queue, ^(size_t i) {
        sum += pArray[i];
    });
    
    NSLog(@" >> sum: %d", sum);

    dispatch_release(queue);

    [pool drain];

#elif (TestMode == 8)
    // dispatch group
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    initData();
    
    __block int sum = 0;
    
    // Create a semaphore with 0 resource
    //
    __block dispatch_semaphore_t taskSem = dispatch_semaphore_create(0);
    
    // create dispatch semaphore
    //
    dispatch_queue_t queue = dispatch_queue_create("StudyBlocks", NULL);
    dispatch_group_t group = dispatch_group_create();

    dispatch_block_t task1 = ^(void) {
        int s = 0;
        for (int i = 0; i < Length; i++)
            s += data[i];
        sum = s;
        
        NSLog(@" >> after add: %d", sum);
        
        dispatch_semaphore_signal(taskSem);
    };
    
    dispatch_block_t task2 = ^(void) {
        dispatch_semaphore_wait(taskSem, DISPATCH_TIME_FOREVER);
        
        int s = sum;
        for (int i = 0; i < Length; i++)
            s -= data[i];
        sum = s;
        
        NSLog(@" >> after subtract: %d", sum);
    };
    
    // Fork
    dispatch_group_async(group, queue, task1);
    dispatch_group_async(group, queue, task2);
    
    // Join
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_release(taskSem);
    dispatch_release(queue);
    dispatch_release(group);
    
    [pool drain];
    
#endif
    
    NSLog(@" << Test Done >>");
    return 0;
}

