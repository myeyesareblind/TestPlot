//
//  BYGyroWrapper.m
//  TestPlotting
//
//  Created by myeyesareblind on 9/19/12.
//  Copyright (c) 2012 MYBR. All rights reserved.
//

#import "BYGyroWrapper.h"
#import "Constants.h"
#import <CoreMotion/CoreMotion.h>


@implementation BYGyroWrapper

- (id)init
{
    self = [super init];
    if (self) {
        _data  = [[NSMutableArray alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
/// start receiving gyroUpdates
        motManager = [[CMMotionManager alloc] init];
#warning check if gyroAvailable
        [motManager setGyroUpdateInterval: TimerTickInterval];
/// on each received data packet populate _data
        [motManager startGyroUpdatesToQueue:queue
                                withHandler:^(CMGyroData *gyroData, NSError *error) {
                                    NSLog(@"gyro update");
                                    if (error) {
                                        NSLog(@"Error: %@", error);
                                    } else {
                                        [_dataLock lock];
                                        [_data addObject: gyroData];
                                        [_dataLock unlock];
                                    }
                                }];
    }
    return self;
}

#pragma mark - CPTPlotDataSource delegate

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    [_dataLock lock];
    NSUInteger count = [_data count];
    [_dataLock unlock];
   
    return count;
}


- (double)doubleForPlot:(CPTPlot *)plot
                  field:(NSUInteger)fieldEnum
            recordIndex:(NSUInteger)index {
    if (fieldEnum == CPTScatterPlotFieldX) {
        return index * TimerTickInterval;
    } else {
        [_dataLock lock];
        CMGyroData *gyroData = [_data objectAtIndex: index];
        [_dataLock unlock];
        return gyroData.rotationRate.z;
    }
}

@end
