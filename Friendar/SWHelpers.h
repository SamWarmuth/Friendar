//
//  SWHelpers.h
//  Friendar
//
//  Created by Sam Warmuth on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SWDisabledTextColor [UIColor colorWithRed:0.639 green:0.639 blue:0.639 alpha:1.0]
#define SWEnabledTextColor [UIColor colorWithRed:0.227 green:0.227 blue:0.227 alpha:1.0]


@interface SWHelpers : NSObject

+ (void)directionsForAddressDict:(NSDictionary *)addressDict;
+ (NSString *)stringFromAddressDict:(NSDictionary *)addressDict;
+ (void)pingUser:(PFUser *)user;
@end
