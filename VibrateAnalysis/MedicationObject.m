//
//  ReminderObject.m
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "MedicationObject.h"

@implementation MedicationObject

- (id) initWithName:(NSString *)name dosage:(NSString *)dosage
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.dosage = dosage;
        self.alerts = [[NSMutableArray alloc]init];
        [self.alerts addObject:[NSDate date]];
    }
    return self;
}

- (NSString *) getName
{
    return self.name;
}

- (NSString *) getDosage
{
    return self.dosage;
}

- (NSMutableArray *) getAlerts
{
    return self.alerts;
}

- (NSDate *) getDate:(NSInteger)index
{
    return [self.alerts objectAtIndex:index];
}

- (void) addReminder:(NSDate *)date
{
    [self.alerts addObject:date];
}

- (void) removeReminder:(NSInteger)index
{
    [self.alerts removeObjectAtIndex:index];
}


@end
