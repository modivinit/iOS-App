//
//  TwoHomeRentVsBuyViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomeLifestyleIncomeViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"


@interface TwoHomeLifestyleIncomeViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mLifestyleIncomeChart;
@end

@implementation TwoHomeLifestyleIncomeViewController
{
    NSDictionary* mLifestyleIncomeData[3];
}

-(void) setupChart
{    
    if (IS_WIDESCREEN)
    {
        self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(20, 185, 280, 180)];
    }
    else
    {
        self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(20, 220, 280, 140)];
    }
    
    self.mLifestyleIncomeChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mLifestyleIncomeChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mLifestyleIncomeChart.xAxis = xAxis;
    self.mLifestyleIncomeChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @1000.0;
    self.mLifestyleIncomeChart.yAxis = yAxis;
    self.mLifestyleIncomeChart.legend.hidden = NO;
    self.mLifestyleIncomeChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mLifestyleIncomeChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mLifestyleIncomeChart.legend.style.symbolCornerRadius = @0;
    self.mLifestyleIncomeChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mLifestyleIncomeChart.legend.style.cornerRadius = @0;
    self.mLifestyleIncomeChart.legend.position = SChartLegendPositionMiddleRight;
    self.mLifestyleIncomeChart.plotAreaBackgroundColor = [UIColor clearColor];
    self.mLifestyleIncomeChart.gesturePanType = SChartGesturePanTypeNone;
    
    // add to the view
    [self.view addSubview:self.mLifestyleIncomeChart];
    
    self.mLifestyleIncomeChart.datasource = self;
    self.mLifestyleIncomeChart.delegate = self;
    // show the legend
    
    self.mLifestyleIncomeChart.clipsToBounds = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomeLifestyleDelegate setNavTitle:@"Monthly Cash Flow"];
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
        NSLog(@"Invalid status to be in Dash 2 home lifestyle %d",
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
        

        float homeLifestyle1 = rintf([home1Calc getMonthlyLifeStyleIncome]);
        float homeLifestyle2 = rintf([home2Calc getMonthlyLifeStyleIncome]);
        float rentLifestyle  = rintf([rentalCalc getMonthlyLifeStyleIncome]);
        
        float mHome1CashFlow = homeLifestyle1;
        float mHome2CashFlow = homeLifestyle2;
        
        if (mHome1CashFlow < 0)
        {
            [self.mHome1CashFlow setTextColor:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0]];
        }
        else
        {
            [self.mHome1CashFlow setTextColor:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];
        }
        
        if (mHome2CashFlow < 0)
        {
            [self.mHome2CashFlow setTextColor:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0]];
        }
        else
        {
            [self.mHome2CashFlow setTextColor:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];
        }
        
        self.mHome1CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:mHome1CashFlow]];
        self.mHome2CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:mHome2CashFlow]];
        
        mLifestyleIncomeData[0] = @{@"Monthly Cash Flow ($)" : [NSNumber numberWithInteger:rentLifestyle]};
        mLifestyleIncomeData[1] = @{@"Monthly Cash Flow ($)" : [NSNumber numberWithFloat:homeLifestyle1]};
        mLifestyleIncomeData[2] = @{@"Monthly Cash Flow ($)" : [NSNumber numberWithFloat:homeLifestyle2]};

        self.mRentalLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                            [NSNumber numberWithFloat:rentLifestyle]];
        self.mHome1LifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                           [NSNumber numberWithFloat:homeLifestyle1]];
        self.mHome2LifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                           [NSNumber numberWithFloat:homeLifestyle2]];
        
        self.mHome1Nickname.text = home1.mIdentifiyingHomeFeature;
        if(home1.mHomeType == homeTypeSingleFamily)
            self.mHome1TypeIcon.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        else
            self.mHome1TypeIcon.image = [UIImage imageNamed:@"menu-home-condo.png"];
        
        self.mHome2Nickname.text = home2.mIdentifiyingHomeFeature;
        if(home2.mHomeType == homeTypeSingleFamily)
            self.mHome2TypeIcon.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        else
            self.mHome2TypeIcon.image = [UIImage imageNamed:@"menu-home-condo.png"];
        
    }
    
    if (!IS_WIDESCREEN)
    {
        self.mHome2CashView.frame = CGRectMake(0, 290, self.mHome2CashView.frame.size.width, self.mHome2CashView.frame.size.height);
    }
    
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
    lineSeries.style.showAreaWithGradient = YES;
    lineSeries.animationEnabled = YES;
    if(index == 0) {
        lineSeries.title = @"Rental";
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.8];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.9];
    }
    if(index == 1) {
        lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:0.95];
    }
    if(index == 2) {
        lineSeries.title = @"Home 2";
        lineSeries.style.areaColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:0.8];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:0.9];
    }
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 1;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = mLifestyleIncomeData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = mLifestyleIncomeData[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
