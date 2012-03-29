//
//  SWLoginViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWLoginViewController.h"

@interface SWLoginViewController ()

@end

@implementation SWLoginViewController
@synthesize email,password;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction)loginPressed:(id)sender
{
    if (email.text.length == 0 || password.text.length == 0) return;
    [PFUser logInWithUsernameInBackground:email.text password:password.text 
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                        } else {
                                            // The login failed. Check error to see why.
                                        }
                                    }]; 
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
