//
//  TwoHomeTaxSavingsViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomeTaxSavingsViewController.h"
#import "kCATCalculator.h"
#import "ShinobiChart+Screenshot.h"


@interface TwoHomeTaxSavingsViewController () <SChartDatasource, SChartDelegate>
@end

@implementation TwoHomeTaxSavingsViewController
{
    NSDictionary* homeTaxSavings[3];
    NSDictionary* oldFont;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:oldFont];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeTaxSavingsDelegate setNavTitle:@"Annual Income Tax Savings"];
    oldFont = self.navigationController.navigationBar.titleTextAttributes;
    
    UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
}

-(void) setupOtherLabels
{
}

-(void) setupChart
{
    // create the data
    
    if (IS_WIDESCREEN)
    {
        self.mTaxSavingsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(20, 185, 280, 180)];
    }
    else
    {
        self.mTaxSavingsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(20, 220, 280, 140)];
    }
    
    //self.mTaxSavingsChart.loadDataInBackground = YES;
    self.mTaxSavingsChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mTaxSavingsChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mTaxSavingsChart.xAxis = xAxis;
    self.mTaxSavingsChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @3000.0;
    self.mTaxSavingsChart.yAxis = yAxis;
    self.mTaxSavingsChart.legend.hidden = NO;
    self.mTaxSavingsChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mTaxSavingsChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mTaxSavingsChart.legend.style.symbolCornerRadius = @0;
    self.mTaxSavingsChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mTaxSavingsChart.legend.style.cornerRadius = @0;
    self.mTaxSavingsChart.legend.position = SChartLegendPositionMiddleRight;
    self.mTaxSavingsChart.plotAreaBackgroundColor = [UIColor clearColor];
    self.mTaxSavingsChart.gesturePanType = SChartGesturePanTypeNone;
    
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
        
        float home1Taxes = rintf(([home1Calc getAnnualFederalTaxesPaid]+
                            [home1Calc getAnnualStateTaxesPaid]));
        
        float home2Taxes = rintf(([home2Calc getAnnualFederalTaxesPaid]+
                            [home2Calc getAnnualStateTaxesPaid]));
        
        float rentalTaxes = rintf(([rentalCalc getAnnualFederalTaxesPaid]+
                            [rentalCalc getAnnualStateTaxesPaid]));
        
        homeTaxSavings[0] = @{@"Est. Income Tax ($)" : [NSNumber numberWithInteger:rentalTaxes]};
        homeTaxSavings[1] = @{@"Est. Income Tax ($)" : [NSNumber numberWithInteger:home1Taxes]};
        homeTaxSavings[2] = @{@"Est. Income Tax ($)" : [NSNumber numberWithInteger:home2Taxes]};
        
        float home1TaxSavings = rentalTaxes - home1Taxes;
        float home2TaxSavings = rentalTaxes - home2Taxes;

        self.mEstRentalUnitTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:rentalTaxes]];
        self.mEstFirstHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:home1Taxes]];
        self.mEstSecondHomeTaxes.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:home2Taxes]];
        
        if (home1TaxSavings < 0)
        {
            [self.mHome1TaxSavings setTextColor:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0]];
        }
        else
        {
            [self.mHome1TaxSavings setTextColor:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];
        }
        
        if (home2TaxSavings < 0)
        {
            [self.mHome2TaxSavings setTextColor:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0]];
        }
        else
        {
            [self.mHome2TaxSavings setTextColor:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];
        }
            
        self.mHome1TaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:home1TaxSavings]];
        self.mHome2TaxSavings.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:home2TaxSavings]];
        
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
    
    if (!IS_WIDESCREEN)
    {
        self.mHome2TaxCompareView.frame = CGRectMake(0, 290, self.mHome2TaxCompareView.frame.size.width, self.mHome2TaxCompareView.frame.size.height);
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
        lineSeries.style.areaColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:0.95];
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
