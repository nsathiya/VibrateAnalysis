//
//  CCViewController.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/4/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataReadPoint.h"
#import "NSMutableArray+QueueAdditions.h"
#import "ScatterPlotViewController.h"
#import "CCAppDelegate.h"




@interface CCViewController : UIViewController //<CPTPlotDataSource>
- (IBAction)toGraph:(id)sender;
- (IBAction)resetData:(id)sender;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
