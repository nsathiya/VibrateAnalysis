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
    
    NSString *time = [NSString stringWithFormat:@"%d : %d", [timeComponents hour], [timeComponents minute]];
    
    cell.textLabel.text = time;
    
    return cell;
}


@end
