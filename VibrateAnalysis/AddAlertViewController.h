//
//  AddAlertViewController.h
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/15/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicationTableViewController.h"
#import "MedicationObject.h"

@interface AddAlertViewController : UIViewController

@property (nonatomic, strong) MedicationTableViewController *caller;
@property (nonatomic) NSInteger index;

@property (strong, nonatomic) IBOutlet UIDatePicker *time;

- (IBAction)addAlert:(id)sender;

@end
