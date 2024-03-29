//
//  SWMapViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWMapViewController.h"
#import "SWAppDelegate.h"
#import "SWHelpers.h"

@interface SWMapViewController ()

@end

@implementation SWMapViewController
@synthesize mapView, user;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.showsUserLocation = TRUE;
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!user) return;
    NSDictionary *userLocationDict = [self.user objectForKey:@"current"];
    double lat = [[userLocationDict valueForKey:@"latitude"] doubleValue];
    double lng = [[userLocationDict valueForKey:@"longitude"] doubleValue];
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1*METERS_PER_MILE, 1*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[MKUserLocation class]]) continue;
        [mapView removeAnnotation:annotation];
    }
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = userLocation.coordinate;
    [self.mapView addAnnotation:annotation];

    
}

-(IBAction)directionsToButtonPressed:(id)sender
{
    [SWHelpers directionsForAddressDict:[user objectForKey:@"current"]];
}


- (IBAction)copyToClipboardPressed:(id)sender   
{
    NSDictionary *currentAddress = [user objectForKey:@"current"];
    if (currentAddress == nil) return;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [SWHelpers stringFromAddressDict:currentAddress];
    
    [SVProgressHUD show];
    [SVProgressHUD dismissWithSuccess:@"Copied to Clipboard" afterDelay:1.5];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
