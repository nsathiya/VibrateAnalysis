//
//  NSMutableArray+QueueAdditions.h
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/8/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)

- (id) dequeue;
- (void) enqueue:(id)obj;

@end
