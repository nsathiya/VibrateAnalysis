//
//  IndividualReminderViewController.m
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "IndividualReminderViewController.h"

@implementation IndividualReminderViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.viewName.title = [self.individual getName];
    self.dosage.text = [self.individual getDosage];
}

@end
