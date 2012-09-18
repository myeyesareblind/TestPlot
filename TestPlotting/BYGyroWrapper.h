//
//  BYGyroWrapper.h
//  TestPlotting
//
//  Created by myeyesareblind on 9/19/12.
//  Copyright (c) 2012 MYBR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@class CMMotionManager;

/*
 This class start gyroUpdate, and handles incoming gyroData
 Is datasource for plot
 Inited in [RootViewcontroller init]
 */

@interface BYGyroWrapper : NSObject  <CPTPlotDataSource> {
    NSMutableArray*     _data;          /// gyroData
    NSLock*             _dataLock;      /// performing gyroHandles in concurrent OperationQueue
    CMMotionManager*    motManager;
}
@end
