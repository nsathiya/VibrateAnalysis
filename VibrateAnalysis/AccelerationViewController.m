//
//  AccelerationViewController.m
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/17/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "AccelerationViewController.h"

@interface AccelerationViewController ()

@end

@implementation AccelerationViewController

@synthesize hostView = hostView_;
@synthesize accelx;
@synthesize accely;
@synthesize accelz;

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initPlot];
}

- (void) initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

- (void) configureHost {
    
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.graphView.bounds];
    self.hostView.allowPinchScaling = YES; //FOR ZOOMING IN/OUT
    [self.graphView addSubview:self.hostView];
}

- (void) configureGraph {
    
    //Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    
    //Set graph title
    NSString *title = @"X-Y-Z Acceleration | Time";
    graph.title = title;
    
    //Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor colorWithComponentRed:128 green:0 blue:0 alpha:1];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 22.0f);
    
    //Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:10.0f];
    [graph.plotAreaFrame setPaddingTop:30.0f];
    
    //Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

- (void) configurePlots {
    
    //CCViewController *view = [[CCViewController alloc] init];
    
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.delegate = self; //COMMENT THIS OUT TO MOVE Y AXIS
    
    
    // 2 - Create the three plots
    CPTScatterPlot *xPlot = [[CPTScatterPlot alloc] init];
    xPlot.dataSource = self;
    xPlot.identifier = @"xPlot";
    CPTColor *xColor = [CPTColor redColor];
    [graph addPlot:xPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *yPlot = [[CPTScatterPlot alloc] init];
    yPlot.dataSource = self;
    yPlot.identifier = @"yPlot";
    CPTColor *yColor = [CPTColor greenColor];
    [graph addPlot:yPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *zPlot = [[CPTScatterPlot alloc] init];
    zPlot.dataSource = self;
    zPlot.identifier = @"zPlot";
    CPTColor *zColor = [CPTColor blueColor];
    [graph addPlot:zPlot toPlotSpace:plotSpace];
    
    // 3 - Set up plot space
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -2.0 ) length:CPTDecimalFromFloat( 4.0 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 16 )]];
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *xLineStyle = [xPlot.dataLineStyle mutableCopy];
    xLineStyle.lineWidth = 2.5;
    xLineStyle.lineColor = xColor;
    xPlot.dataLineStyle = xLineStyle;
    CPTMutableLineStyle *xSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    xSymbolLineStyle.lineColor = xColor;
    CPTPlotSymbol *xSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    xSymbol.fill = [CPTFill fillWithColor:xColor];
    xSymbol.lineStyle = xSymbolLineStyle;
    xSymbol.size = CGSizeMake(6.0f, 6.0f);
    xPlot.plotSymbol = xSymbol;
    
    CPTMutableLineStyle *yLineStyle = [yPlot.dataLineStyle mutableCopy];
    yLineStyle.lineWidth = 2.5;
    yLineStyle.lineColor = yColor;
    yPlot.dataLineStyle = yLineStyle;
    CPTMutableLineStyle *ySymbolLineStyle = [CPTMutableLineStyle lineStyle];
    ySymbolLineStyle.lineColor = yColor;
    CPTPlotSymbol *ySymbol = [CPTPlotSymbol starPlotSymbol];
    ySymbol.fill = [CPTFill fillWithColor:yColor];
    ySymbol.lineStyle = ySymbolLineStyle;
    ySymbol.size = CGSizeMake(6.0f, 6.0f);
    yPlot.plotSymbol = ySymbol;
    
    CPTMutableLineStyle *zLineStyle = [zPlot.dataLineStyle mutableCopy];
    zLineStyle.lineWidth = 2.5;
    zLineStyle.lineColor = zColor;
    zPlot.dataLineStyle = zLineStyle;
    CPTMutableLineStyle *zSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    zSymbolLineStyle.lineColor = zColor;
    CPTPlotSymbol *zSymbol = [CPTPlotSymbol diamondPlotSymbol];
    zSymbol.fill = [CPTFill fillWithColor:zColor];
    zSymbol.lineStyle = zSymbolLineStyle;
    zSymbol.size = CGSizeMake(6.0f, 6.0f);
    zPlot.plotSymbol = zSymbol;
}

- (void) configureAxes {
    
    // leave the titleLocation for both axes at the default (NAN) to center the titles
    //xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    //yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    
    /*
     
     // 1 - Create styles
     CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
     axisTitleStyle.color = [CPTColor whiteColor];
     axisTitleStyle.fontName = @"Helvetica-Bold";
     axisTitleStyle.fontSize = 12.0f;
     CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
     axisLineStyle.lineWidth = 2.0f;
     axisLineStyle.lineColor = [CPTColor whiteColor];
     CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
     axisTextStyle.color = [CPTColor whiteColor];
     axisTextStyle.fontName = @"Helvetica-Bold";
     axisTextStyle.fontSize = 11.0f;
     CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
     tickLineStyle.lineColor = [CPTColor whiteColor];
     tickLineStyle.lineWidth = 2.0f;
     CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
     tickLineStyle.lineColor = [CPTColor blackColor];
     tickLineStyle.lineWidth = 1.0f;
     // 2 - Get axis set
     CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
     // 3 - Configure x-axis
     CPTAxis *x = axisSet.xAxis;
     x.title = @"Day of Month";
     x.titleTextStyle = axisTitleStyle;
     x.titleOffset = 15.0f;
     x.axisLineStyle = axisLineStyle;
     x.labelingPolicy = CPTAxisLabelingPolicyNone;
     x.labelTextStyle = axisTextStyle;
     x.majorTickLineStyle = axisLineStyle;
     x.majorTickLength = 4.0f;
     x.tickDirection = CPTSignNegative;
     CGFloat dateCount = 9.0;
     NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
     NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
     NSInteger i = 0;
     for (NSString *date in [[CPDStockPriceStore sharedInstance] datesInMonth]) {
     CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
     CGFloat location = i++;
     label.tickLocation = CPTDecimalFromCGFloat(location);
     label.offset = x.majorTickLength;
     if (label) {
     [xLabels addObject:label];
     [xLocations addObject:[NSNumber numberWithFloat:location]];
     }
     }
     for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
     NSUInteger mod = j % majorIncrement;
     if (mod == 0) {
     CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
     NSDecimal location = CPTDecimalFromInteger(j);
     label.tickLocation = location;
     label.offset = -y.majorTickLength - y.labelOffset;
     if (label) {
     [yLabels addObject:label];
     }
     [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
     } else {
     [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
     }
     }
     x.axisLabels = xLabels;
     x.majorTickLocations = xLocations;
     
     // 4 - Configure y-axis
     CPTAxis *y = axisSet.yAxis;
     y.title = @"Price";
     y.titleTextStyle = axisTitleStyle;
     y.titleOffset = -40.0f;
     y.axisLineStyle = axisLineStyle;
     y.majorGridLineStyle = gridLineStyle;
     y.labelingPolicy = CPTAxisLabelingPolicyNone;
     y.labelTextStyle = axisTextStyle;
     y.labelOffset = 16.0f;
     y.majorTickLineStyle = axisLineStyle;
     y.majorTickLength = 4.0f;
     y.minorTickLength = 2.0f;
     y.tickDirection = CPTSignPositive;
     NSInteger majorIncrement = 100;
     NSInteger minorIncrement = 50;
     CGFloat yMax = 700.0f;  // should determine dynamically based on max price
     NSMutableSet *yLabels = [NSMutableSet set];
     NSMutableSet *yMajorLocations = [NSMutableSet set];
     NSMutableSet *yMinorLocations = [NSMutableSet set];
     for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
     NSUInteger mod = j % majorIncrement;
     if (mod == 0) {
     CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
     NSDecimal location = CPTDecimalFromInteger(j);
     label.tickLocation = location;
     label.offset = -y.majorTickLength - y.labelOffset;
     if (label) {
     [yLabels addObject:label];
     }
     [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
     } else {
     [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
     }
     }
     y.axisLabels = yLabels;
     y.majorTickLocations = yMajorLocations;
     y.minorTickLocations = yMinorLocations;
     
     */
    
}

- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange
              forCoordinate:(CPTCoordinate)coordinate {
    
    CPTPlotRange *updatedRange = nil;
    
    switch ( coordinate ) {
        case CPTCoordinateX:
            if (newRange.locationDouble < 0.0F) {
                CPTMutablePlotRange *mutableRange = [newRange mutableCopy];
                mutableRange.location = CPTDecimalFromFloat(0.0);
                updatedRange = mutableRange;
            }
            else {
                updatedRange = newRange;
            }
            break;
        case CPTCoordinateY:
            //SO Y AXIS Doesn't move
            updatedRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -2.0 ) length:CPTDecimalFromFloat( 4.0 )];//((CPTXYPlotSpace *)space).yRange;
            break;
    }
    return updatedRange;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - PlotDataSourceDelegate methods
- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.accelx count];
}

- (NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    /*
     if(phase_lev[index] == 0.0)
     {
     return [NSDecimalNumber zero];
     }
     */
    if(fieldEnum == CPTScatterPlotFieldX)
    {
        return [NSNumber numberWithInt: index];
        /*
         NSLog(@"phase is %lf", phase_lev[index]);
         return [NSNumber numberWithFloat:phase_lev[index]];
         */
    } else {
        if([plot.identifier isEqual:@"xPlot"] == YES)
        {
            CGFloat x = (CGFloat) [[self.accelx objectAtIndex:index] floatValue];
            return [NSNumber numberWithFloat:x];
        }
        else if([plot.identifier isEqual:@"yPlot"] == YES)
        {
            CGFloat y = (CGFloat) [[self.accely objectAtIndex:index] floatValue];
            return [NSNumber numberWithFloat:y];
        }
        else if([plot.identifier isEqual:@"zPlot"] == YES)
        {
            CGFloat z = (CGFloat) [[self.accelz objectAtIndex:index] floatValue];
            return [NSNumber numberWithFloat:z];
        }
    }
    
    
    return [NSDecimalNumber zero];
}

- (IBAction)analysisButton:(id)sender {
    [self performSegueWithIdentifier:@"FrequencyAnalysis" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"FrequencyAnalysis"])
    {
        FrequencyViewController *FVC = [segue destinationViewController];
        [FVC setAccelX:self.accelx];
        [FVC setAccelY:self.accely];
        [FVC setAccelZ:self.accelz];
    }
    
}


@end
