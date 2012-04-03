//
//  SWAppDelegate.m
//  Friendar
//
//  Created by Sam Warmuth on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWAppDelegate.h"

@implementation SWAppDelegate
@synthesize locationManager;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [Parse setApplicationId:@"ILWem3qL8V6LnF5E0csTWqn26HFMcZPR4zDkEiZh" clientKey:@"M3YhKrhwl72RtkFXiGMtzL0xgjSSgunC9e42YGxz"];
    [PFFacebookUtils initializeWithApplicationId:@"395649053787339"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:newDeviceToken];
    // Subscribe to the global broadcast channel.
    [PFPush subscribeToChannelInBackground:@""];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[[NSMutableArray alloc] init] forKey:@"friends"];
    
    [currentUser saveEventually];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    NSLog(@"Hi!");
    if (application.applicationState == UIApplicationStateActive){
        NSLog(@"use:%@", userInfo);
        [self bringPingToForeground:nil];
        
    } else {
        NSLog(@"background....");
        NSLog(@"use:%@", userInfo);
        [self bringPingToForeground:nil];
    }
    
}

- (void)bringPingToForeground:(NSDictionary *)pingData
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *viewController = (UIViewController *)(self.window.rootViewController.childViewControllers.lastObject);
    UINavigationController *navController = viewController.navigationController;
    
    UIViewController *pingDetail = [storyboard instantiateViewControllerWithIdentifier:@"SWPingDetail"];
    NSMutableArray *newViewControllers = [navController.viewControllers mutableCopy];
    [newViewControllers addObject:pingDetail];
    
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
    [self sendLocationAndAddressToServerWithLocation:newLocation];
}




- (void)sendLocationAndAddressToServerWithLocation:(CLLocation *)location
{
    if (location == nil) return;
    
    PFUser *currentUser = [PFUser currentUser];
    
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSNumber *accuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];

    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error); 
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
