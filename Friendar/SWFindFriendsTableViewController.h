//
//  SWFindFriendsTableViewController.h
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "MAConfirmButton.h"

#define SWButtonTagOffset                 1111

@interface SWFindFriendsTableViewController : PFQueryTableViewController

- (void)addFriendPressed:(MAConfirmButton *)button;
@end
