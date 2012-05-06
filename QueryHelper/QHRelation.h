//
//  QHRelation.h
//  QueryHelper
//
//  Created by 宗太郎 松本 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "QHQuery.h"

@interface QHRelation : NSObject

@property (nonatomic, weak, readonly) NSManagedObject* object;
@property (nonatomic, readonly) NSString* associationName;
@property (nonatomic, readonly) NSString* entityName;
@property (nonatomic, readonly) NSString* inverseName;

- (id)initWithObject:(NSManagedObject*)object hasMany:(NSString*)association entity:(NSString*)entity;

- (id)insert;
- (QHQuery*)query;

@end
