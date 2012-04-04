//
//  SWMapViewController.h
//  Friendar
//
//  Created by Sam Warmuth on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SWMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
- (IBAction)directionsToButtonPressed:(id)sender;
- (IBAction)copyToClipboardPressed:(id)sender;
@end
