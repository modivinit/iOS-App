//
//  TwoHomeRentVsBuyViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomeLifestyleIncomeViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface TwoHomeLifestyleIncomeViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mLifestyleIncomeChart;
@end

@implementation TwoHomeLifestyleIncomeViewController
{
    NSDictionary* mLifestyleIncomeData[3];
}

-(void) setupChart
{
    self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mLifestyleIncomeChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mLifestyleIncomeChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mLifestyleIncomeChart.xAxis = xAxis;
    self.mLifestyleIncomeChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @5.0;
    self.mLifestyleIncomeChart.yAxis = yAxis;
    self.mLifestyleIncomeChart.legend.hidden = NO;
    self.mLifestyleIncomeChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mLifestyleIncomeChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mLifestyleIncomeChart.legend.style.symbolCornerRadius = @0;
    self.mLifestyleIncomeChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mLifestyleIncomeChart.legend.style.cornerRadius = @0;
    self.mLifestyleIncomeChart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mLifestyleIncomeChart];
    
    self.mLifestyleIncomeChart.datasource = self;
    self.mLifestyleIncomeChart.delegate = self;
    // show the legend
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeLifestyleDelegate setNavTitle:@"Compare Lifestyle"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mLifestyleIncomeData[0] = @{@"Lifestyle Income" : @1234};
    mLifestyleIncomeData[1] = @{@"Lifestyle Income" : @5678};
    mLifestyleIncomeData[2] = @{@"Lifestyle Income" : @3453};
    
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
    NSString* key = mLifestyleIncomeData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = mLifestyleIncomeData[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
