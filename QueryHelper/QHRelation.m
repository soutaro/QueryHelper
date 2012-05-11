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
	NSString* inverse_;
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
	
	NSPersistentStoreCoordinator* psc = [object.managedObjectContext persistentStoreCoordinator];
	NSManagedObjectModel* model = psc.managedObjectModel;
	NSEntityDescription* descr = [[model entitiesByName] valueForKey:NSStringFromClass([object_ class])];
	NSRelationshipDescription* relDescr = [[descr relationshipsByName] objectForKey:association];
	NSRelationshipDescription* invDescr = relDescr.inverseRelationship;
	if (invDescr) {
		inverse_ = invDescr.name;
	}
	
	return self;
}

- (id)insert {
	NSManagedObject* newObject = [NSEntityDescription insertNewObjectForEntityForName:entity_ inManagedObjectContext:object_.managedObjectContext];

	NSMutableSet* set = [object_ mutableSetValueForKey:hasManyName_];
	[set addObject:newObject];
	
	return newObject;
}

- (QHQuery *)query {
	QHQuery* query = [[QHQuery alloc] initWithEntity:entity_ context:object_.managedObjectContext];
	if (!object_) {
		NSLog(@"QHRelation:: object is nil now (relation = %@, inverse = %@, destination = %@)", hasManyName_, inverse_, entity_);
		return nil;
	}
	if (!inverse_) {
		NSLog(@"QHRelation:: no inverse relation for %@.%@", NSStringFromClass([object_ class]), hasManyName_);
		return nil;
	}
	return [query where:[NSPredicate predicateWithFormat:@"%K = %@", inverse_, object_]];
}

@end
