//
//  AddReminderViewController.h
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/13/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicationTableViewController.h"
#import "MedicationObject.h"

@interface AddMedicationViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) MedicationTableViewController *caller;
@property (nonatomic, strong) MedicationObject *reminder;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *dosage;

- (IBAction)addPressed:(id)sender;


@end
