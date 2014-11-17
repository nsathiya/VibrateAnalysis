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

@interface ScatterPlotViewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate>

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property NSMutableArray *dataQueue;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) IBOutlet UIView *graphView;
- (IBAction)MPAnalysis:(id)sender;
- (IBAction)startRecording:(id)sender;
- (IBAction)AnalysisButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *oneClickLabel;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;




@end
