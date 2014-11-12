//
//  ReminderObject.h
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReminderObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *dosage;
@property (nonatomic, strong) NSMutableArray *alerts;

- (id) initWithName:(NSString *)name dosage:(NSNumber *)dosage;
- (NSString *) getName;
- (NSNumber *) getDosage;

@end
