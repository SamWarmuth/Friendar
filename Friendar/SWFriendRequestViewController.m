//
//  SWFriendRequestViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWFriendRequestViewController.h"

@interface SWFriendRequestViewController ()

@end

@implementation SWFriendRequestViewController
@synthesize email;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [email becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Send invite!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
        [SVProgressHUD dismissWithSuccess:@"Invite Sent" afterDelay:2.5];
        self.email.text = @"";
    });
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
