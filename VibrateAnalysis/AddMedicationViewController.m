//
//  AddReminderViewController.m
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/13/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "AddMedicationViewController.h"

@interface AddMedicationViewController ()

@end

@implementation AddMedicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addPressed:(id)sender {
    self.reminder = [[MedicationObject alloc]initWithName:self.name.text dosage:self.dosage.text];
    [self.caller.reminderArray addObject:self.reminder];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
