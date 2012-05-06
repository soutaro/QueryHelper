//
//  QHQuery.m
//  QueryHelper
//
//  Created by 宗太郎 松本 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QHQuery.h"

@interface QHQuery ()

- (id)initWithEntity:(NSString*)entity context:(NSManagedObjectContext*)context predicates:(NSArray*)predicates sortDescriptors:(NSArray*)descrs limit:(NSUInteger)limit offset:(NSUInteger)offset;

- (void)addPredicate:(NSPredicate*)predicate;
- (void)addSortDescriptor:(NSSortDescriptor*)descriptor;

@end

@implementation QHQuery {
	NSManagedObjectContext* context_;
	
	NSMutableArray* predicates_;
	NSMutableArray* sortDescriptors_;
	NSUInteger limit_;
	NSUInteger offset_;
	
	NSString* entity_;
}

@synthesize predicates=predicates_;
@synthesize sortDescriptors=sortDescriptors_;

- (id)copy {
	return [[QHQuery alloc] initWithEntity:entity_ context:context_ predicates:predicates_ sortDescriptors:sortDescriptors_ limit:limit_ offset:offset_];
}

+ (QHQuery *)newQueryWithEntity:(NSString *)entity context:(NSManagedObjectContext *)context {
	return [[self alloc] initWithEntity:entity context:context];
}

- (id)initWithEntity:(NSString *)entity context:(NSManagedObjectContext *)context {
	self = [self init];
	
	entity_ = entity;
	context_ = context;
	predicates_ = [NSMutableArray new];
	sortDescriptors_ = [NSMutableArray new];
	limit_ = 0;
	offset_ = 0;
	
	return self;
}

- (id)initWithEntity:(NSString *)entity context:(NSManagedObjectContext *)context predicates:(NSArray *)predicates sortDescriptors:(NSArray *)descrs limit:(NSUInteger)limit offset:(NSUInteger)offset {
	self = [self initWithEntity:entity context:context];
	
	[predicates_ addObjectsFromArray:predicates];
	[sortDescriptors_ addObjectsFromArray:descrs];
	limit_ = limit;
	offset_ = offset;
	
	return self;
}

- (NSFetchRequest *)request {
	NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates_];
	
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entity_];
	[request setPredicate:predicate];
	[request setSortDescriptors:sortDescriptors_];
	[request setFetchLimit:limit_];
	[request setFetchOffset:offset_];
	
	return request;
}

#pragma mark - Fetching result from NSManagedObjectContext

- (NSArray *)fetch {
	NSError* error = nil;
	NSArray* result = [context_ executeFetchRequest:[self request] error:&error];
	
	if (error) {
		NSLog(@"QHQuery#fetchFromContext %@", error);
		return nil;
	} else {
		return result;
	}
}

- (id)first {
	NSArray* result = [[self limit:1] fetch];
	return result.lastObject;
}

- (NSUInteger)count {
	return [context_ countForFetchRequest:[self request] error:nil];
}

-(NSNumber *)sum:(NSString *)attribute {
	NSPersistentStoreCoordinator* psc = [context_ persistentStoreCoordinator];
	NSManagedObjectModel* model = psc.managedObjectModel;
	NSEntityDescription* descr = [[model entitiesByName] valueForKey:entity_];
	NSAttributeDescription* attrDescr = [[descr attributesByName] valueForKey:attribute];
	NSAttributeType type = attrDescr.attributeType;
	
	NSExpression* ex = [NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:attribute]]];
	
	NSExpressionDescription *ed = [[NSExpressionDescription alloc] init];
    [ed setName:@"__result"];
    [ed setExpression:ex];
    [ed setExpressionResultType:type];
	
    NSArray *properties = [NSArray arrayWithObject:ed];
	
    NSFetchRequest *request = [self request];
    [request setPropertiesToFetch:properties];
    [request setResultType:NSDictionaryResultType];
	
    NSArray *results = [context_ executeFetchRequest:request error:nil];
	if ([results count] == 0) {
		return 0;
	} else {
		NSDictionary *resultsDictionary = [results objectAtIndex:0];
		return [resultsDictionary objectForKey:@"__result"];
	}
}

#pragma mark - Order group

- (QHQuery *)where:(NSPredicate *)predicate {
	QHQuery* q = [self copy];
	[q addPredicate:predicate];
	return q;
}

- (QHQuery *)where:(NSString *)attribute is:(id)value {
	if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSSet class]]) {
		return [self where:attribute appearsIn:value];
	} else {
		return [self where:[NSPredicate predicateWithFormat:@"%K = %@", attribute, value]];
	}
}

- (QHQuery *)where:(NSString *)attribute isNot:(id)value {
	return [self where:[NSPredicate predicateWithFormat:@"%K != %@", attribute, value]];
}

- (QHQuery *)where:(NSString *)attribute appearsIn:(NSArray *)values {
	return [self where:[NSPredicate predicateWithFormat:@"%K IN %@", attribute, values]];
}

- (QHQuery *)where:(NSString *)attribute between:(id)lowerBounds to:(id)upperBounds {
	NSArray* range = [NSArray arrayWithObjects:lowerBounds, upperBounds, nil];
	return [self where:[NSPredicate predicateWithFormat:@"%K BETWEEN %@", attribute, range]];
}

- (QHQuery*)where:(NSString*)attribute lt:(id)value {
	return [self where:[NSPredicate predicateWithFormat:@"%K < %@", attribute, value]];
}

- (QHQuery*)where:(NSString*)attribute lte:(id)value {
	return [self where:[NSPredicate predicateWithFormat:@"%K <= %@", attribute, value]];
}

- (QHQuery*)where:(NSString*)attribute gt:(id)value {
	return [self where:[NSPredicate predicateWithFormat:@"%@ < %K", value, attribute]];
}

- (QHQuery*)where:(NSString*)attribute gte:(id)value {
	return [self where:[NSPredicate predicateWithFormat:@"%@ <= %K", value, attribute]];
}

- (QHQuery*)where:(NSString*)attribute gte:(id)value1 lt:(id)value2 {
	return [self where:[NSPredicate predicateWithFormat:@"%@ <= %K AND %K < %@", value1, attribute, attribute, value2]];
}

- (QHQuery*)where:(NSString *)attribute like:(NSString *)pattern {
	return [self where:[NSPredicate predicateWithFormat:@"%K LIKE %@", attribute, pattern]];
}

- (QHQuery*)where:(NSString*)attribute beginsWith:(NSString *)substring {
	return [self where:[NSPredicate predicateWithFormat:@"%K BEGINSWITH %@", attribute, substring]];
}

- (QHQuery*)where:(NSString*)attribute contains:(NSString *)substring {
	return [self where:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", attribute, substring]];
}

- (QHQuery*)where:(NSString*)attribute endsWith:(NSString *)substring {
	return [self where:[NSPredicate predicateWithFormat:@"%K ENDSWITH %@", attribute, substring]];
}

-(QHQuery *)where:(NSString *)attribute matches:(NSString *)regex {
	return [self where:[NSPredicate predicateWithFormat:@"%K MATCHES %@", attribute, regex]];
}

#pragma mark - Ordering

- (QHQuery *)order:(NSSortDescriptor *)sort {
	QHQuery* query = [self copy];
	[query addSortDescriptor:sort];
	return query;
}

- (QHQuery *)orderBy:(NSString *)attr {
	return [self orderBy:attr ascending:YES];
}

- (QHQuery *)orderBy:(NSString *)attr ascending:(BOOL)ascending {
	return [self order:[NSSortDescriptor sortDescriptorWithKey:attr ascending:ascending]];
}

#pragma mark -

- (QHQuery *)limit:(NSUInteger)limit {
	return[[QHQuery alloc] initWithEntity:entity_ context:context_ predicates:predicates_ sortDescriptors:sortDescriptors_ limit:limit offset:offset_];
}

- (QHQuery *)offset:(NSUInteger)offset {
	return[[QHQuery alloc] initWithEntity:entity_ context:context_ predicates:predicates_ sortDescriptors:sortDescriptors_ limit:limit_ offset:offset];
}

#pragma mark - Private Utilities

- (void)addPredicate:(NSPredicate *)predicate {
	[predicates_ addObject:predicate];
}

- (void)addSortDescriptor:(NSSortDescriptor *)descriptor {
	[sortDescriptors_ addObject:descriptor];
}

@end
