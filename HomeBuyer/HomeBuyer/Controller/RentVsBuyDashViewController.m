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

@interface RentVsBuyDashViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mRentVsBuyBarChart;
@end

@implementation RentVsBuyDashViewController
{
    NSDictionary* _sales[2];
}


-(void) viewWillAppear:(BOOL)animated
{
    [self.mRentVsBuyDashViewDelegate setNavTitle:@"Rent vs Buy"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    _sales[0] = @{@"Monthly Payment" : @1234, @"Lifestyle" : @1234};
    _sales[1] = @{@"Monthly Payment" : @3456, @"Lifestyle" : @5678};
    self.mRentVsBuyBarChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mRentVsBuyBarChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mRentVsBuyBarChart.licenseKey = SHINOBI_LICENSE_KEY; // TODO: add your trial licence key here!

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
    lineSeries.style.showAreaWithGradient = YES;
    lineSeries.style.areaColorGradient = [UIColor whiteColor];
    lineSeries.title = index == 0 ? @"Rental" : @"Home";
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return NUMBER_OF_DATAPOINTS;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = _sales[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = _sales[seriesIndex][key];
    return datapoint;
//    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
//    
//    if(seriesIndex == LIFESTYLE_DATAPOINT_INDEX)
//    {
//        if(dataIndex == RENTAL_SERIES_INDEX)
//        {
//            datapoint.xValue = @"RL";
//            datapoint.yValue = @1234;
//        }
//        else if(dataIndex == HOME_SERIES_INDEX)
//        {
//            datapoint.xValue = @"HL";
//            datapoint.yValue = @1234;
//        }
//    }
//    else if(seriesIndex == MONTHLY_PAYMENT_DATAPOINT_INDEX)
//    {
//        if(dataIndex == RENTAL_SERIES_INDEX)
//        {
//            datapoint.xValue = @"RMP";
//            datapoint.yValue = @5678;
//        }
//        else if(dataIndex == HOME_SERIES_INDEX)
//        {
//            datapoint.xValue = @"HMP";
//            datapoint.yValue = @5678;
//        }
//    }
//    return datapoint;

}

/*#pragma mark - SChartDatasource methods


-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartColumnSeries *lineSeries = [[SChartColumnSeries alloc] init];
    lineSeries.title = index == 0 ? @"Rental" : @"Home";
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return NUMBER_OF_DATAPOINTS;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartRadialDataPoint *datapoint = [[SChartRadialDataPoint alloc] init];

    if(seriesIndex == RENTAL_SERIES_INDEX)
    {
        if(dataIndex == LIFESTYLE_DATAPOINT_INDEX)
        {
            datapoint.name = @"RL";
            datapoint.value = [NSNumber numberWithInt:1234];
        }
        else if(dataIndex == MONTHLY_PAYMENT_DATAPOINT_INDEX)
        {
            datapoint.name = @"RMP";
            datapoint.value = [NSNumber numberWithInt:5678];
        }
    }
    else if(seriesIndex == HOME_SERIES_INDEX)
    {
        if(dataIndex == LIFESTYLE_DATAPOINT_INDEX)
        {
            datapoint.name = @"HL";
            datapoint.value = [NSNumber numberWithInt:4321];
        }
        else if(dataIndex == MONTHLY_PAYMENT_DATAPOINT_INDEX)
        {
            datapoint.name = @"HMP";
            datapoint.value = [NSNumber numberWithInt:8765];
        }
    }
    return datapoint;
}

#pragma end*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
