//
//  SWHelpers.m
//  Friendar
//
//  Created by Sam Warmuth on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWHelpers.h"

@implementation SWHelpers

+ (void)directionsForAddressDict:(NSDictionary *)addressDict
{
    if (addressDict == nil) return;
    NSString *address = [[NSString stringWithFormat:@"%@ %@, %@, %@",
                          [addressDict valueForKey:@"streetNumber"],
                          [addressDict valueForKey:@"street"],
                          [addressDict valueForKey:@"city"],
                          [addressDict valueForKey:@"state"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *mapsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current%%20Location&daddr=%@", address]];    
    [[UIApplication sharedApplication] openURL:mapsURL];
}

+ (NSString *)stringFromAddressDict:(NSDictionary *)addressDict
{
    return [NSString stringWithFormat:@"%@ %@, %@, %@", [addressDict valueForKey:@"streetNumber"], [addressDict valueForKey:@"street"], [addressDict valueForKey:@"city"], [addressDict valueForKey:@"state"]];
}
+ (void)pingUser:(PFUser *)user
{
    PFUser *currentUser = [PFUser currentUser];
    
    NSString *messageText = [NSString stringWithFormat:@"New Ping from %@ %@", [currentUser objectForKey:@"firstName"], [currentUser objectForKey:@"lastName"]];
    
    
    NSDictionary *alert = [NSDictionary dictionaryWithObjectsAndKeys:
                           messageText, @"body",
                           @"View", @"action-loc-key",
                           nil];
    
    
    NSDictionary *pingData = [NSDictionary dictionaryWithObjectsAndKeys:
                              alert, @"alert",
                              @"ping", @"type",
                              currentUser.objectId, @"senderID", 
                              nil];
    NSLog(@"sending ping.");
    PFPush *push = [[PFPush alloc] init];
    [push setChannel:[@"U" stringByAppendingString:user.objectId]];
    [push setData:pingData];
    [push expireAfterTimeInterval:86400];
    [push sendPushInBackground];
}

@end
