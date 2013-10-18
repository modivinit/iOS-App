//
//  TwoHomeTaxSavingsViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomeTaxSavingsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface TwoHomeTaxSavingsViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mTaxesPaidChart;
@end

@implementation TwoHomeTaxSavingsViewController
{
    NSDictionary* homeTaxPayments[3];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeTaxSavingsDelegate setNavTitle:@"Tax Savings"];
}

-(void) setupOtherLabels
{
 
}

-(void) setupChart
{
    // create the data
    homeTaxPayments[0] = @{@"Rental" : @1800};
    homeTaxPayments[1] = @{@"1st home" : @1400};
    homeTaxPayments[2] =  @{@"2nd home" : @1275};
    
    self.mTaxesPaidChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mTaxesPaidChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mTaxesPaidChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mTaxesPaidChart.xAxis = xAxis;
    self.mTaxesPaidChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @5.0;
    self.mTaxesPaidChart.yAxis = yAxis;
    self.mTaxesPaidChart.legend.hidden = NO;
    self.mTaxesPaidChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mTaxesPaidChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mTaxesPaidChart.legend.style.symbolCornerRadius = @0;
    self.mTaxesPaidChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mTaxesPaidChart.legend.style.cornerRadius = @0;
    self.mTaxesPaidChart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mTaxesPaidChart];
    
    self.mTaxesPaidChart.datasource = self;
    self.mTaxesPaidChart.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupChart];
    [self setupOtherLabels];
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
    NSString* key = homeTaxPayments[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = homeTaxPayments[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
