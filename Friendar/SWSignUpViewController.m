//
//  SWSignUpViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWSignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

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
        [PFPush subscribeToChannelInBackground:[@"U" stringByAppendingString:currentUser.objectId]];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *mainView = [storyboard instantiateViewControllerWithIdentifier:@"SWMainViewController"];
        UINavigationController *navController = self.navigationController;
        navController.viewControllers = [NSArray arrayWithObject:mainView];
    } 
    
    
    
}

- (void)signupWithFacebook
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.email becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordConfirm){
        if (email.text.length == 0 || password.text.length == 0) return NO;
        
        PFUser *user = [PFUser user];
        user.username = email.text;
        user.password = password.text;
        user.email = email.text;
        [user setObject:[[NSMutableArray alloc] init] forKey:@"friends"];

        
        // other fields can be set just like with PFObject
        //[user setObject:@"415-392-0202" forKey:@"phone"];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [PFPush subscribeToChannelInBackground:[@"U" stringByAppendingString:user.objectId]];
                [self performSegueWithIdentifier:@"signupToMain" sender:self];
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Signing Up"
                                                                message:errorString
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                alert.delegate = nil;
                [alert show];
            }
        }];
    }else {
        NSInteger nextTag = textField.tag + 1;
        UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
        [nextResponder becomeFirstResponder];
    }
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
