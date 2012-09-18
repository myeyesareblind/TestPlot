//
//  BYRootViewController.h
//  TestPlotting
//
//  Created by myeyesareblind on 9/18/12.
//  Copyright (c) 2012 MYBR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@class BYGyroWrapper;

/*
 RootViewController of application. Inited in ApplicationdidFinishLaunchingWithOptions.
 Contains graphView, timer which updates plot with interval TimerTickInterval(declared in Constants.h)
 GyroUpdates are independent from this timer.
 */

@interface BYRootViewController : UIViewController {
    
    CPTXYGraph*             graph;
    CPTGraphHostingView*    _graphView;
    NSTimer*                _timer;
    BYGyroWrapper*          _gyroWrapper;
}
@end