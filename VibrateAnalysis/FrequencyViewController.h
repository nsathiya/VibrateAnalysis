//
//  FrequencyViewController.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/17/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrequencyViewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate>

@property (nonatomic, strong) NSMutableArray *accelX;
@property (nonatomic, strong) NSMutableArray *accelY;
@property (nonatomic, strong) NSMutableArray *accelZ;
@property (nonatomic, strong) CPTGraphHostingView *hostView;

@property (strong, nonatomic) IBOutlet UIView *graphView;

@end
