//
//  StudentEntity.h
//  MacCoreData
//
//  Created by Kesalin on 9/7/11.
//  Copyright (c) 2011 kesalin@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassEntity;

@interface StudentEntity : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ClassEntity * inClass;

@end
