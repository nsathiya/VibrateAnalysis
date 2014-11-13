//
//  ReminderObject.m
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "ReminderObject.h"

@implementation ReminderObject

- (id) initWithName:(NSString *)name dosage:(NSString *)dosage
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.dosage = dosage;
        self.alerts = [[NSMutableArray alloc]init];
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

@end
