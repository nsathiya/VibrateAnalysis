//
//  ReminderTableViewController.m
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/11/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "MedicationTableViewController.h"
#import "IndividualMedicationViewController.h"
#import "AddMedicationViewController.h"

@implementation MedicationTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    MedicationObject *drug1 = [[MedicationObject alloc]initWithName:@"Sinemet" dosage:@"25"];
    MedicationObject *drug2 = [[MedicationObject alloc]initWithName:@"Lopressor" dosage:@"50"];
    MedicationObject *drug3 = [[MedicationObject alloc]initWithName:@"Inderal" dosage:@"75"];
    
    self.reminderArray = [[NSMutableArray alloc] initWithObjects:drug1, drug2, drug3, nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
        IndividualMedicationViewController *destViewController = segue.destinationViewController;
        destViewController.caller = self;
        destViewController.index = indexPath.row;
    } else if ([segue.identifier isEqualToString:@"addView"]) {
        AddMedicationViewController *destViewController = segue.destinationViewController;
        destViewController.caller = self;
    }
}

@end







