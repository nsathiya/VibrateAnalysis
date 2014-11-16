//
//  ReminderObject.h
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicationObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *dosage;
@property (nonatomic, strong) NSMutableArray *alerts;

- (id) initWithName:(NSString *)name dosage:(NSString *)dosage;
- (NSString *) getName;
- (NSString *) getDosage;
- (NSMutableArray *) getAlerts;

- (void) addReminder:(NSDate *)date;
- (void) removeReminder:(NSInteger)index;

@end
