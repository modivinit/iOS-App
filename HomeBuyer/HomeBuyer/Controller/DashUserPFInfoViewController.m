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
        self.mHomeLifeStyleChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(5, 50, 310, 200)];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* titleText = [NSString stringWithFormat:@"Current Lifestyle Income"];
    self.navigationController.navigationBar.topItem.title = titleText;
    // Do any additional setup after loading the view from its nib.
    userProfileInfo* user = [kunanceUser getInstance].mkunanceUserProfileInfo;
    // create the data
    UserProfileObject* userCalculatorObject = [[kunanceUser getInstance].mkunanceUserProfileInfo getCalculatorObject];
    
    kCATCalculator* calculator = [[kCATCalculator alloc] initWithUserProfile:userCalculatorObject andHome:nil];
    float monthlylifestyle = ceilf([calculator getMonthlyLifeStyleIncome]);
    float estimatedIncomeTax = ceilf([calculator getAnnualFederalTaxesPaid] + [calculator getAnnualStateTaxesPaid])/NUMBER_OF_MONTHS_IN_YEAR;
    
    self.mLifestyleIncomeLabel.text = [NSString stringWithFormat:@"$%.0f", monthlylifestyle];
    self.mRentLabel.text = [NSString stringWithFormat:@"%d", [user getMonthlyRentInfo]];
    self.mFixedCosts.text = [NSString stringWithFormat:@"%d", [user getOtherFixedCostsInfo]];
    self.mEstimatedIncomeTaxesLabel.text = [NSString stringWithFormat:@"%.0f", estimatedIncomeTax];
    
    homePayments = @{@"Lifestyle Income" : [NSNumber numberWithFloat:monthlylifestyle],
                     @"Fixed Costs" : [NSNumber numberWithInt:[user getOtherFixedCostsInfo]],
                     @"Rent" : [NSNumber numberWithInt:[user getMonthlyRentInfo]],
                     @"Est. Income Tax": [NSNumber numberWithFloat:estimatedIncomeTax]};

    [self setupChart];
    
    if([kunanceUser getInstance].mkunanceUserProfileInfo && self.mWasLoadedFromMenu)
    {
        self.mAddAHomeButton.hidden = YES;
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                      target:self
                                                      action:@selector(editUserProfile)];
        
    }
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
    pieSeries.selectionAnimation.duration = @0.4;
    pieSeries.selectedPosition = @0.0;
    pieSeries.style.showCrust = NO;
    pieSeries.animationEnabled = YES;
    NSMutableArray* colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0.0/255.0 alpha:0.9]];
    [colors addObject:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:0.9]];
    [colors addObject:[UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:0.9]];
    [colors addObject:[UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:0.9]];
    pieSeries.style.flavourColors = colors;
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
