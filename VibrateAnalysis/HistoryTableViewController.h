//
//  HistoryTableViewController.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/17/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAppDelegate.h"
#import "AccelerationViewController.h"

@interface HistoryTableViewController : UITableViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray* graphTests;

@end
