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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.email becomeFirstResponder];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.password){
        NSLog(@"hi! %@, %@", password.text, email.text);
        if (email.text.length == 0 || password.text.length == 0) return NO;
        [PFUser logInWithUsernameInBackground:email.text password:password.text 
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                [PFPush subscribeToChannelInBackground:user.objectId];
                                                [self performSegueWithIdentifier:@"loginToMain" sender:self];
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
