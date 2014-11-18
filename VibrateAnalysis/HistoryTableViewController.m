//
//  HistoryTableViewController.m
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/17/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "HistoryTableViewController.h"

@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController

@synthesize graphTests;
@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CCAppDelegate *appDelegate = (CCAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"DataRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.graphTests = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //self.title = @"Failed Banks";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count is %i", [graphTests count]);

    return [graphTests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set up the cell...
    NSManagedObject *test = [graphTests objectAtIndex:indexPath.row];
    NSDate *date = [test valueForKey:@"Date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd' | 'HH':'mm':'ss a' ";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter stringFromDate:date];
    
    
    
    cell.textLabel.text = [dateFormatter stringFromDate:date];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showGraph"])
    {
        AccelerationViewController *AVC =
        [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        long row = [myIndexPath row];
       
        NSManagedObject *test = [graphTests objectAtIndex:row];
        
        NSMutableArray *accelX = [[NSMutableArray alloc] init];
        NSMutableArray *accelY = [[NSMutableArray alloc] init];
        NSMutableArray *accelZ = [[NSMutableArray alloc] init];
        
        accelX = [NSKeyedUnarchiver unarchiveObjectWithData:[test valueForKey:@"accelX"]];
        accelY = [NSKeyedUnarchiver unarchiveObjectWithData:[test valueForKey:@"accelY"]];
        accelZ = [NSKeyedUnarchiver unarchiveObjectWithData:[test valueForKey:@"accelZ"]];
        
        [AVC setAccelx:accelX];
        [AVC setAccely:accelY];
        [AVC setAccelz:accelZ];
        
    }
    
}
 



@end
