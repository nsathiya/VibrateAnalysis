//
//  ScatterPlotViewController.m
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/7/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "ScatterPlotViewController.h"


@interface ScatterPlotViewController ()

@end

@implementation ScatterPlotViewController

float *magnitude;
float *phase_lev;
NSInteger count;
NSInteger seconds;
NSTimer *timer;

@synthesize hostView = hostView_;
@synthesize managedObjectContext;

- (IBAction)startRecording:(id)sender {
	// Do any additional setup after loading the view, typically from a nib.
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    self.dataQueue = [[NSMutableArray alloc] init];
    
    seconds = 15;
    //self.countLabel.text = [NSString stringWithFormat:@"%i", seconds];
    [self.oneClickLabel setTitle:[NSString stringWithFormat:@"%i", seconds] forState:UIControlStateNormal];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime) userInfo:Nil repeats:YES];
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelerationData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    
    
}

- (IBAction)AnalysisButton:(id)sender {
     [self performSegueWithIdentifier:@"MPAnalysis" sender:nil];
}
/*
- (IBAction)resetMaxValues:(id)sender
{
    
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    [self.dataQueue removeAllObjects];
}
*/
-(void) outputAccelerationData:(CMAcceleration)acceleration
{
    DataReadPoint *drp = [[DataReadPoint alloc] init];
    drp.AccelX = acceleration.x;
    drp.AccelY = acceleration.y;
    drp.AccelZ = acceleration.z;
    NSDate *date = [NSDate date];
    
    //NSLog(@"accel in xyz is %lf, %lf,%lf", drp.AccelX, drp.AccelY, drp.AccelZ);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    drp.TimeStamp = [dateFormatter stringFromDate:date];
    
    [self.dataQueue enqueue:drp];
    [self.hostView.hostedGraph reloadData];
    
    
}

-(void) outputRotationData:(CMRotationRate)rotation
{
    /*
    self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    if(fabs(rotation.x) > fabs(currentMaxRotX))
    {
        currentMaxRotX = rotation.x;
    }
    self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    if(fabs(rotation.y) > fabs(currentMaxRotY))
    {
        currentMaxRotY = rotation.y;
    }
    self.rotZ.text = [NSString stringWithFormat:@" %.2fr/s",rotation.z];
    if(fabs(rotation.z) > fabs(currentMaxRotZ))
    {
        currentMaxRotZ = rotation.z;
    }
    
    self.maxRotX.text = [NSString stringWithFormat:@" %.2f",currentMaxRotX];
    self.maxRotY.text = [NSString stringWithFormat:@" %.2f",currentMaxRotY];
    self.maxRotZ.text = [NSString stringWithFormat:@" %.2f",currentMaxRotZ];
    */
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.oneClickLabel setTitle:[NSString stringWithFormat:@"Start Measuring"] forState:UIControlStateNormal];
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
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    self.hostView.hostedGraph = graph;
    
    //Set graph title
    NSString *title = @"XYZ Acceleration";
    graph.title = title;
    
    //Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
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
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -1.5 ) length:CPTDecimalFromFloat( 3.0 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 10 )]];
    
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
    
    /*
    NSInteger count = [self.dataQueue count];
    const int LOG_N = 4; // Typically this would be at least 10 (i.e. 1024pt FFTs)
    const int N = (int) count; //1 << LOG_N;
    const float PI = 4*atan(1);
    
        // Set up a data structure with pre-calculated values for
        // doing a very fast FFT. The structure is opaque, but presumably
        // includes sin/cos twiddle factors, and a lookup table for converting
        // to/from bit-reversed ordering. Normally you'd create this once
        // in your application, then use it for many (hundreds! thousands!) of
        // forward and inverse FFTs.
        FFTSetup fftSetup = vDSP_create_fftsetup(LOG_N, kFFTRadix2);
        
        // -------------------------------
        // Set up a bunch of buffers
        
        // Buffers for real (time-domain) input and output signals.
        float *data = (float *) malloc(N * sizeof(float));
        //float *y = new float[N];
        
        // Initialize the input buffer with a sinusoid
        //int BIN = 3;
        for (int k = 0; k < N; k++)
        {
            float x = pow([[self.dataQueue objectAtIndex:k] AccelX], 2);
            float y = pow([[self.dataQueue objectAtIndex:k] AccelY], 2);
            float z = pow([[self.dataQueue objectAtIndex:k] AccelZ], 2);
            data[k] = sqrt(x + y + z);
        }
    
        // We need complex buffers in two different formats!
        //DSPComplex *tempComplex = new DSPComplex[N/2];
    
        DSPSplitComplex tempSplitComplex;
        tempSplitComplex.realp = (float *) malloc(N/2 * sizeof(float));
        tempSplitComplex.imagp = (float *) malloc(N/2 * sizeof(float));
        
        // For polar coordinates
        //float *mag = float[N/2];
        //float *phase = float[N/2];
        float *mag = (float *) malloc (N/2 * sizeof(float)); //[[NSMutableArray alloc] init];
        float *phase = (float *) malloc (N/2 * sizeof(float)); //[[NSMutableArray alloc] init];
        magnitude = (float *) malloc (N/2 * sizeof(float)); //[[NSMutableArray alloc] init];
        phase_lev = (float *) malloc (N/2 * sizeof(float)); //[[NSMutableArray alloc] init];
    
        // ----------------------------------------------------------------
        // Forward FFT
        
        // Scramble-pack the real data into complex buffer in just the way that's
        // required by the real-to-complex FFT function that follows.
        vDSP_ctoz((COMPLEX *)data, 2, &tempSplitComplex, 1, N/2);
    
        // Do real->complex forward FFT
        vDSP_fft_zrip(fftSetup, &tempSplitComplex, 1, LOG_N, kFFTDirection_Forward);
        
        // Print the complex spectrum. Note that since it's the FFT of a real signal,
        // the spectrum is conjugate symmetric, that is the negative frequency components
        // are complex conjugates of the positive frequencies. The real->complex FFT
        // therefore only gives us the positive half of the spectrum from bin 0 ("DC")
        // to bin N/2 (Nyquist frequency, i.e. half the sample rate). Typically with
        // audio code, you don't need to worry much about the DC and Nyquist values, as
        // they'll be very close to zero if you're doing everything else correctly.
        //
        // Bins 0 and N/2 both necessarily have zero phase, so in the packed format
        // only the real values are output, and these are stuffed into the real/imag components
        // of the first complex value (even though they are both in fact real values). Try
        // replacing BIN above with N/2 to see how sinusoid at Nyquist appears in the spectrum.
        printf("\nSpectrum:\n");
        for (int k = 0; k < N/2; k++)
        {
            printf("%3d\t%6.2f\t%6.2f\n", k, tempSplitComplex.realp[k], tempSplitComplex.imagp[k]);
        }
        
        // ----------------------------------------------------------------
        // Convert from complex/rectangular (real, imaginary) coordinates
        // to polar (magnitude and phase) coordinates.
        
        // Compute magnitude and phase. Can also be done using vDSP_polar.
        // Note that when printing out the values below, we ignore bin zero, as the
        // real/complex values for bin zero in tempSplitComplex actually both correspond
        // to real spectrum values for bins 0 (DC) and N/2 (Nyquist) respectively.
        vDSP_zvabs(&tempSplitComplex, 1, mag, 1, N/2);
        vDSP_zvphas(&tempSplitComplex, 1, phase, 1, N/2);
        
        printf("\nMag / Phase:\n");
        for (int k = 1; k < N/2; k++)
        {
            printf("%3d\t%6.2f\t%6.2f\n", k, mag[k], phase[k]);
            magnitude[k] = mag[k];
            phase_lev[k] = phase[k];
        }
     */
    
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
            updatedRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -1.5 ) length:CPTDecimalFromFloat( 3.0 )];//((CPTXYPlotSpace *)space).yRange;
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

-(void)subtractTime{
    seconds--;
    
    //self.countLabel.text = [NSString stringWithFormat:@"%i", seconds];
    [self.oneClickLabel setTitle:[NSString stringWithFormat:@"%i", seconds] forState:UIControlStateNormal];
    if(seconds == 0)
    {
        [timer invalidate];
        /*
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *failedBankInfo = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"FailedBankInfo"
                                           inManagedObjectContext:context];
        [failedBankInfo setValue:@"Test Bank" forKey:@"name"];
        [failedBankInfo setValue:@"Testville" forKey:@"city"];
        [failedBankInfo setValue:@"Testland" forKey:@"state"];
        NSManagedObject *failedBankDetails = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"FailedBankDetails"
                                              inManagedObjectContext:context];
        [failedBankDetails setValue:[NSDate date] forKey:@"closeDate"];
        [failedBankDetails setValue:[NSDate date] forKey:@"updateDate"];
        [failedBankDetails setValue:[NSNumber numberWithInt:12345] forKey:@"zip"];
        [failedBankDetails setValue:failedBankInfo forKey:@"info"];
        [failedBankInfo setValue:failedBankDetails forKey:@"details"];
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        */
        
        [self performSegueWithIdentifier:@"MPAnalysis" sender:nil];
    }
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
    return [self.dataQueue count];
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
        //NSLog(@"plot identifier is %@", plot.identifier);
        if([plot.identifier isEqual:@"xPlot"] == YES)
            /*
            NSLog(@"mag is %lf", magnitude[index]);
            return [NSNumber numberWithFloat:magnitude[index]];
        */
            return [NSNumber numberWithDouble:[[self.dataQueue objectAtIndex:index] AccelX]];
        else if([plot.identifier isEqual:@"yPlot"] == YES)
            return [NSNumber numberWithDouble:[[self.dataQueue objectAtIndex:index] AccelY]];
        else if([plot.identifier isEqual:@"zPlot"] == YES)
            return [NSNumber numberWithDouble:[[self.dataQueue objectAtIndex:index] AccelZ]];

    }
    

    return [NSDecimalNumber zero];
}

- (IBAction)MPAnalysis:(id)sender {
    NSLog(@"analysis chosed");
    [self performSegueWithIdentifier:@"MPAnalysis" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"MPAnalysis"])
    {
         NSLog(@"about to segue");
         AAnalysisController *AAC = [segue destinationViewController];
        
        [AAC setDataQueue:_dataQueue];
    }
    
}

@end
