//
//  DataReadPoint.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/8/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataReadPoint : NSObject


@property double AccelX;
@property double AccelY;
@property double AccelZ;
@property double RotationX;
@property double RotationY;
@property double RotationZ;
@property NSString *TimeStamp;

@end
