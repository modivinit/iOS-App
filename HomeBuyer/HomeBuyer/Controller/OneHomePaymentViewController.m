//
//  OneHomePaymentViewController.m
//  HomeBuyer
//
//  Created by Vinit Modi on 10/23/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "OneHomePaymentViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "kCATCalculator.h"

@interface OneHomePaymentViewController() <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mPaymentsChart;
@end

@implementation OneHomePaymentViewController
{
    NSDictionary* mPaymentData[2];
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
    self.mPaymentsChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(15, 100, 300, 160)];
    
    self.mPaymentsChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    self.mPaymentsChart.licenseKey = SHINOBI_LICENSE_KEY;
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    self.mPaymentsChart.xAxis = xAxis;
    self.mPaymentsChart.backgroundColor = [UIColor clearColor];
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.rangePaddingHigh = @5.0;
    self.mPaymentsChart.yAxis = yAxis;
    self.mPaymentsChart.legend.hidden = NO;
    self.mPaymentsChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    
    self.mPaymentsChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mPaymentsChart.legend.style.symbolCornerRadius = @0;
    self.mPaymentsChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mPaymentsChart.legend.style.cornerRadius = @0;
    self.mPaymentsChart.legend.position = SChartLegendPositionMiddleRight;
    
    // add to the view
    [self.view addSubview:self.mPaymentsChart];
    
    self.mPaymentsChart.datasource = self;
    self.mPaymentsChart.delegate = self;
    // show the legend
    
    homeInfo* aHome = [[kunanceUser getInstance].mKunanceUserHomes getHomeAtIndex:FIRST_HOME];
    loan* aLoan = [[kunanceUser getInstance].mKunanceUserLoans getLoanInfo];
    UserProfileObject* userProfile = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    if(aHome && aLoan && userProfile)
    {
        homeAndLoanInfo* homeAndLoan = [kunanceUser getCalculatorHomeAndLoanFrom:aHome andLoan:aLoan];

        float homeMortgage = ceilf([homeAndLoan getMonthlyLoanPaymentForHome]);
        mPaymentData[0] = @{@"Payment" : [NSNumber numberWithFloat:homeMortgage]};
        mPaymentData[1] = @{@"Payment" : [NSNumber numberWithFloat:userProfile.mMonthlyRent]};
        
        self.mHomePaymentLabel.text = [Utilities getCurrencyFormattedStringForNumber:[NSNumber numberWithLong:homeMortgage]];
        self.mRentalPaymentLabel.text = [Utilities getCurrencyFormattedStringForNumber:
                                         [NSNumber numberWithLong:userProfile.mMonthlyRent]];
        
        self.mHomeNickName.text = aHome.mIdentifiyingHomeFeature;
        if(aHome.mHomeType == homeTypeSingleFamily)
            self.mHomeTypeIcon.image = [UIImage imageNamed:@"menu-home-sfh.png"];
        else
            self.mHomeTypeIcon.image = [UIImage imageNamed:@"menu-home-condo.png"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.mOneHomePaymentViewDelegate setNavTitle:@"Compare Payments"];
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
    NSString* key = mPaymentData[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = mPaymentData[seriesIndex][key];
    return datapoint;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
