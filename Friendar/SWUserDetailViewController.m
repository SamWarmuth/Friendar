//
//  SWUserDetailViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWUserDetailViewController.h"
#import "SWHelpers.h"
#import "SWMapViewController.h"

@interface SWUserDetailViewController ()

@end

@implementation SWUserDetailViewController
@synthesize styledButtons, avatarImageView, user, usernameLabel, locationLabelOne, locationLabelTwo, mapButton, directionsToButton, addressToClipboardButton, backInTownButton, pingButton, shareMyLocationButton;;
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
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"button_gloss.png"];
    UIImage *stretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:21];
    
    UIImage *pressedBackgroundImage = [UIImage imageNamed:@"button_gloss_pressed.png"];
    UIImage *stretchedPressed = [pressedBackgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:21];
    
	for (UIButton *button in self.styledButtons) {
        [button setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
        [button setBackgroundImage:stretchedPressed forState:UIControlStateHighlighted];
    }
    
    self.avatarImageView.layer.cornerRadius = 4.0;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.user){
        
        self.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"firstName"], [user objectForKey:@"lastName"]];
        
        self.avatarImageView.layer.cornerRadius = 4.0;
        self.avatarImageView.clipsToBounds = TRUE;
        
        if ([user objectForKey:@"profilePicture"]) self.avatarImageView.image = [UIImage imageWithData:[user objectForKey:@"profilePicture"]];
        else self.avatarImageView.image = [UIImage imageNamed:@"avatar"];
        
        pingButton.enabled = TRUE;
        [self.pingButton setTitleColor:SWEnabledTextColor forState:UIControlStateNormal];
        

        NSDictionary *currentAddress = [user objectForKey:@"current"];
        if (currentAddress == nil || [[NSDate date] timeIntervalSinceDate:(NSDate *)[currentAddress objectForKey:@"timestamp"]] > 60*60*2){
            self.locationLabelOne.text = @"";
            self.locationLabelTwo.text = @"Location Not Available";
            
            [self.directionsToButton setTitleColor:SWDisabledTextColor forState:UIControlStateNormal];
            [self.addressToClipboardButton setTitleColor:SWDisabledTextColor forState:UIControlStateNormal];
            [self.mapButton setTitleColor:SWDisabledTextColor forState:UIControlStateNormal];

            self.directionsToButton.enabled = FALSE;
            self.addressToClipboardButton.enabled = FALSE;
            self.mapButton.enabled = FALSE;
        } else {
            self.locationLabelOne.text = [NSString stringWithFormat:@"%@ %@", [currentAddress valueForKey:@"streetNumber"], [currentAddress valueForKey:@"street"]];
            self.locationLabelTwo.text = [NSString stringWithFormat:@"%@, %@", [currentAddress valueForKey:@"city"], [currentAddress valueForKey:@"state"]];
            
            [self.directionsToButton setTitleColor:SWEnabledTextColor forState:UIControlStateNormal];
            [self.addressToClipboardButton setTitleColor:SWEnabledTextColor forState:UIControlStateNormal];
            [self.mapButton setTitleColor:SWEnabledTextColor forState:UIControlStateNormal];

            self.directionsToButton.enabled = TRUE;
            self.addressToClipboardButton.enabled = TRUE;
            self.mapButton.enabled = TRUE;

        }
        
    }

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
- (IBAction)pingPressed:(id)sender
{
    pingButton.enabled = FALSE;
    [self.pingButton setTitleColor:SWDisabledTextColor forState:UIControlStateNormal];
    [SWHelpers pingUser:self.user];
    [SVProgressHUD show];
    NSString *message = [NSString stringWithFormat:@"Pinged %@", [self.user objectForKey:@"firstName"]];
    [SVProgressHUD dismissWithSuccess:message afterDelay:1.5];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SWDetailToMap"]){
        SWMapViewController *destinationView = segue.destinationViewController;
        destinationView.user = self.user;
    }
    
}

@end
