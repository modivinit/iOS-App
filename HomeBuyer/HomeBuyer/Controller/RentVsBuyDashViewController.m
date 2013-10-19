//
//  Dash1HomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#define NUMBER_OF_SERIES 2
#define NUMBER_OF_DATAPOINTS 2

#define RENTAL_SERIES_INDEX 0
#define HOME_SERIES_INDEX 1

#define LIFESTYLE_DATAPOINT_INDEX 0
#define MONTHLY_PAYMENT_DATAPOINT_INDEX 1

#import "RentVsBuyDashViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface RentVsBuyDashViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mRentVsBuyBarChart;
@end

@implementation RentVsBuyDashViewController
{
    NSDictionary* mRentVsBuyData[2];
}


-(void) viewWillAppear:(BOOL)animated
{
    [self.mRentVsBuyDashViewDelegate setNavTitle:@"Rent vs Buy"];
}

-(void) setupChart
{
    self.mRentVsBuyBarChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mRentVsBuyBarChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mRentVsBuyBarChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mRentVsBuyBarChart.xAxis = xAxis;
    self.mRentVsBuyBarChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @5.0;
    self.mRentVsBuyBarChart.yAxis = yAxis;
    self.mRentVsBuyBarChart.legend.hidden = NO;
    self.mRentVsBuyBarChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mRentVsBuyBarChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mRentVsBuyBarChart.legend.style.symbolCornerRadius = @0;
    self.mRentVsBuyBarChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mRentVsBuyBarChart.legend.style.cornerRadius = @0;
    self.mRentVsBuyBarChart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mRentVsBuyBarChart];
    
    self.mRentVsBuyBarChart.datasource = self;
    self.mRentVsBuyBarChart.delegate = self;
    // show the legend
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    mRentVsBuyData[0] = @{@"Monthly Payment" : @1234, @"Lifestyle" : @1234};
    mRentVsBuyData[1] = @{@"Monthly Payment" : @3456, @"Lifestyle" : @5678};
    
    [self setupChart];
}

#pragma mark actions, gesture etc
-(void) addAHome
{
}
#pragma end

- (void)sChart:(ShinobiChart *)chart alterTickMark:(SChartTickMark *)tickMark beforeAddingToAxis:(SChartAxis *)axis
{
    
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return NUMBER_OF_SERIES;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartColumnSeries *lineSeries = [[SChartColumnSeries alloc] init];
    lineSeries.style.lineColor = [UIColor darkGrayColor];
    lineSeries.style.showArea = YES;
//    lineSeries.style.showAreaWithGradient = YES;
//    lineSeries.style.areaColorGradient = [UIColor whiteColor];
    lineSeries.title = index == 0 ? @"Rental" : @"Home";
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return NUMBER_OF_DATAPOINTS;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = mRentVsBuyData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = mRentVsBuyData[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
