//
//  QHQuery.h
//  QueryHelper
//
//  Created by 宗太郎 松本 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface QHQuery : NSObject

- (id)initWithEntity:(NSString*)entity context:(NSManagedObjectContext*)context;
+ (QHQuery*)newQueryWithEntity:(NSString*)entity context:(NSManagedObjectContext*)context;

@property (nonatomic, readonly) NSArray* predicates;
@property (nonatomic, readonly) NSArray* sortDescriptors;

- (NSFetchRequest*)request;

- (NSArray*)fetch;
- (id)first;
- (NSUInteger)count;

- (QHQuery*)where:(NSPredicate*)predicate __attribute__((objc_method_family(new)));

/**
 %k = %@
 */
- (QHQuery*)where:(NSString*)attribute is:(id)value __attribute__((objc_method_family(new)));

/**
 %k != %@
 */
- (QHQuery*)where:(NSString*)attribute isNot:(id)value __attribute__((objc_method_family(new)));

/**
 %k IN %@
 */
- (QHQuery*)where:(NSString*)attribute appearsIn:(NSArray*)values __attribute__((objc_method_family(new)));

/**
 %k BETWEEN %@ AND %@
 */
- (QHQuery*)where:(NSString*)attribute between:(id)lowerBounds to:(id)upperBounds __attribute__((objc_method_family(new)));

/**
 %k < %@
 */
- (QHQuery*)where:(NSString*)attribute lt:(id)value __attribute__((objc_method_family(new)));

/**
 %k <= %@
 */
- (QHQuery*)where:(NSString*)attribute lte:(id)value __attribute__((objc_method_family(new)));

/**
 %@ < %k
 */
- (QHQuery*)where:(NSString*)attribute gt:(id)value __attribute__((objc_method_family(new)));

/**
 %@ <= %k
 */
- (QHQuery*)where:(NSString*)attribute gte:(id)value __attribute__((objc_method_family(new)));

/**
 %@ <= %k AND %k < %@
 */
- (QHQuery*)where:(NSString*)attribute gte:(id)value1 lt:(id)value2 __attribute__((objc_method_family(new)));


/**
 %k LIKE[c] %@
 */
- (QHQuery*)where:(NSString*)attribute like:(NSString*)pattern __attribute__((objc_method_family(new)));

/**
 %k BEGINSWITH[c] %@
 */
- (QHQuery*)where:(NSString*)attribute beginsWith:(NSString*)substring __attribute__((objc_method_family(new)));

/**
 %k CONTAINS[c] %@
 */
- (QHQuery*)where:(NSString*)attribute contains:(NSString*)substring __attribute__((objc_method_family(new)));

/**
 %k ENDSWITH[c] %@
 */
- (QHQuery*)where:(NSString*)attribute endsWith:(NSString*)substring __attribute__((objc_method_family(new)));

/**
 %k MATCHES[c] %@
 */
- (QHQuery*)where:(NSString*)attribute matches:(NSString*)regex __attribute__((objc_method_family(new)));


- (QHQuery*)order:(NSSortDescriptor*)sort __attribute__((objc_method_family(new)));
- (QHQuery*)orderBy:(NSString*)attr ascending:(BOOL)ascending __attribute__((objc_method_family(new)));
- (QHQuery*)orderBy:(NSString*)attr __attribute__((objc_method_family(new)));

- (QHQuery*)limit:(NSUInteger)limit;
- (QHQuery*)offset:(NSUInteger)offset;

- (NSNumber*)sum:(NSString*)attribute;

@end
