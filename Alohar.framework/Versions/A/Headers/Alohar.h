//
//  Alohar.h
//  Alohar
//
//  Created by Sam Warmuth on 2/23/12.
//  Copyright (c) 2012 Alohar Mobile Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALMotionState.h"
#import "ALResponse.h"
#import <CoreLocation/CoreLocation.h>
#import "ALPlace.h"
#import "ALUserStay.h"

@protocol ALSessionDelegate <NSObject>
@optional
- (void)aloharDidLogin:(NSString *)userID;
- (void)aloharDidFailWithError:(NSError *)error;
@end

@protocol ALRequestDelegate <NSObject>
@optional
- (void)aloharRequestFinished:(ALResponse *)response;
- (void)aloharDidFailWithError:(NSError *)error;
@end

@protocol ALMotionDelegate <NSObject>
@optional
- (void)didUpdateToMotionState:(ALMotionState *)newMotionState fromMotionState:(ALMotionState *)oldMotionState;
- (void)aloharDidFailWithError:(NSError *)error;
@end

@protocol ALUserStayDelegate <NSObject>
@optional
- (void)currentUserStayIdentified:(ALUserStay *)newStay;
- (void)userArrivedAtPlaceWithLocation:(CLLocation *)location;
- (void)userDepartedPlaceWithLocation:(CLLocation *)location;
- (void)aloharDidFailWithError:(NSError *)error;
@end

enum {
    kALUserStayArrival,
    kALUserStayDeparture,
    kALUserStayUpdate
};


@interface Alohar : NSObject
@property (weak) id <ALSessionDelegate>  sessionDelegate;
@property (weak) id <ALMotionDelegate>   motionDelegate;
@property (weak) id <ALUserStayDelegate> userStayDelegate;

@property BOOL updateMotionState;
@property (nonatomic, strong) ALMotionState *currentMotionState;


/*!
 * Get the Shared Instnace of Alohar
 */
+ (Alohar *)sharedInstance;

/*!
 * Get Framework Version
 * \return The version of Alohar Framework
 */
+ (NSString *)version;

/*!
 * Register a new user for a given App
 *
 * \param appID The AppID granted for the App, click https://www.alohar.com/developer to register your app.
 * \param apiKey The ApiKey granted for the App
 * \param newDelegate A delegate comform to ALSessionDelegate
 */
+ (void)registerWithAppID:(NSString *)appID andAPIKey:(NSString *)APIKey withDelegate:(id)newDelegate;
+ (void)authenticateWithAppID:(NSString *)appID andAPIKey:(NSString *)APIKey andUserID:(NSString *)userID withDelegate:(id)newDelegate;


+ (void)startMonitoringUser;
+ (void)stopMonitoringUser;

+ (void)setMotionDelegate:(id <ALMotionDelegate>)delegate;
+ (void)setUserStayDelegate:(id <ALUserStayDelegate>)delegate;

/*!
 * Get the current user stay object
 * @see ALUserStay
 */
+ (ALUserStay *)currentUserStay;

/*!
 * Get user's user stays of a given date
 * \param date The date to search user stay
 * \param delegate A delegate comforming to protocol ALRequestDelegate
 */
+ (void)getUserStaysForDate:(NSDate *)date withDelegate:(id <ALRequestDelegate>)delegate;

/*!
 * Get user's user stays within a time period
 * \param startDate The start time
 * \param endDate The end time
 * \param delegate A delegate comforming to protocol ALRequestDelegate
 */
+ (void)getUserStaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate withDelegate:(id <ALRequestDelegate>)delegate;
 
/*!
 * Get user's user stays within a time period and a location boundary.
 * 
 * \param startDate The start time
 * \param endDate The end time
 * \param location The centroid location of the search area. Optional.
 * \param radis The search radius in meter. Optinal. Skip if the location is not provided.
 * \param limit The limitation of total number matches to return. Optional. The default is 500.
 * \param withcand Flag to indicate whether the user stay shall include its candidates. Optional. The default is NO.
 * \param delegate A delegate comforming to protocol ALRequestDelegate
 * 
 */
+ (void)getUserStaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate atLocation:(CLLocation *)location radius:(NSInteger) radius limit:(NSInteger)limit withCandidiates:(BOOL)withcand withDelegate:(id<ALRequestDelegate>)delegate;

/*!
 * Get all places user visisted.
 * 
 * \param delegate A delegate comforming to ALRequestDelegate
 * 
 * *NOTE* The response might be large depends on the total number of the places user visisted. Recommend to use getPlaces:withCategory:withDelegate instead. 
 */
+ (void)getAllPlacesWithDelegate:(id <ALRequestDelegate>)delegate;

/*!
 * Get places user visited and match the given name
 * 
 * \param namePattern The regular expression to match the place name.
 * \delegate The delegate comforming to protocol ALRequestDelegate
 */

+ (void)getPlaces:(NSString *)namePattern withDelegate:(id<ALRequestDelegate>)delegate;
/*!
 * Get places user visited match the given name and category 
 * \param namePattern The regular expression to match the place name
 * \param catPatterm The regular expression to match the place's category
 */

+ (void)getPlaces:(NSString *)namePattern withCategory:(NSString *)catPattern withDelegate:(id<ALRequestDelegate>)delegate;

/*!
 * Get places user visisted within a time window match the given category
 * 
 * \param startTime The start time
 * \param endTime The end Time
 * \param visits The mininal numer of visits required for that places. Optioanl. The default is 1.
 * \param catPattern The regular expression to match the place's category
 * \param limist The limitation of total number matches to return. Optional. The default is 500.
 */
+ (void)getPlaces:(NSString *)namePattern fromDate:(NSDate *)startDate toDate:(NSDate *)toDate minimalVisits:(NSInteger)visits withCategory:(NSString *)catPattern limit:(NSInteger)limit withDelegate:(id<ALRequestDelegate>)delegate;

/*!
 * Get place candidates of a given user stay.
 * 
 * \param stay A user stay. @see ALUserStay
 * \param delegate A delegate comforming to protocol ALRequestDelegate
 */
+ (void)getPlaceCandidatesForStay:(ALUserStay *)stay withDelegate:(id<ALRequestDelegate>)delegate;

/*!
 * Get all stays of a given place.
 * \param place A place. @see ALPlace
 * \param delegate A delegate comforming to protocol ALRequestDelegate
 */
+ (void)getStaysForPlace:(ALPlace *)place withDelegate:(id<ALRequestDelegate>)delegate;

/*!
 * Get Place detail
 * \param placeID Valid place id. 
 * \param delegate A delegate comforming to protocol ALRequestDelegate
 */
+ (void)getPlaceDetailsForID:(NSString *)placeID withDelegate:(id<ALRequestDelegate>)delegate;

/*!
 * Get stay detail
 * \param stayId Valid user stay id.
 * \param delegate A delegate comforming to protocol ALRequestDelegate
 */
+ (void)getStayDetailsForID:(NSString *)stayID withDelegate:(id<ALRequestDelegate>)delegate;

/*! 
 * Get current location
 */
+ (CLLocation *)currentLocation;

/*!
 * Get device's current motion state.
 * @see ALMotionState
 */
+ (ALMotionState *)currentMotionState;

/*!
 * Check whether the device is stationary
 * \return YES if the device is NOT moving
 */
+ (BOOL) isStationary;

/*!
 * Check whether the user is moving
 * \return YES if the user is on commute
 */
+ (BOOL) isDriving;

+ (BOOL) monitoringUser;

+ (NSArray *)userStayLocationHistory;

//PRIVATE

- (void)motionStateChanged:(ALMotionState *)motionState;
- (void)userStayChanged:(ALUserStay *)userStay;
- (void)departLocation;
- (void)arriveLocation;

@end


