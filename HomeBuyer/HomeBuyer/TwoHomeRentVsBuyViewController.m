//
//  TwoHomeRentVsBuyViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomeRentVsBuyViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface TwoHomeRentVsBuyViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mRentVsBuyBarChart;
@end

@implementation TwoHomeRentVsBuyViewController
{
    NSDictionary* mRentVsBuyData[3];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeRentVsBuyDelegate setNavTitle:@"Rent Vs Buy"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mRentVsBuyData[0] = @{@"Lifestyle" : @1234};
    mRentVsBuyData[1] = @{@"Lifestyle" : @5678};
    mRentVsBuyData[2] = @{@"Lifestyle" : @3453};
    
    [self setupChart];
}

- (void)sChart:(ShinobiChart *)chart alterTickMark:(SChartTickMark *)tickMark beforeAddingToAxis:(SChartAxis *)axis
{
    
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 3;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartColumnSeries *lineSeries = [[SChartColumnSeries alloc] init];
    lineSeries.style.lineColor = [UIColor darkGrayColor];
    lineSeries.style.showArea = YES;
    //    lineSeries.style.showAreaWithGradient = YES;
    //    lineSeries.style.areaColorGradient = [UIColor whiteColor];
    if(index == 0)
        lineSeries.title = @"Rental";
    if(index == 1)
        lineSeries.title = @"Home 1";
    if(index == 2)
        lineSeries.title = @"Home 2";
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 1;
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
