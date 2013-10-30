//
//  OneHomeTaxSavingsViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeTaxSavingsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface HomeTaxSavingsViewController() <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mEstTaxesChart;
@end

@implementation HomeTaxSavingsViewController
{
    NSDictionary* mTaxesData[2];
}

-(void) setupChart
{
    self.mEstTaxesChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mEstTaxesChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mEstTaxesChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mEstTaxesChart.xAxis = xAxis;
    self.mEstTaxesChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @5.0;
    self.mEstTaxesChart.yAxis = yAxis;
    self.mEstTaxesChart.legend.hidden = NO;
    self.mEstTaxesChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mEstTaxesChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mEstTaxesChart.legend.style.symbolCornerRadius = @0;
    self.mEstTaxesChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mEstTaxesChart.legend.style.cornerRadius = @0;
    self.mEstTaxesChart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mEstTaxesChart];
    
    self.mEstTaxesChart.datasource = self;
    self.mEstTaxesChart.delegate = self;
    // show the legend
    
    mTaxesData[0] = @{@"Est. Taxes" : @1234};
    mTaxesData[1] = @{@"Est. Taxes" : @3456};

}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomeTaxSavingsDelegate setNavTitle:@"Est. Tax Savings"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    lineSeries.style.showAreaWithGradient = YES;
    if(index == 0) {
        lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.95];
    }
    else if(index == 1) {
        lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:0.95];
    }
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 1;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = mTaxesData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = mTaxesData[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
