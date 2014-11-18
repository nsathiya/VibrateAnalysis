//
//  ScatterPlotViewController.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/7/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCViewController.h"
#include <stdio.h>
#import "DataReadPoint.h"
#import "AAnalysisController.h"
#import "CCAppDelegate.h"

@interface ScatterPlotViewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate>

@property NSMutableArray *dataQueue;
@property NSMutableArray *accelx;
@property NSMutableArray *accely;
@property NSMutableArray *accelz;

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) IBOutlet UIView *graphView;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *oneClickLabel;

- (IBAction)MPAnalysis:(id)sender;
- (IBAction)startRecording:(id)sender;
- (IBAction)AnalysisButton:(id)sender;




@end
