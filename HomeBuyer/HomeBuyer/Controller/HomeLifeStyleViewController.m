//
//  OneHomeLifeStyleViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "HomeLifeStyleViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface HomeLifeStyleViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mHomeLifeStyleChart;
@end

@implementation HomeLifeStyleViewController
{
    NSDictionary* homePayments;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mHomeLifeStyleDelegate setNavTitle:@"Home Lifestyle"];
}

-(void) setupOtherLabels
{
    homeInfo* home = [[kunanceUser getInstance].mKunanceUserHomes
                      getHomeAtIndex:[self.mHomeNumber intValue]];
    
    if(home)
    {
        if(home.mHomeType == homeTypeCondominium)
        {
            self.mCondoSFHIndicator.image = [UIImage imageNamed:@"menu-home-condo.png"];
        }
        else if(home.mHomeType == homeTypeSingleFamily)
        {
            self.mCondoSFHIndicator.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        }
        
        self.mCondoSFHLabel.text = home.mIdentifiyingHomeFeature;
        self.mHomeListPrice.text = [NSString stringWithFormat:@"%llu", home.mHomeListPrice];
    }
}

-(void) setupChart
{
    homeInfo* aHome = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:[self.mHomeNumber intValue]];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];
        kCATCalculator* calculatorHome = [[kCATCalculator alloc] initWithUserProfile:userProfile andHome:homeAndLoan];

        float lifestyleIncome = [calculatorHome getMonthlyLifeStyleIncome];
        float homeEstTaxesPaid = ceilf(([calculatorHome getAnnualFederalTaxesPaid] +
                                        [calculatorHome getAnnualStateTaxesPaid])/12);
        
        self.mHomeLifeStyleIncome.text = [NSString stringWithFormat:@"$%.0f", lifestyleIncome];
        self.mFixedCosts.text = [NSString stringWithFormat:@"$%d", userProfile.mMonthlyOtherFixedCosts];
        self.mEstIncomeTaxes.text = [NSString stringWithFormat:@"$%.0f", homeEstTaxesPaid];
        // create the data
        homePayments = @{@"LifeStyle Income" : [NSNumber numberWithFloat:lifestyleIncome],
                         @"Fixed Costs" : [NSNumber numberWithInt:userProfile.mMonthlyOtherFixedCosts],
                         @"Est. Income Tax" : [NSNumber numberWithFloat:homeEstTaxesPaid]};
        
        self.mHomeLifeStyleChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(5, 60, 310, 220)];
        self.mHomeLifeStyleChart.autoresizingMask =  ~UIViewAutoresizingNone;
        self.mHomeLifeStyleChart.licenseKey = SHINOBI_LICENSE_KEY;
        
        // this view controller acts as the datasource
        self.mHomeLifeStyleChart.datasource = self;
        self.mHomeLifeStyleChart.delegate = self;
        self.mHomeLifeStyleChart.legend.hidden = NO;
        self.mHomeLifeStyleChart.backgroundColor = [UIColor clearColor];
        self.mHomeLifeStyleChart.legend.backgroundColor = [UIColor clearColor];
        self.mHomeLifeStyleChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
        self.mHomeLifeStyleChart.legend.style.symbolCornerRadius = @0;
        self.mHomeLifeStyleChart.legend.style.borderColor = [UIColor darkGrayColor];
        self.mHomeLifeStyleChart.legend.style.cornerRadius = @0;
        self.mHomeLifeStyleChart.legend.position = SChartLegendPositionMiddleRight;
        self.mHomeLifeStyleChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
        
        [self.view addSubview:self.mHomeLifeStyleChart];
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
