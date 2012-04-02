//
//  SWSettingsViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWSettingsViewController.h"

@interface SWSettingsViewController ()

@end

@implementation SWSettingsViewController

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

- (IBAction)logoutPressed:(id)sender
{
    [PFUser logOut];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *signup = [storyboard instantiateViewControllerWithIdentifier:@"SWSignUpViewController"];
    UINavigationController *navController = self.navigationController;
    navController.viewControllers = [NSArray arrayWithObject:signup];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
