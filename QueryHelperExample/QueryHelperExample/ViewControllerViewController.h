//
//  ViewControllerViewController.h
//  QueryHelperExample
//
//  Created by 宗太郎 松本 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "TestEntity.h"
#import "QueryHelper.h"
#import "TestSet.h"

@interface ViewControllerViewController : UIViewController

@property (nonatomic, readonly) AppDelegate* appDelegate;

- (IBAction)buttonTap:(id)sender;

@end
