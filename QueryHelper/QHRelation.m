//
//  QHRelation.m
//  QueryHelper
//
//  Created by 宗太郎 松本 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QHRelation.h"

@implementation QHRelation {
	__weak NSManagedObject* object_;
	NSString* hasManyName_;
	NSString* entity_;
}

@synthesize object=object_;
@synthesize associationName=hasManyName_;
@synthesize entityName=entity_;
@synthesize inverseName=belongsToName_;

- (id)initWithObject:(NSManagedObject *)object hasMany:(NSString *)association entity:(NSString *)entity {
	self = [self init];
	
	object_ = object;
	hasManyName_ = association;
	entity_ = entity;
	
	return self;
}

- (NSManagedObject*)insert {
	NSManagedObject* newObject = [NSEntityDescription insertNewObjectForEntityForName:entity_ inManagedObjectContext:object_.managedObjectContext];

	NSMutableSet* set = [object_ mutableSetValueForKey:hasManyName_];
	[set addObject:newObject];
	
	return newObject;
}

- (QHQuery *)query {
	QHQuery* query = [[QHQuery alloc] initWithEntity:entity_ context:object_.managedObjectContext];
	NSSet* set = [object_ valueForKey:hasManyName_];
	return [query where:[NSPredicate predicateWithFormat:@"SELF IN %@", set]];
}

@end
