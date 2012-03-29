//
//  ALPlace.h
//  Alohar
//
//  Created by Jianming Zhou on 3/16/12.
//  Copyright (c) 2012 Alohar Mobile Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ALPlace : NSObject

@property (nonatomic) NSInteger placeID;
@property (nonatomic) NSInteger exited;
@property (nonatomic) NSInteger visitCount;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *subCategory;


@end
