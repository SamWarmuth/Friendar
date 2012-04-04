//
//  SWPingDetailViewController.h
//  Friendar
//
//  Created by Sam Warmuth on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface SWPingDetailViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *styledButtons;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel, *locationLabelOne, *locationLabelTwo, *distanceLabel;
@property (nonatomic, strong) IBOutlet UIButton *directionsToButton, *addressToClipboardButton, *pingButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) PFUser *user;

- (void)updateWithUserID:(NSString *)userID;
- (void)updateUI;

- (IBAction)directionsToButtonPressed:(id)sender;
- (IBAction)pingBackPressed:(id)sender;
- (IBAction)copyToClipboardPressed:(id)sender;

@end
