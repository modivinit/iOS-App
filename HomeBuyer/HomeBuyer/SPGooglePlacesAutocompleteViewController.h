//
//  SPGooglePlacesAutocompleteViewController.h
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/17/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#import <MapKit/MapKit.h>

@class SPGooglePlacesAutocompleteQuery;

@protocol GooglePlacesDelegate
-(void) addressSelected:(CLPlacemark*) placemark;
@end

@interface SPGooglePlacesAutocompleteViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate> {
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    CLPlacemark* placemarkSelected;
    BOOL shouldBeginEditing;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) id <GooglePlacesDelegate> placemarkDelegate;
@property (nonatomic, copy) NSString* existingAddress;
-(IBAction)doneAddress:(id)sender;
-(IBAction)cancelAddress:(id)sender;
@end
