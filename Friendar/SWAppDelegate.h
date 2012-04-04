//
//  SWAppDelegate.h
//  Friendar
//
//  Created by Sam Warmuth on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344

@interface SWAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIWindow *window;
@property BOOL waitingForGoodPoint;
@property (nonatomic, strong) NSDate *lastLocationUpdate;

- (void)bringPingToForegroundWithUserID:(NSString *)userID;
- (void)getOneGoodLocationPoint;

@end
