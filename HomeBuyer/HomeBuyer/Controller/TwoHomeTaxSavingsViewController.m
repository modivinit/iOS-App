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
@property (nonatomic, strong) ShinobiChart* mTaxSavingsChart;
@end

@implementation TwoHomeTaxSavingsViewController
{
    NSDictionary* homeTaxSavings[3];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeTaxSavingsDelegate setNavTitle:@"Est. Tax Savings"];
}

-(void) setupOtherLabels
{
 
}

-(void) setupChart
{
    // create the data
    homeTaxSavings[0] = @{@"Tax Savings" : @1234};
    homeTaxSavings[1] = @{@"Tax Savings" : @5678};
    homeTaxSavings[2] = @{@"Tax Savings" : @3453};

    self.mTaxSavingsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mTaxSavingsChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mTaxSavingsChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mTaxSavingsChart.xAxis = xAxis;
    self.mTaxSavingsChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @5.0;
    self.mTaxSavingsChart.yAxis = yAxis;
    self.mTaxSavingsChart.legend.hidden = NO;
    self.mTaxSavingsChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mTaxSavingsChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mTaxSavingsChart.legend.style.symbolCornerRadius = @0;
    self.mTaxSavingsChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mTaxSavingsChart.legend.style.cornerRadius = @0;
    self.mTaxSavingsChart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mTaxSavingsChart];
    
    self.mTaxSavingsChart.datasource = self;
    self.mTaxSavingsChart.delegate = self;
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
    NSString* key = homeTaxSavings[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = homeTaxSavings[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
