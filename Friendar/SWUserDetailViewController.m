//
//  SWUserDetailViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWUserDetailViewController.h"

@interface SWUserDetailViewController ()

@end

@implementation SWUserDetailViewController
@synthesize styledButtons, avatarImageView;
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
        NSLog(@"Updating Button");        
        [button setBackgroundImage:stretchedBackground forState:UIControlStateNormal];
        [button setBackgroundImage:stretchedPressed forState:UIControlStateHighlighted];
    }
    
    self.avatarImageView.layer.cornerRadius = 4.0;

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
