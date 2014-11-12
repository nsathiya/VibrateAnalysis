//
//  IndividualReminderViewController.h
//  VibrateAnalysis
//
//  Created by Brandon Lim on 11/12/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderObject.h"

@interface IndividualReminderViewController : UIViewController

@property (nonatomic, strong) ReminderObject* individual;

@property (weak, nonatomic) IBOutlet UINavigationItem *viewName;

@property (weak, nonatomic) IBOutlet UITextField *dosage;

@end
