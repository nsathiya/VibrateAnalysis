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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.name isFirstResponder] && [touch view] != self.name) {
        [self.name resignFirstResponder];
    } else if ([self.dosage isFirstResponder] && [touch view] != self.dosage) {
        [self.dosage resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)addPressed:(id)sender {
    
    if ([self.name.text isEqualToString: @""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Name field empty"
                                                         delegate:self
                                                cancelButtonTitle:@"Dismiss"
                                                otherButtonTitles: nil];
        [message show];
    } else {
        self.reminder = [[MedicationObject alloc]initWithName:self.name.text dosage:self.dosage.text];
        [self.caller.reminderArray addObject:self.reminder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}


@end
