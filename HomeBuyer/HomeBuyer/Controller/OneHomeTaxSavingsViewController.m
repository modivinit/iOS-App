//
//  OneHomeTaxSavingsViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "OneHomeTaxSavingsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface OneHomeTaxSavingsViewController() <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mEstTaxesChart;
@end

@implementation OneHomeTaxSavingsViewController
{
    NSDictionary* mTaxesData[2];
}

-(void) setupChart
{
    self.mEstTaxesChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 140, 300, 160)];
    
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
    
    self.mEstTaxesChart.clipsToBounds = NO;
    
    // add to the view
    [self.view addSubview:self.mEstTaxesChart];
    
    self.mEstTaxesChart.datasource = self;
    self.mEstTaxesChart.delegate = self;
    // show the legend
    homeInfo* aHome = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 1 home taxes %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];
        kCATCalculator* calculatorRent = [[kCATCalculator alloc] initWithUserProfile:userProfile andHome:nil];
        kCATCalculator* calculatorHome = [[kCATCalculator alloc] initWithUserProfile:userProfile andHome:homeAndLoan];
        
        float homeEstTaxesPaid = [calculatorHome getAnnualFederalTaxesPaid] + [calculatorHome getAnnualStateTaxesPaid];
   //     homeEstTaxesPaid = homeEstTaxesPaid/NUMBER_OF_MONTHS_IN_YEAR;
        
        float rentEstTaxesPaid = [calculatorRent getAnnualFederalTaxesPaid] + [calculatorRent getAnnualStateTaxesPaid];
   //     rentEstTaxesPaid = rentEstTaxesPaid/NUMBER_OF_MONTHS_IN_YEAR;
        
        mTaxesData[0] = @{@"Est. Income Tax" :[NSNumber numberWithFloat:rentEstTaxesPaid]};
        mTaxesData[1] = @{@"Est. Income Tax" : [NSNumber numberWithFloat:homeEstTaxesPaid]};
        
        self.mEstTaxPaidWithRental.text = [Utilities getCurrencyFormattedStringForNumber:
                                           [NSNumber numberWithLong:rentEstTaxesPaid]];
        self.mEstTaxesPaidWithHome.text = [Utilities getCurrencyFormattedStringForNumber:
                                           [NSNumber numberWithLong:homeEstTaxesPaid]];
        
        self.mEstTaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:
                                    [NSNumber numberWithLong:rentEstTaxesPaid-homeEstTaxesPaid]];
        
        self.mHomeNickName.text = aHome.mIdentifiyingHomeFeature;
        if(aHome.mHomeType == homeTypeSingleFamily)
            self.mHomeTypeIcon.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        else
            self.mHomeTypeIcon.image = [UIImage imageNamed:@"menu-home-condo.png"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mOneHomeTaxSavingsDelegate setNavTitle:@"Annual Income Tax Savings"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupChart];
}

-(IBAction)addAHomeTapped:(id)sender
{
    uint currentCount = [[kunanceUser getInstance].mKunanceUserHomes getCurrentHomesCount];
    self.mHomeInfoViewController = [[HomeInfoEntryViewController alloc] initAsHomeNumber:currentCount];
    [self.navigationController pushViewController:self.mHomeInfoViewController animated:NO];
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
    lineSeries.animationEnabled = YES;
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
