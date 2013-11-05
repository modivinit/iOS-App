//
//  TwoHomeTaxSavingsViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomeTaxSavingsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface TwoHomeTaxSavingsViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mTaxSavingsChart;
@end

@implementation TwoHomeTaxSavingsViewController
{
    NSDictionary* homeTaxSavings[3];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeTaxSavingsDelegate setNavTitle:@"Income Tax Savings"];
}

-(void) setupOtherLabels
{
 
}

-(void) setupChart
{
    // create the data
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
    homeInfo* home1 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    homeInfo* home2 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:SECOND_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 2 home taxes %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(home1 && home2 && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan1 = [kunanceUser getCalculatorHomeAndLoanFrom:home1 andLoan:aLoan];
        homeAndLoanInfo* homeAndLoan2 = [kunanceUser getCalculatorHomeAndLoanFrom:home2 andLoan:aLoan];
        
        kCATCalculator* home1Calc = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                        andHome:homeAndLoan1];
        
        kCATCalculator* home2Calc = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                        andHome:homeAndLoan2];
        
        kCATCalculator* rentalCalc = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                         andHome:nil];
        
        float home1Taxes = ([home1Calc getAnnualFederalTaxesPaid]+
                            [home1Calc getAnnualFederalTaxesPaid])/NUMBER_OF_MONTHS_IN_YEAR;
        
        float home2Taxes = ([home2Calc getAnnualFederalTaxesPaid]+
                            [home2Calc getAnnualFederalTaxesPaid])/NUMBER_OF_MONTHS_IN_YEAR;
        
        float rentalTaxes = ([rentalCalc getAnnualFederalTaxesPaid]+
                            [rentalCalc getAnnualFederalTaxesPaid])/NUMBER_OF_MONTHS_IN_YEAR;
        
        homeTaxSavings[0] = @{@"Tax Savings" : [NSNumber numberWithInteger:home1Taxes]};
        homeTaxSavings[1] = @{@"Tax Savings" : [NSNumber numberWithInteger:home2Taxes]};
        homeTaxSavings[2] = @{@"Tax Savings" : [NSNumber numberWithInteger:rentalTaxes]};

        self.mEstRentalUnitTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:rentalTaxes]];
        self.mEstFirstHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:home1Taxes]];
        self.mEstSecondHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:home2Taxes]];
        
        self.mHome1Nickname.text = home1.mIdentifiyingHomeFeature;
        if(home1.mHomeType == homeTypeSingleFamily)
            self.mFirstHomeType.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        else
            self.mFirstHomeType.image = [UIImage imageNamed:@"menu-home-condo.png"];
        
        self.mHome2Nickname.text = home2.mIdentifiyingHomeFeature;
        if(home2.mHomeType == homeTypeSingleFamily)
            self.mSecondHomeType.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        else
            self.mSecondHomeType.image = [UIImage imageNamed:@"menu-home-condo.png"];
        
    }

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
    lineSeries.style.showAreaWithGradient = YES;
    lineSeries.animationEnabled = YES;
    if(index == 0) {
        lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.95];
    }
    if(index == 1) {
        lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:0.95];
    }
    if(index == 2) {
        lineSeries.title = @"Home 2";
        lineSeries.style.areaColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:0.95];
    }
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
