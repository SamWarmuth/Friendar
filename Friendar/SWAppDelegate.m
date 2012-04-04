//
//  SWAppDelegate.m
//  Friendar
//
//  Created by Sam Warmuth on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWAppDelegate.h"
#import "SWPingDetailViewController.h"

@implementation SWAppDelegate
@synthesize locationManager, waitingForGoodPoint, lastLocationUpdate;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [Parse setApplicationId:@"ILWem3qL8V6LnF5E0csTWqn26HFMcZPR4zDkEiZh" clientKey:@"M3YhKrhwl72RtkFXiGMtzL0xgjSSgunC9e42YGxz"];
    [PFFacebookUtils initializeWithApplicationId:@"395649053787339"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    self.lastLocationUpdate = [NSDate dateWithTimeIntervalSince1970:0.0];

    [locationManager startMonitoringSignificantLocationChanges];
    
    //set location manager constants, but don't start it yet.
    locationManager.distanceFilter = 20.0;
    locationManager.desiredAccuracy = 10.0;
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:newDeviceToken];
    // Subscribe to the global broadcast channel.
    [PFPush subscribeToChannelInBackground:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    NSLog(@"%@", userInfo);

    NSString *type = [userInfo valueForKey:@"type"]; 
    if ([type isEqualToString:@"ping"]){
        [self bringPingToForegroundWithUserID:[userInfo objectForKey:@"senderID"]];
    } else if ([type isEqualToString:@"friendRequestConfirm"]){
        NSString *message = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
        [SVProgressHUD show];
        [SVProgressHUD dismissWithSuccess:message afterDelay:3];
    } else if ([type isEqualToString:@"friendRequest"]){
        //Send the user to the add friend view?
    }

    
    
}

- (void)getOneGoodLocationPoint
{
    //if we're waiting already, this is a duplicate call
    if (self.waitingForGoodPoint) return;
    if (self.locationManager == nil) return;
    
    [self.locationManager startUpdatingLocation];
    self.waitingForGoodPoint = TRUE;
    
}

- (void)bringPingToForegroundWithUserID:(NSString *)userID
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *viewController = (UIViewController *)(self.window.rootViewController.childViewControllers.lastObject);
    UINavigationController *navController = viewController.navigationController;
    
    SWPingDetailViewController *pingDetail = [storyboard instantiateViewControllerWithIdentifier:@"SWPingDetail"];
    NSMutableArray *newViewControllers = [navController.viewControllers mutableCopy];
    [newViewControllers addObject:pingDetail];
    [pingDetail updateWithUserID:userID];
    
    navController.viewControllers = [NSArray arrayWithArray:newViewControllers];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url]; 
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"New Location!");
    
    //We want a good point. However, if it's been over 15 minutes since the last point,
    //      upload it anyway and keep waiting.
    if (newLocation.horizontalAccuracy < 20.0){
        NSLog(@"Good Location!");
        [self sendLocationAndAddressToServerWithLocation:newLocation];
        self.waitingForGoodPoint = FALSE;
        [self.locationManager stopUpdatingLocation];
    } else if ([[NSDate date] timeIntervalSinceDate:self.lastLocationUpdate] > 60*15){
        NSLog(@"Not good, but it's been a while, so we'll take what we can get!");
        [self sendLocationAndAddressToServerWithLocation:newLocation];
    }
    
}




- (void)sendLocationAndAddressToServerWithLocation:(CLLocation *)location
{
    if (location == nil) return;
    self.lastLocationUpdate = [NSDate date];
    
    PFUser *currentUser = [PFUser currentUser];
    
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSNumber *accuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];

    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error); 
                           NSDictionary *currentDict = [[NSMutableDictionary alloc] init];

                           [currentDict setValue:lat forKey:@"latitude"];
                           [currentDict setValue:lng forKey:@"longitude"];
                           [currentDict setValue:accuracy forKey:@"accuracy"];
                           [currentDict setValue:[NSDate date] forKey:@"timestamp"];
                           [currentUser saveEventually];
                           return;
                       }
                       if(placemarks && placemarks.count > 0){
                           CLPlacemark *topResult = [placemarks objectAtIndex:0];
                           NSDictionary *currentDict = [[NSMutableDictionary alloc] init];
                           [currentDict setValue:[topResult subThoroughfare] forKey:@"streetNumber"];
                           [currentDict setValue:[topResult thoroughfare] forKey:@"street"];
                           [currentDict setValue:[topResult locality] forKey:@"city"];
                           [currentDict setValue:[topResult administrativeArea] forKey:@"state"];
                           [currentDict setValue:lat forKey:@"latitude"];
                           [currentDict setValue:lng forKey:@"longitude"];
                           [currentDict setValue:accuracy forKey:@"accuracy"];
                           [currentDict setValue:[NSDate date] forKey:@"timestamp"];



                           [currentUser setObject:currentDict forKey:@"current"];
                           
                           [currentUser saveEventually];
                       }
                   }];
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (self.waitingForGoodPoint){
        [self.locationManager stopUpdatingLocation];
        self.waitingForGoodPoint = FALSE;
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([PFUser currentUser]) [self getOneGoodLocationPoint];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
