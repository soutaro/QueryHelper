//
//  ViewControllerViewController.m
//  QueryHelperExample
//
//  Created by 宗太郎 松本 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewControllerViewController.h"

@interface ViewControllerViewController ()

@end

@implementation ViewControllerViewController {
	NSManagedObjectContext* context_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	context_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	[context_ setParentContext:self.appDelegate.managedObjectContext];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (AppDelegate *)appDelegate {
	UIApplication* app = [UIApplication sharedApplication];
	return (AppDelegate*)app.delegate;
}

- (IBAction)buttonTap:(id)sender {
	TestEntity* t1 = [NSEntityDescription insertNewObjectForEntityForName:@"TestEntity" inManagedObjectContext:context_];
	t1.attr1 = [NSNumber numberWithInt:1];
	t1.attr2 = [NSDecimalNumber decimalNumberWithString:@"1.01"];
	t1.attr3 = @"Hello world";
	t1.attr4 = [NSDecimalNumber numberWithBool:YES];
	
	TestEntity* t2 = [NSEntityDescription insertNewObjectForEntityForName:@"TestEntity" inManagedObjectContext:context_];
	t2.attr1 = [NSNumber numberWithInt:10];
	t2.attr2 = [NSDecimalNumber decimalNumberWithString:@"2.01"];
	t2.attr3 = @"hello world";
	t2.attr4 = [NSDecimalNumber numberWithBool:NO];
	
	QHQuery* query = [[QHQuery alloc] initWithEntity:@"TestEntity" context:context_];
	
	[context_ obtainPermanentIDsForObjects:[context_.insertedObjects sortedArrayUsingDescriptors:[NSArray array]] error:nil];
	[context_ save:nil];
	[self.appDelegate saveContext];
	
	TestSet* set = [NSEntityDescription insertNewObjectForEntityForName:@"TestSet" inManagedObjectContext:context_];
	QHRelation* rel = [[QHRelation alloc] initWithObject:set hasMany:@"entities"];
	
	[set addEntitiesObject:t1];
	[set addEntitiesObject:t2];
	
	TestEntity* t3 = (TestEntity*)[rel insert];
	t3.attr4 = [NSNumber numberWithBool:NO];
	
	[context_ obtainPermanentIDsForObjects:[context_.insertedObjects sortedArrayUsingDescriptors:[NSArray array]] error:nil];
	[context_ save:nil];
	[self.appDelegate saveContext];
	
	NSLog(@"%@", set.entities);
	
	NSLog(@"%d", set == t3.set);
	
	NSLog(@"%@", [[query where:@"set" is:set] fetch]);
}

@end
