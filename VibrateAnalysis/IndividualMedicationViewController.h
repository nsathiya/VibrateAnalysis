//
//  IndividualReminderViewController.h
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicationObject.h"
#import "MedicationTableViewController.h"

@interface IndividualMedicationViewController : UIViewController

@property (nonatomic, strong) MedicationTableViewController *caller;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *hello;


@property (weak, nonatomic) IBOutlet UINavigationItem *viewName;

@property (weak, nonatomic) IBOutlet UITextField *dosage;
- (IBAction)delete:(id)sender;

@end
