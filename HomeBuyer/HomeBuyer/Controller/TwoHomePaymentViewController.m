//
//  Dash2HomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/3/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomePaymentViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface TwoHomePaymentViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mMontlyPaymentChart;
@end

@implementation TwoHomePaymentViewController
{
    NSDictionary* mMonthlyPaymentData[3];
}

-(void) setupChart
{
    self.mMontlyPaymentChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mMontlyPaymentChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mMontlyPaymentChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mMontlyPaymentChart.xAxis = xAxis;
    self.mMontlyPaymentChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @5.0;
    self.mMontlyPaymentChart.yAxis = yAxis;
    self.mMontlyPaymentChart.legend.hidden = NO;
    self.mMontlyPaymentChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mMontlyPaymentChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mMontlyPaymentChart.legend.style.symbolCornerRadius = @0;
    self.mMontlyPaymentChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mMontlyPaymentChart.legend.style.cornerRadius = @0;
    self.mMontlyPaymentChart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mMontlyPaymentChart];
    
    self.mMontlyPaymentChart.datasource = self;
    self.mMontlyPaymentChart.delegate = self;
    // show the legend
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomePaymentDelegate setNavTitle:@"Compare Payments"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mMonthlyPaymentData[0] = @{@"Monthly Payment" : @1234};
    mMonthlyPaymentData[1] =  @{@"Monthly Payment" : @3456};
    mMonthlyPaymentData[2] =  @{@"Monthly Payment" : @3421};
    
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
    NSString* key = mMonthlyPaymentData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = mMonthlyPaymentData[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
