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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.alerts reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self.caller.reminderArray objectAtIndex:self.index] setDosage:self.dosage.text];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
if ([self.dosage isFirstResponder] && [touch view] != self.dosage) {
        [self.dosage resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



- (IBAction)delete:(id)sender {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                      message:@"Are you sure you want to delete this medication?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Ok"])
    {
        [self.caller.reminderArray removeObjectAtIndex:self.index];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.caller.reminderArray objectAtIndex:self.index] getAlerts].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"alerts";
    UITableViewCell *cell = [self.alerts dequeueReusableCellWithIdentifier:myIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:myIdentifier];
    }
    
    NSDate *date = [[[self.caller.reminderArray objectAtIndex:self.index] getAlerts] objectAtIndex: indexPath.row];
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:date];
    
    NSInteger hour = [timeComponents hour];
    NSInteger minute = [timeComponents minute];
    NSString *hourString;
    NSString *minuteString;
    NSString *ampm;

    if (hour >= 12) {
        ampm = @" pm";
        if (hour > 12){
            hour = hour - 12;
        }
    } else {
        ampm = @" am";
        if (hour == 0){
            hour = 12;
        }
    }
    
    hourString = [NSString stringWithFormat:@"%d", hour];
    
    if (minute < 10){
        minuteString = [NSString stringWithFormat:@"0%d", minute];
    } else {
        minuteString = [NSString stringWithFormat:@"%d", minute];
    }
    
    NSString *colon = @" : ";
    
    NSString *completedTime = [[[hourString stringByAppendingString:colon] stringByAppendingString:minuteString] stringByAppendingString:ampm];
    
    cell.textLabel.text = completedTime;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addAlert"]) {
        AddAlertViewController *destViewController = segue.destinationViewController;
        destViewController.caller = self.caller;
        destViewController.index  = self.index;
    }
}


@end
