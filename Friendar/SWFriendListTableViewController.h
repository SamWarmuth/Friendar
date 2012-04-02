//
//  SWFriendListTableViewController.h
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

@interface SWFriendListTableViewController : PFQueryTableViewController

- (void)spotConfirmPressed:(MAConfirmButton *)button;
@end
