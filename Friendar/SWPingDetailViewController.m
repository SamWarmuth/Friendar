//
//  SWPingDetailViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWPingDetailViewController.h"
#import "SWHelpers.h"
#import "SWAppDelegate.h"

@interface SWPingDetailViewController ()

@end

@implementation SWPingDetailViewController
@synthesize styledButtons, user, usernameLabel, locationLabelOne, locationLabelTwo, directionsToButton, addressToClipboardButton, pingButton, distanceLabel, mapView;
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
	// Do any additional setup after loading the view.
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"button_gloss.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:21];
    
    UIImage *pressedBackgroundImage = [UIImage imageNamed:@"button_gloss_pressed.png"];
    UIImage *stretchedPressed = [pressedBackgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:21];
    
	for (UIButton *button in self.styledButtons) {
        [button setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
        [button setBackgroundImage:stretchedPressed forState:UIControlStateHighlighted];
        
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    directionsToButton.enabled = FALSE;
    addressToClipboardButton.enabled = FALSE;
    pingButton.enabled = FALSE;
    [self.directionsToButton setTitleColor:SWDisabledTextColor forState:UIControlStateNormal];
    [self.addressToClipboardButton setTitleColor:SWDisabledTextColor forState:UIControlStateNormal];
    [self.pingButton setTitleColor:SWDisabledTextColor forState:UIControlStateNormal];
    
}

- (void)updateWithUserID:(NSString *)userID
{
    [SVProgressHUD showWithStatus:@"Loading Ping..."];
    PFQuery *query = [PFQuery queryForUser];
    [query getObjectInBackgroundWithId:userID block:^(PFObject *newUser, NSError *error){
        self.user = (PFUser *)newUser;
        [self updateUI];
        [SVProgressHUD dismiss];
    }];
}
- (void)updateUI
{
    if (!self.user) return;
    directionsToButton.enabled = TRUE;
    addressToClipboardButton.enabled = TRUE;
    pingButton.enabled = TRUE;
    [self.directionsToButton setTitleColor:SWEnabledTextColor forState:UIControlStateNormal];
    [self.addressToClipboardButton setTitleColor:SWEnabledTextColor forState:UIControlStateNormal];
    [self.pingButton setTitleColor:SWEnabledTextColor forState:UIControlStateNormal];
    
    self.usernameLabel.text = [NSString stringWithFormat:@"%@ %@ pinged you!", [user objectForKey:@"firstName"], [user objectForKey:@"lastName"]];
    
    NSDictionary *currentAddress = [user objectForKey:@"current"];
    self.locationLabelOne.text = [NSString stringWithFormat:@"%@ %@", [currentAddress valueForKey:@"streetNumber"], [currentAddress valueForKey:@"street"]];
    self.locationLabelTwo.text = [NSString stringWithFormat:@"%@, %@", [currentAddress valueForKey:@"city"], [currentAddress valueForKey:@"state"]];
    
    NSDictionary *userLocationDict = [user objectForKey:@"current"];
    
    
    double lat = [[userLocationDict valueForKey:@"latitude"] doubleValue];
    double lng = [[userLocationDict valueForKey:@"longitude"] doubleValue];
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];

    SWAppDelegate *appDelegate = (SWAppDelegate *)[[UIApplication sharedApplication] delegate];
    CLLocation *currentLocation = [appDelegate locationManager].location;
    
    NSLog(@"%@ to %@", userLocation, currentLocation);
    
    CLLocationDistance distance = [userLocation distanceFromLocation:currentLocation];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fmi", distance/METERS_PER_MILE];
    
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

-(IBAction)pingBackPressed:(id)sender
{
    if (!self.user) return;
    
    pingButton.enabled = FALSE;
    [self.pingButton setTitleColor:SWDisabledTextColor forState:UIControlStateNormal];
    [SWHelpers pingUser:self.user];
    [SVProgressHUD show];
    NSString *message = [NSString stringWithFormat:@"Pinged %@", [self.user objectForKey:@"firstName"]];
    [SVProgressHUD dismissWithSuccess:message afterDelay:1.5];
}

- (IBAction)copyToClipboardPressed:(id)sender   
{
    NSDictionary *currentAddress = [self.user objectForKey:@"current"];
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
