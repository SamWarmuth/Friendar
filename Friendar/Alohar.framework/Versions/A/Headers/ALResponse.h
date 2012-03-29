//
//  ALResponse.h
//  Alohar
//
//  Created by Sam Warmuth on 2/23/12.
//  Copyright (c) 2012 Alohar Mobile Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALResponse, ALMotionState;



enum {
    kALRequestTypeUserStays,
    kALRequestTypePlaces,
    kALRequestTypeMotionState,
    kALRequestTypeStayDetail,
    kALRequestTypePlaceDetail,
    
};

typedef enum {
    kErr_NETWORK,
    kErr_SERVER,
    kErr_REQUEST
} errorCode;

typedef NSUInteger ALRequestType;



@interface ALResponse : NSObject

@property (strong) NSDate *timeStamp;
@property (nonatomic, strong) NSMutableArray *objects;
@property ALRequestType requestType;


@end
