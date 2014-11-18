//
//  AccelerationViewController.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/17/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrequencyViewController.h"

@interface AccelerationViewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate>

@property NSMutableArray *dataQueue;
@property NSMutableArray *accelx;
@property NSMutableArray *accely;
@property NSMutableArray *accelz;

@property (nonatomic, strong) CPTGraphHostingView *hostView;

@property (strong, nonatomic) IBOutlet UIView *graphView;

- (IBAction)analysisButton:(id)sender;




@end
