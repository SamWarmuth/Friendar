//
//  ALMotionState.h
//  Alohar
//
//  Created by Sam Warmuth on 2/23/12.
//  Copyright (c) 2012 Alohar Mobile Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALMotionStateStationary                     0
#define ALMotionStateWalking                        1
#define ALMotionStateDriving                        2
#define ALMotionStateNoData                         3
#define ALMotionStateBigMove                        4


@interface ALMotionState : NSObject
@property (nonatomic, strong) NSNumber *state;

- (NSString *)stateDescription;

@end
