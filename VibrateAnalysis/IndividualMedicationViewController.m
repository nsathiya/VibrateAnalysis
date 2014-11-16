//
//  IndividualReminderViewController.m
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "IndividualMedicationViewController.h"

@implementation IndividualMedicationViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.viewName.title = [[self.caller.reminderArray objectAtIndex: self.index] getName];
    self.dosage.text = [[self.caller.reminderArray objectAtIndex: self.index] getDosage];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self.caller.reminderArray objectAtIndex:self.index] setDosage:self.dosage.text];
}

- (IBAction)delete:(id)sender {
    [self.caller.reminderArray removeObjectAtIndex:self.index];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
