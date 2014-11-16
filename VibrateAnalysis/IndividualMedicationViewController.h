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
#import "AddAlertViewController.h"

@interface IndividualMedicationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MedicationTableViewController *caller;
@property (nonatomic) NSInteger index;


@property (weak, nonatomic) IBOutlet UINavigationItem *viewName;

@property (strong, nonatomic) IBOutlet UITextField *dosage;

- (IBAction)delete:(id)sender;


@property (strong, nonatomic) IBOutlet UITableView *alerts;


@end
