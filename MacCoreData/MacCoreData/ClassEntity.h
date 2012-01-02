//
//  ClassEntity.h
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright (c) 2011 kesalin@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentEntity;

@interface ClassEntity : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* students;
@property (nonatomic, retain) StudentEntity * monitor;

@end
