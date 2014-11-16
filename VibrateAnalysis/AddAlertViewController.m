//
//  AddAlertViewController.m
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/15/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "AddAlertViewController.h"

@interface AddAlertViewController ()

@end

@implementation AddAlertViewController

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

- (IBAction)addAlert:(id)sender {
    

    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *selected = [self.time date];
    
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit |       NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                   fromDate:selected];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:selected];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    
    [dateComps setHour:[timeComponents hour]];
    [dateComps setMinute:[timeComponents minute]];
    [dateComps setSecond:[timeComponents second]];
    
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    [[self.caller.reminderArray objectAtIndex: self.index] addReminder:itemDate];
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = itemDate;
    NSString *description = @"Don't forget to take ";
    description = [description stringByAppendingString:[[self.caller.reminderArray objectAtIndex:self.index]getName]];
    localNotification.alertBody = description;
    localNotification.alertAction = @"Dismiss";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}





@end
