//
//  CCViewController.m
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/4/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "CCViewController.h"

@interface CCViewController ()

@end

@implementation CCViewController

@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

-(void)viewDidAppear:(BOOL)animated{
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetData:(id)sender {
    
    CCAppDelegate *appDelegate = (CCAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"DataRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *graphTests = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject * graph in graphTests) {
        [self.managedObjectContext deleteObject:graph];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
     
}




/*
#pragma mark - PlotDataSourceDelegate methods
- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.dataQueue count];
}

- (NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    // We need to provide an X or Y (this method will be called for each) value for every index
    
    // This method is actually called twice per point in the plot, one for the X and one for the Y value
    if(fieldEnum == CPTScatterPlotFieldX)
    {
        // Return x value, which will, depending on index, be between -4 to 4
        return [NSNumber numberWithInt: index];
    } else {
        // Return y value, for this example we'll be plotting y = x * x
        return [NSNumber numberWithDouble:[[self.dataQueue objectAtIndex:index] AccelX]];
    }
}
 */
- (IBAction)toGraph:(id)sender {
    
    [self performSegueWithIdentifier:@"toGraph" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"toGraph"])
    {
        ScatterPlotViewController *SPVC = [segue destinationViewController];
        
        //[SPVC setDataQueue:_dataQueue];
    }
}

@end
