//
//  OneHomePaymentsViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomePaymentsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface HomePaymentsViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mHomePaymentsChart;
@end

@implementation HomePaymentsViewController
{
    NSDictionary* homePayments;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomePaymentsDelegate setNavTitle:@"Home Payments"];
}

-(void) setupOtherLabels
{
    homeInfo* home = [[kunanceUser getInstance].mKunanceUserHomes
                      getHomeAtIndex:[self.mHomeNumber intValue]];

    if(home)
    {
        self.mHOA.text = [NSString stringWithFormat:@"%d", home.mHOAFees];
        
        self.mHomeTitle.text = home.mIdentifiyingHomeFeature;
        
        if(home.mHomeType == homeTypeCondominium)
        {
            self.mCondoSFHIndicator.image = [UIImage imageNamed:@"menu-home-condo.png"];
            self.mCondoSFHLabel.text = @"Condo/Townhome";
        }
        else if(home.mHomeType == homeTypeSingleFamily)
        {
            self.mCondoSFHIndicator.image = [UIImage imageNamed:@"menu-home-sfh.png"];
            self.mCondoSFHLabel.text = @"Single Family";
        }
        
        self.mHomeListPrice.text = [NSString stringWithFormat:@"%llu", home.mHomeListPrice];
    }
}

-(void) setupChart
{
    homeInfo* home = [[kunanceUser getInstance].mKunanceUserHomes
                      getHomeAtIndex:[self.mHomeNumber intValue]];

    if(home)
    {
        // create the data
        homePayments = @{@"Mortgage" : @1800,
                         @"HOA" : [NSNumber numberWithInt:home.mHOAFees],
                         @"Property Tax" : @600,
                         @"Insurance" : @150};

        self.mHomePaymentsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(5, 60, 310, 220)];
        self.mHomePaymentsChart.autoresizingMask =  ~UIViewAutoresizingNone;
        self.mHomePaymentsChart.licenseKey = SHINOBI_LICENSE_KEY;
        
        // this view controller acts as the datasource
        self.mHomePaymentsChart.datasource = self;
        self.mHomePaymentsChart.delegate = self;
        self.mHomePaymentsChart.legend.hidden = NO;
        self.mHomePaymentsChart.backgroundColor = [UIColor clearColor];
        self.mHomePaymentsChart.legend.backgroundColor = [UIColor clearColor];
        self.mHomePaymentsChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
        self.mHomePaymentsChart.legend.style.symbolCornerRadius = @0;
        self.mHomePaymentsChart.legend.style.borderColor = [UIColor darkGrayColor];
        self.mHomePaymentsChart.legend.style.cornerRadius = @0;
        self.mHomePaymentsChart.legend.position = SChartLegendPositionMiddleRight;
        self.mHomePaymentsChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
        
        [self.view addSubview:self.mHomePaymentsChart];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupChart];
    [self setupOtherLabels];
}

#pragma mark - SChartDelegate methods

- (void)sChart:(ShinobiChart *)chart
toggledSelectionForRadialPoint:(SChartRadialDataPoint *)dataPoint
      inSeries:(SChartRadialSeries *)series
atPixelCoordinate:(CGPoint)pixelPoint
{
    NSLog(@"Selected country: %@", dataPoint.name);
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartPieSeries* pieSeries = [[SChartPieSeries alloc] init];
    pieSeries.selectedStyle.protrusion = 10.0f;
    pieSeries.style.labelFont = [UIFont fontWithName:@"Helvetica Neue" size:10];
    pieSeries.style.labelFontColor = [UIColor whiteColor];
    pieSeries.selectionAnimation.duration = @0.4;
    pieSeries.selectedPosition = @0.0;
    return pieSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return homePayments.allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartRadialDataPoint *datapoint = [[SChartRadialDataPoint alloc] init];
    NSString* key = homePayments.allKeys[dataIndex];
    datapoint.name = key;
    datapoint.value = homePayments[key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
