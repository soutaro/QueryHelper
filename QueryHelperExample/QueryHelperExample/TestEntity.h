//
//  TestEntity.h
//  QueryHelperExample
//
//  Created by 宗太郎 松本 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TestEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * attr1;
@property (nonatomic, retain) NSDecimalNumber * attr2;
@property (nonatomic, retain) NSString * attr3;
@property (nonatomic, retain) NSNumber * attr4;
@property (nonatomic, retain) NSManagedObject *set;

@end
