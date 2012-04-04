//
//  SWFacebookConnectViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWFacebookConnectViewController.h"
#import "SWAppDelegate.h"

@interface SWFacebookConnectViewController ()

@end

@implementation SWFacebookConnectViewController

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
- (IBAction)connectButtonPushed:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Linking Facebook account"];
    });
    

    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            nil];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [SVProgressHUD dismiss];
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [(SWAppDelegate *)[[UIApplication sharedApplication] delegate] getOneGoodLocationPoint];
            [[PFFacebookUtils facebook] requestWithGraphPath:@"me" andDelegate:self];
        } else {
            NSLog(@"User logged in through Facebook!");
            [SVProgressHUD dismiss];
            [(SWAppDelegate *)[[UIApplication sharedApplication] delegate] getOneGoodLocationPoint];
            [self performSegueWithIdentifier:@"SWFacebookToMain" sender:self];
        }
    }];
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result
{
	PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[NSMutableArray arrayWithObject:currentUser] forKey:@"friends"];
    if ([result valueForKey:@"first_name"]) [currentUser setObject:[result valueForKey:@"first_name"] forKey:@"firstName"];
    if ([result valueForKey:@"last_name"]) [currentUser setObject:[result valueForKey:@"last_name"] forKey:@"lastName"];


    
    NSString *urlPath = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [result valueForKey:@"username"]];
    NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlPath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [NSURLConnection sendAsynchronousRequest:imageRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error != nil){
            NSLog(@"ERROR downloading profile picture. %@", error);
            return;
        }
        [currentUser setObject:data forKey:@"profilePicture"];
        [currentUser saveInBackground];
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:@"SWFacebookToMain" sender:self];
        
    }];

    
}
- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
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
