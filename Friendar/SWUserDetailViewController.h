//
//  SWUserDetailViewController.h
//  Friendar
//
//  Created by Sam Warmuth on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWUserDetailViewController : UIViewController {
    NSArray *styledButtons;
}

@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *styledButtons;
@property (nonatomic, strong) IBOutlet UIButton *directionsToButton, *addressToClipboardButton, *backInTownButton, *pingButton, *shareMyLocationButton;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel, *locationLabelOne, *locationLabelTwo;
@property (nonatomic, strong) PFUser *user;

- (IBAction)directionsToButtonPressed:(id)sender;
- (IBAction)copyToClipboardPressed:(id)sender;
- (IBAction)pingPressed:(id)sender;

@end
