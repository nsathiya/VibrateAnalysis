//
//  CCViewController.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/4/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "DataReadPoint.h"
#import "NSMutableArray+QueueAdditions.h"
#import "ScatterPlotViewController.h"

double currentMaxAccelX;
double currentMaxAccelY;
double currentMaxAccelZ;
double currentMaxRotX;
double currentMaxRotY;
double currentMaxRotZ;


@interface CCViewController : UIViewController //<CPTPlotDataSource>
- (IBAction)toGraph:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *accX;
@property (strong, nonatomic) IBOutlet UILabel *accY;
@property (strong, nonatomic) IBOutlet UILabel *accZ;
@property (strong, nonatomic) IBOutlet UILabel *rotX;
@property (strong, nonatomic) IBOutlet UILabel *rotY;
@property (strong, nonatomic) IBOutlet UILabel *rotZ;
@property (strong, nonatomic) IBOutlet UILabel *maxAccX;
@property (strong, nonatomic) IBOutlet UILabel *maxAccY;
@property (strong, nonatomic) IBOutlet UILabel *maxAccZ;
@property (strong, nonatomic) IBOutlet UILabel *maxRotX;
@property (strong, nonatomic) IBOutlet UILabel *maxRotY;
@property (strong, nonatomic) IBOutlet UILabel *maxRotZ;
- (IBAction)resetMaxValues:(id)sender;
@property (strong, nonatomic) NSMutableArray *dataQueue;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end
