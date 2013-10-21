//
//  Dash2HomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/3/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "Home1VsHome2ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface Home1VsHome2ViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mHome1VsHome2Chart;
@end

@implementation Home1VsHome2ViewController
{
    NSDictionary* mHome1VsHome1Data[2];
}

-(void) setupChart
{
    self.mHome1VsHome2Chart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mHome1VsHome2Chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mHome1VsHome2Chart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mHome1VsHome2Chart.xAxis = xAxis;
    self.mHome1VsHome2Chart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @5.0;
    self.mHome1VsHome2Chart.yAxis = yAxis;
    self.mHome1VsHome2Chart.legend.hidden = NO;
    self.mHome1VsHome2Chart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mHome1VsHome2Chart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mHome1VsHome2Chart.legend.style.symbolCornerRadius = @0;
    self.mHome1VsHome2Chart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mHome1VsHome2Chart.legend.style.cornerRadius = @0;
    self.mHome1VsHome2Chart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mHome1VsHome2Chart];
    
    self.mHome1VsHome2Chart.datasource = self;
    self.mHome1VsHome2Chart.delegate = self;
    // show the legend
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomes1VsHome2Delegate setNavTitle:@"Monthly Payment"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mHome1VsHome1Data[0] = @{@"Monthly Payment" : @1234, @"Lifestyle" : @1234};
    mHome1VsHome1Data[1] =  @{@"Monthly Payment" : @3456, @"Lifestyle" : @5678};
    
    [self setupChart];
}

- (void)sChart:(ShinobiChart *)chart alterTickMark:(SChartTickMark *)tickMark beforeAddingToAxis:(SChartAxis *)axis
{
    
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartColumnSeries *lineSeries = [[SChartColumnSeries alloc] init];
    lineSeries.style.lineColor = [UIColor darkGrayColor];
    lineSeries.style.showArea = YES;
    //    lineSeries.style.showAreaWithGradient = YES;
    //    lineSeries.style.areaColorGradient = [UIColor whiteColor];
    lineSeries.title = index == 0 ? @"Home 1" : @"Home 2";
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 2;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = mHome1VsHome1Data[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = mHome1VsHome1Data[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
