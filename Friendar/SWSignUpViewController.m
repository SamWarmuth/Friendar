//
//  SWSignUpViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWSignUpViewController.h"

@interface SWSignUpViewController ()

@end

@implementation SWSignUpViewController
@synthesize email, password, passwordConfirm;

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
	PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"%@", currentUser);

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *mainView = [storyboard instantiateViewControllerWithIdentifier:@"SWMainViewController"];
        UINavigationController *navController = self.navigationController;
        navController.viewControllers = [NSArray arrayWithObject:mainView];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction)signupPressed:(id)sender
{
    if (email.text.length == 0 || password.text.length == 0) return;

    PFUser *user = [PFUser user];
    user.username = email.text;
    user.password = password.text;
    user.email = email.text;
    
    // other fields can be set just like with PFObject
    //[user setObject:@"415-392-0202" forKey:@"phone"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"signupToMain" sender:self];
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error signing up: %@", errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
