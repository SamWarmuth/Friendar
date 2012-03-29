//
//  ALUserStay.h
//  Alohar
//
//  Created by Jianming Zhou on 3/16/12.
//  Copyright (c) 2012 Alohar Mobile Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPlace.h"

@interface ALUserStay : NSObject

@property (nonatomic, strong) CLLocation *centroidLocation;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger stayID;
@property (nonatomic, strong) ALPlace *selectedPlace;
@property (nonatomic, strong) NSArray *candidates;

@end
