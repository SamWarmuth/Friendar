//
//  SWAppDelegate.h
//  Friendar
//
//  Created by Sam Warmuth on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SWAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIWindow *window;

- (void)bringPingToForeground:(NSDictionary *)pingData;

@end
