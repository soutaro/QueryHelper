//
//  TestSet.h
//  QueryHelperExample
//
//  Created by 宗太郎 松本 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TestEntity;

@interface TestSet : NSManagedObject

@property (nonatomic, retain) NSSet *entities;
@end

@interface TestSet (CoreDataGeneratedAccessors)

- (void)addEntitiesObject:(TestEntity *)value;
- (void)removeEntitiesObject:(TestEntity *)value;
- (void)addEntities:(NSSet *)values;
- (void)removeEntities:(NSSet *)values;

@end
