//
//  AAnalysisController.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/14/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <stdio.h>
#import "DataReadPoint.h"
#import <CoreMotion/CoreMotion.h>

@interface AAnalysisController : UIViewController  <CPTPlotDataSource, CPTPlotSpaceDelegate>

@property NSMutableArray *dataQueue;
@property (strong, nonatomic) IBOutlet UIView *graphView;
@property (nonatomic, strong) CPTGraphHostingView *hostView;

@end
