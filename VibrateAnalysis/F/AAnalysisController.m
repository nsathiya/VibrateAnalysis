//
//  AAnalysisController.m
//  VibrateAnalysis
//
//  Created by Naren Sathiya on 11/14/14.
//  Copyright (c) 2014 Naren Sathiya. All rights reserved.
//

#import "AAnalysisController.h"

@interface AAnalysisController ()

@end

@implementation AAnalysisController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

float *magnitude;
float *phase_lev;

@synthesize hostView = hostView_;


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initPlot];
}

- (void) initPlot {
    [self configureAnalysis];
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

- (void) configureAnalysis{
    NSInteger count = [self.dataQueue count];
    NSLog(@"count is %li", (long)count);
    const int LOG_N = 6; // Typically this would be at least 10 (i.e. 1024pt FFTs)
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
    float *y = (float *) malloc(N * sizeof(float));
    
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
    magnitude = (float *) malloc (N * sizeof(float)); //[[NSMutableArray alloc] init];
    //phase_lev = (float *) malloc (N/2 * sizeof(float)); //[[NSMutableArray alloc] init];
    
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
        //magnitude[k] = tempSplitComplex.realp[k]; //realp[k]; //mag[k];
        //phase_lev[k] = tempSplitComplex.imagp[k]; //phase[k];
    }
    
    tempSplitComplex.realp = mag;
    tempSplitComplex.imagp = phase;

    DSPComplex *tempComplex = (DSPComplex *) malloc(N * sizeof(float));
    
    vDSP_ztoc(&tempSplitComplex, 1, tempComplex, 2, N/2);
    vDSP_rect((float*) tempComplex, 2, (float*)tempComplex, 2, N/2);
    vDSP_ctoz(tempComplex, 2, &tempSplitComplex, 1, N/2);
    
    vDSP_fft_zrip(fftSetup, &tempSplitComplex, 1, LOG_N, kFFTDirection_Inverse);
    
    // This leaves result in packed format. Here we unpack it into a real vector.
    vDSP_ztoc(&tempSplitComplex, 1, (DSPComplex*)y, 2, N/2);
    
    // Neither the forward nor inverse FFT does any scaling. Here we compensate for that.
    float scale = 1.0/N;
    vDSP_vsmul(y, 1, &scale, y, 1, N);
    
    // Assuming it's all correct, the input x and output y vectors will have identical values
    printf("\nInput & output:\n");
    for (int k = 0; k < N; k++)
    {
        printf("%3d\t%6.2f\t%6.2f\n", k, data[k], y[k]);
        magnitude[k] = (y[k] - 1) * 2;
    }
    
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
    NSString *title = @"Frequency | Time";
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
    //plotSpace.delegate = self; //COMMENT THIS OUT TO MOVE Y AXIS
    
    
    // 2 - Create the three plots
    CPTBarPlot *mpPlot = [[CPTBarPlot alloc] init];
    mpPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:128 green:0 blue:0 alpha:1] horizontalBars:NO];
    mpPlot.dataSource = self;
    mpPlot.identifier = @"M/P Analysis";
    mpPlot.barWidth = CPTDecimalFromDouble(0.8);
    
    // 3 - Set up plot space
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -0.5 ) length:CPTDecimalFromFloat( 6.0 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -1 ) length:CPTDecimalFromFloat( 40 )]];
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *mpLineStyle = [[CPTMutableLineStyle alloc] init];
    CPTColor *mpColor = [CPTColor lightGrayColor];
    mpLineStyle.lineWidth = 0.5;
    mpLineStyle.lineColor = mpColor;
    mpPlot.lineStyle = mpLineStyle;
    
    [graph addPlot:mpPlot toPlotSpace:plotSpace];
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - PlotDataSourceDelegate methods
- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.dataQueue count]/2;
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
         //NSLog(@"phase is %lf", phase_lev[index]);
        return [NSNumber numberWithInt:index];//[NSNumber numberWithFloat:phase_lev[index]];
    } else {
        if([plot.identifier isEqual:@"M/P Analysis"] == YES)
         //NSLog(@"mag is %lf", magnitude[index]);
         return [NSNumber numberWithFloat:magnitude[index]];
    }
    
    
    return [NSDecimalNumber zero];

    }


@end
    

