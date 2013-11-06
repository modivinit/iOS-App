//
//  kCATIntroTaxViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroTaxViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface kCATIntroTaxViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mTaxSavingsChart;

@end

@implementation kCATIntroTaxViewController
{
    NSDictionary* homeTaxSavings[2];
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
    // create the data
    self.mTaxSavingsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(31, 148, 280, 208)];
    
    self.mTaxSavingsChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mTaxSavingsChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mTaxSavingsChart.xAxis = xAxis;
    self.mTaxSavingsChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @10000.0;
    self.mTaxSavingsChart.yAxis = yAxis;
 //   yAxis.title = @"Dollars ($)";
    self.mTaxSavingsChart.legend.hidden = NO;
    self.mTaxSavingsChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
 //   self.mTaxSavingsChart.canvasAreaBackgroundColor = [UIColor clearColor];
    self.mTaxSavingsChart.plotAreaBackgroundColor = [UIColor clearColor];
    
    self.mTaxSavingsChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mTaxSavingsChart.legend.style.symbolCornerRadius = @0;
    self.mTaxSavingsChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mTaxSavingsChart.legend.style.cornerRadius = @0;
    self.mTaxSavingsChart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mTaxSavingsChart];
    
    self.mTaxSavingsChart.datasource = self;
    self.mTaxSavingsChart.delegate = self;
    
    self.mTaxSavingsChart.clipsToBounds = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView* backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"home-interior_03.jpg"];
    [self.view addSubview:backImage];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 250, 70)];
    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Compare income tax savings across homes before you buy.";
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:label];
    
    //chart related
    
    homeTaxSavings[0] = @{@"Income Tax Savings" : @30000};
    homeTaxSavings[1] = @{@"Income Tax Savings" : @45000};
    
    [self setupChart];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Looked at FTUE Screen 1 - Income Tax Savings" properties:Nil];
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

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartColumnSeries *lineSeries = [[SChartColumnSeries alloc] init];
    lineSeries.style.lineColor = [UIColor darkGrayColor];
    lineSeries.style.showArea = YES;
    lineSeries.style.showAreaWithGradient = YES;
    lineSeries.animationEnabled = YES;
    if(index == 0) {
        lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.95];
    }
    if(index == 1) {
        lineSeries.title = @"Home 2";
        lineSeries.style.areaColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:0.95];
    }
    return lineSeries;
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
