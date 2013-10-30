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
    }
    return self;
}

-(void) setupChart
{
    userProfileInfo* user = [kunanceUser getInstance].mkunanceUserProfileInfo;
    
    if(user)
    {
        // create the data
        homePayments = @{@"LifeStyle Income" : @2300,
                         @"Fixed Costs" : [NSNumber numberWithInt:[user getOtherFixedCostsInfo]],
                         @"Rent" : @1200,
                         @"Est. Income Tax": @2000};
        
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* titleText = [NSString stringWithFormat:@"Current Lifestyle Income"];
    self.navigationController.navigationBar.topItem.title = titleText;
    // Do any additional setup after loading the view from its nib.
    [self setupChart];
    
    if([kunanceUser getInstance].mUserProfileStatus != ProfileStatusPersonalFinanceAndFixedCostsInfoEntered)
        self.mAddAHomeButton.hidden = YES;
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


#pragma mark actions, gestures
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
