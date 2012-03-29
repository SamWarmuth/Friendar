//
//  SWSignUpViewController.h
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWSignUpViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *email, *password, *passwordConfirm;


-(IBAction)signupPressed:(id)sender;

@end
