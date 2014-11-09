//
//  ScatterPlotViewController.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/7/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCViewController.h"

@interface ScatterPlotViewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate>

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property NSMutableArray *dataQueue;
@end
