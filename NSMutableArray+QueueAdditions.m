//
//  NSMutableArray+QueueAdditions.m
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/8/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "NSMutableArray+QueueAdditions.h"

@implementation NSMutableArray (QueueAdditions)

-(id) dequeue {
    id queueObject = nil;
    if ([self lastObject])
    {
        // Pick out the first one
#if !__has_feature(objc_arc)
        queueObject = [[[self objectAtIndex: 0] retain] autorelease];
#else
        queueObject = [self objectAtIndex: 0];
#endif
        // Remove it from the queue
        [self removeObjectAtIndex: 0];
    }
    
    // Pass back the dequeued object, if any
    return queueObject;
}

-(void) enqueue:(id)obj{
    [self addObject:obj];
}
@end
