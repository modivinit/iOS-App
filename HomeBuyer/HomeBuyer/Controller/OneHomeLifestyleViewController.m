//
//  Dash1HomeEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/2/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#define NUMBER_OF_SERIES 2
#define NUMBER_OF_DATAPOINTS 2

#define RENTAL_SERIES_INDEX 0
#define HOME_SERIES_INDEX 1

#define LIFESTYLE_DATAPOINT_INDEX 0
#define MONTHLY_PAYMENT_DATAPOINT_INDEX 1

#import "OneHomeLifestyleViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"
#import "ShinobiChart+Screenshot.h"

@interface OneHomeLifestyleViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mLifestyleIncomeChart;
@end

@implementation OneHomeLifestyleViewController
{
    NSDictionary* mLifestyleIncomeData[2];
}

- (UIImage*)snapshotWithOpenGLViews
{
    return [self.mLifestyleIncomeChart snapshot];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mOneHomeLifestyleViewDelegate setNavTitle:@"Monthly Cash Flow"];
}

-(void) setupChart
{
    if (IS_WIDESCREEN)
    {
        self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(20, 202, 280, 160)];
    }
    else
    {
        self.mLifestyleIncomeChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(20, 235, 280, 140)];
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
    
    self.mLifestyleIncomeChart.clipsToBounds = NO;
    
    // add to the view
    [self.view addSubview:self.mLifestyleIncomeChart];
    
    self.mLifestyleIncomeChart.datasource = self;
    self.mLifestyleIncomeChart.delegate = self;
    // show the legend
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
    homeInfo* aHome = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
   
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 1 home lifestyle %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];
        kCATCalculator* calculatorRent = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                             andHome:nil];
        
        kCATCalculator* calculatorHome = [[kCATCalculator alloc] initWithUserProfile:userProfile
                                                                             andHome:homeAndLoan];
        
        float homeLifeStyleIncome = rintf([calculatorHome getMonthlyLifeStyleIncome]);
        float rentLifestyleIncome = rintf([calculatorRent getMonthlyLifeStyleIncome]);
        
        float mHome1CashFlow = homeLifeStyleIncome;
        
        if (mHome1CashFlow < 0)
        {
            [self.mHome1CashFlow setTextColor:[UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0]];
        }
        else
        {
            [self.mHome1CashFlow setTextColor:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];
        }

        self.mHome1CashFlow.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:mHome1CashFlow]];
        
        mLifestyleIncomeData[0] = @{@"Monthly Cash Flow ($)" : [NSNumber numberWithFloat:rentLifestyleIncome]};
        self.mRentalLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                            [NSNumber numberWithLong:rentLifestyleIncome]];
        
        mLifestyleIncomeData[1] = @{@"Monthly Cash Flow ($)" : [NSNumber numberWithFloat:homeLifeStyleIncome]};
        self.mHomeLifeStyleIncome.text = [Utilities getCurrencyFormattedStringForNumber:
                                          [NSNumber numberWithLong:homeLifeStyleIncome]];
        
        self.mHomeNickName.text = aHome.mIdentifiyingHomeFeature;
        if(aHome.mHomeType == homeTypeSingleFamily)
            self.mHomeTypeIcon.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        else
            self.mHomeTypeIcon.image = [UIImage imageNamed:@"menu-home-condo.png"];
            
    }
    
    if (!IS_WIDESCREEN)
    {
        self.mCompareView.frame = CGRectMake(0, 310, self.mCompareView.frame.size.width, self.mCompareView.frame.size.height);
    }
    
    [self setupChart];
}

#pragma mark actions, gesture etc
-(void) addAHome
{
}
#pragma end

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
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.8];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:0.9];
    }
    else if(index == 1) {
        lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:0.95];
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
