//
//  SWAppDelegate.h
//  Friendar
//
//  Created by Sam Warmuth on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Alohar/Alohar.h>
@interface SWAppDelegate : UIResponder <UIApplicationDelegate, ALUserStayDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)timerCallback:(NSTimer *)timer;
- (void)sendLocationAndAddressToServerWithLocation:(CLLocation *)location;

@end
