//
//  Dash2HomesEnteredViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/3/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "TwoHomePaymentViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"
#import "ShinobiChart+Screenshot.h"


@interface TwoHomePaymentViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mMontlyPaymentChart;
@end

@implementation TwoHomePaymentViewController
{
    NSDictionary* mMonthlyPaymentData[3];
}

-(void) setupChart
{
    self.mMontlyPaymentChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 202, 300, 160)];
    
    self.mMontlyPaymentChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mMontlyPaymentChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mMontlyPaymentChart.xAxis = xAxis;
    self.mMontlyPaymentChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @500.0;
    self.mMontlyPaymentChart.yAxis = yAxis;
    self.mMontlyPaymentChart.legend.hidden = NO;
    self.mMontlyPaymentChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mMontlyPaymentChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mMontlyPaymentChart.legend.style.symbolCornerRadius = @0;
    self.mMontlyPaymentChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mMontlyPaymentChart.legend.style.cornerRadius = @0;
    self.mMontlyPaymentChart.legend.position = SChartLegendPositionMiddleRight;
    self.mMontlyPaymentChart.plotAreaBackgroundColor = [UIColor clearColor];
    self.mMontlyPaymentChart.gesturePanType = SChartGesturePanTypeNone;
    
    // add to the view
    [self.view addSubview:self.mMontlyPaymentChart];
    
    self.mMontlyPaymentChart.datasource = self;
    self.mMontlyPaymentChart.delegate = self;
    // show the legend
    
    self.mMontlyPaymentChart.clipsToBounds = NO;
}

- (UIImage*)snapshotWithOpenGLViews
{
    return [self.mMontlyPaymentChart snapshot];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mTwoHomePaymentDelegate setNavTitle:@"Monthly Payments"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    homeInfo* home1 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    homeInfo* home2 = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:SECOND_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    userProfileInfo* userProfile = [kunanceUser getInstance].mkunanceUserProfileInfo;
    
    if(![[kunanceUser getInstance] hasUsableHomeAndLoanInfo])
    {
        NSLog(@"Invalid status to be in Dash 2 home payment %d",
              [kunanceUser getInstance].mUserProfileStatus);
        
        return;
    }
    
    if(home1 && home2 && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan1 = [kunanceUser getCalculatorHomeAndLoanFrom:home1 andLoan:aLoan];
        homeAndLoanInfo* homeAndLoan2 = [kunanceUser getCalculatorHomeAndLoanFrom:home2 andLoan:aLoan];
        
        float homeMortgage1 = rintf([homeAndLoan1 getTotalMonthlyPayment]);
        float homeMortgage2 = rintf([homeAndLoan2 getTotalMonthlyPayment]);
        
        float home1ComparePayment = homeMortgage1;
        float home2ComparePayment = homeMortgage2;
        
        uint rent = [userProfile getMonthlyRentInfo];
        
        mMonthlyPaymentData[0] =  @{@"Total Monthly Payment ($)" :
                                        [NSNumber numberWithInteger:rent]};
        mMonthlyPaymentData[1] =  @{@"Total Monthly Payment ($)" :
                                        [NSNumber numberWithFloat:homeMortgage1]};
        mMonthlyPaymentData[2] =  @{@"Total Monthly Payment ($)" :
                                        [NSNumber numberWithFloat:homeMortgage2]};

        self.mRentalPayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:rent]];
        self.mHome1Payment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:homeMortgage1]];
        self.mHome2Payment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:homeMortgage2]];
        
        self.mHome1ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:home1ComparePayment]];
        self.mHome2ComparePayment.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:home2ComparePayment]];
        
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
        lineSeries.style.areaColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:0.9];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1.0];
    }
    if(index == 1) {
        lineSeries.title = @"Home 1";
        lineSeries.style.areaColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.85];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:0.95];
    }
    if(index == 2) {
        lineSeries.title = @"Home 2";
        lineSeries.style.areaColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:0.9];
        lineSeries.style.areaColorGradient = [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
    }
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 1;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = mMonthlyPaymentData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = mMonthlyPaymentData[seriesIndex][key];
    return datapoint;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
