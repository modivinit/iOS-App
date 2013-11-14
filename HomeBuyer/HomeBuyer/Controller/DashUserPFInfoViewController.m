//
//  DashUserPFInfoViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/29/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "DashUserPFInfoViewController.h"
#import "HelpDashboardViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "AboutYouViewController.h"
#import "kCATCalculator.h"

@interface DashUserPFInfoViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mHomeLifeStyleChart;
@end

@implementation DashUserPFInfoViewController
{
    NSDictionary* homePayments;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mWasLoadedFromMenu = NO;
    }
    return self;
}

-(void) setupChart
{
        self.mHomeLifeStyleChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(5, 110, 310, 220)];
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
        self.mHomeLifeStyleChart.plotAreaBackgroundColor = [UIColor clearColor];
    
        [self.view addSubview:self.mHomeLifeStyleChart];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* titleText = [NSString stringWithFormat:@"Current Cash Flow"];
    self.navigationController.navigationBar.topItem.title = titleText;
    // Do any additional setup after loading the view from its nib.
    userProfileInfo* user = [kunanceUser getInstance].mkunanceUserProfileInfo;
    
    kunanceUserProfileStatus status = [kunanceUser getInstance].mUserProfileStatus;
    if(!user || status == ProfileStatusUndefined)
    {
        NSLog(@"Error: No user profile found in User Profile Dash");
        return;
    }
    
    // create the data
    UserProfileObject* userCalculatorObject = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    kCATCalculator* calculator = [[kCATCalculator alloc] initWithUserProfile:userCalculatorObject andHome:nil];
    float monthlylifestyle = rintf([calculator getMonthlyLifeStyleIncome]);
   
    float estimatedIncomeTax = [calculator getAnnualFederalTaxesPaid] + [calculator getAnnualStateTaxesPaid];
    estimatedIncomeTax = rintf(estimatedIncomeTax/NUMBER_OF_MONTHS_IN_YEAR);
    
    if(monthlylifestyle < 0)
    {
        self.mLifestyleIncomeLabel.textColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:30.0/255.0 alpha:1.0];
    }
    else
    {
        self.mLifestyleIncomeLabel.textColor = [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0];
    }
    
    self.mLifestyleIncomeLabel.text = [Utilities getCurrencyFormattedStringForNumber:
                                       [NSNumber numberWithFloat:monthlylifestyle]];
    
    self.mRentLabel.text = [Utilities getCurrencyFormattedStringForNumber:
                             [NSNumber numberWithFloat:[user getMonthlyRentInfo]]];
    
    float totalFixedCosts = [user getOtherFixedCostsInfo] + [user getCarPaymentsInfo] + [user getHealthInsuranceInfo];
    
    self.mFixedCosts.text = [Utilities getCurrencyFormattedStringForNumber:
                             [NSNumber numberWithFloat:totalFixedCosts]];
    
    self.mEstimatedIncomeTaxesLabel.text = [Utilities getCurrencyFormattedStringForNumber:
                                            [NSNumber numberWithFloat:estimatedIncomeTax]];
    
    homePayments = @{@"Cash Flow" : [NSNumber numberWithFloat:monthlylifestyle],
                     @"Fixed Costs" : [NSNumber numberWithInt:totalFixedCosts],
                     @"Rent" : [NSNumber numberWithInt:[user getMonthlyRentInfo]],
                     @"Est. Income Tax": [NSNumber numberWithFloat:estimatedIncomeTax]};

    [self setupChart];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self
                                                  action:@selector(editUserProfile)];

    if([kunanceUser getInstance].mkunanceUserProfileInfo && self.mWasLoadedFromMenu)
    {
        self.mWasLoadedFromMenu = NO;
        self.mDashboardButton.hidden = NO;
    }
    else
    {
        self.mDashboardButton.hidden = YES;
    }
    
    if(([kunanceUser getInstance].mUserProfileStatus == ProfileStatusPersonalFinanceAndFixedCostsInfoEntered) || ([kunanceUser getInstance].mUserProfileStatus == ProfileStatusUser1HomeInfoEntered))
    {
        self.mAddAHomeButton.hidden = NO;
    }
    else
    {
        self.mAddAHomeButton.hidden = YES;
    }
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Viewed Rental Cash Flow Dashboard" properties:Nil];
}

-(IBAction)dasboardButtonTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayMainDashNotification object:nil];
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
    pieSeries.style.chartEffect = SChartRadialChartEffectBevelledLight;
    pieSeries.selectedStyle.protrusion = 10.0f;
    pieSeries.style.labelFont = [UIFont fontWithName:@"Helvetica Neue" size:10];
    pieSeries.style.labelFontColor = [UIColor whiteColor];
    pieSeries.labelFormatString = @"%.0f";
    pieSeries.animationEnabled = YES;
    NSMutableArray* colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0.0/255.0 alpha:0.9]];
    [colors addObject:[UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.9]];
    [colors addObject:[UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:0.9]];
    [colors addObject:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:0.9]];
    pieSeries.style.flavourColors = colors;
    pieSeries.selectedStyle.flavourColors = colors;
    return pieSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return homePayments.allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartRadialDataPoint *datapoint = [[SChartRadialDataPoint alloc] init];
    NSString* key = homePayments.allKeys[dataIndex];
    datapoint.name = key;
    NSNumber* value =  homePayments[key];
    if([value compare:@0] == NSOrderedAscending)
    {
        datapoint.value = @0;
        return datapoint;
    }
    else
    {
        datapoint.value = homePayments[key];
        return datapoint;
    }
}


#pragma mark actions, gestures

-(void) editUserProfile
{
    AboutYouViewController* viewController = [[AboutYouViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)helpButtonTapped:(id)sender
{
    HelpDashboardViewController* dashHelp = [[HelpDashboardViewController alloc] init];
    [self.navigationController pushViewController:dashHelp animated:NO];
}

-(IBAction)addHomeIcon:(id)sender
{
    [self showHomeInfo];
}

-(IBAction)addHomeInfo:(id)sender
{
    [self showHomeInfo];
}

-(void) showHomeInfo
{
    self.mHomeInfoViewController = [[HomeInfoEntryViewController alloc] initAsHomeNumber:FIRST_HOME];
    [self.navigationController pushViewController:self.mHomeInfoViewController animated:NO];
}
#pragma end

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
