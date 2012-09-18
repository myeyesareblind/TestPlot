//
//  BYRootViewController.m
//  TestPlotting
//
//  Created by myeyesareblind on 9/18/12.
//  Copyright (c) 2012 MYBR. All rights reserved.
//

#import "BYRootViewController.h"
#import "Constants.h"
#import "BYGyroWrapper.h"


@interface BYRootViewController ()
- (void)  timerTick: (NSTimer*) t;
@end

@implementation BYRootViewController


- (id)init {
    self = [super init];
    if (self) {
        _timer      = [NSTimer scheduledTimerWithTimeInterval: TimerTickInterval
                                                       target: self
                                                     selector: @selector(timerTick:)
                                                     userInfo: NULL
                                                      repeats: YES];
        _gyroWrapper = [[BYGyroWrapper alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return UIInterfaceOrientationLandscapeLeft == interfaceOrientation;
}



- (void) timerTick:(NSTimer *)t {
#warning TODO: scroll plot if neccesary
    [graph reloadData];
}



- (void)loadView {
    /// these stolen from corePlot examples, with little fixes.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    _graphView          = [[CPTGraphHostingView alloc] initWithFrame: screenBounds];
    _graphView.allowPinchScaling = NO;
    self.view           = _graphView;
    
    
	// Create graph from theme
	graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[graph applyTheme:theme];
	CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
	hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
	hostingView.hostedGraph		= graph;
    
	graph.paddingLeft	= .0;
	graph.paddingTop	= .0;
	graph.paddingRight	= .0;
	graph.paddingBottom = .0;
    graph.cornerRadius  = .0;
    
	// Setup plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
	plotSpace.xRange				= [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1) length:CPTDecimalFromFloat(MAX_X_OnScreenRange)];
	plotSpace.yRange				= [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-MAX_Y_Range) length:CPTDecimalFromFloat(MAX_Y_Range*2)];
    plotSpace.globalXRange          = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1) length:CPTDecimalFromFloat(10000000)];
	plotSpace.globalYRange          = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-MAX_Y_Range) length:CPTDecimalFromFloat(MAX_Y_Range*2)];
    
	// Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
	x.majorIntervalLength		  = CPTDecimalFromString(@"5");
	x.minorTicksPerInterval		  = 10;

   
	CPTXYAxis *y = axisSet.yAxis;
	y.majorIntervalLength		  = CPTDecimalFromString(@"0.5");
	y.minorTicksPerInterval		  = 5;
    
	// Create a blue plot area
	CPTScatterPlot *boundLinePlot  = [[CPTScatterPlot alloc] init];
	CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
	lineStyle.miterLimit		= 1.0f;
	lineStyle.lineWidth			= 3.0f;
	lineStyle.lineColor			= [CPTColor blueColor];
	boundLinePlot.dataLineStyle = lineStyle;
	boundLinePlot.dataSource	= _gyroWrapper;
	[graph addPlot:boundLinePlot];
    
    
	// Add plot symbols
	CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor blackColor];
	CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill			 = [CPTFill fillWithColor:[CPTColor blueColor]];
	plotSymbol.lineStyle	 = symbolLineStyle;
	plotSymbol.size			 = CGSizeMake(10.0, 10.0);
	boundLinePlot.plotSymbol = plotSymbol;
}
@end