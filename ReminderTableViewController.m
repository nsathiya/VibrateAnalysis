//
//  ReminderTableViewController.m
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/11/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "ReminderTableViewController.h"
#import "IndividualReminderViewController.h"

@implementation ReminderTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    ReminderObject *drug1 = [[ReminderObject alloc]initWithName:@"Sinemet" dosage:@25];
    ReminderObject *drug2 = [[ReminderObject alloc]initWithName:@"Lopressor" dosage:@50];
    ReminderObject *drug3 = [[ReminderObject alloc]initWithName:@"Inderal" dosage:@75];
    
    self.reminderArray = [[NSMutableArray alloc] initWithObjects:drug1, drug2, drug3, nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reminderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Reminder";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text = [[self.reminderArray objectAtIndex:indexPath.row] getName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"individualView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        IndividualReminderViewController *destViewController = segue.destinationViewController;
        destViewController.individual = [self.reminderArray objectAtIndex:indexPath.row];
    }
}

@end







