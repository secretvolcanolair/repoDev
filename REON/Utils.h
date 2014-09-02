//
//  Utils.h
//  REON
//
//  Created by Robert Kehoe on 6/30/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDCard.h"
#import <CoreLocation/CoreLocation.h>
#import "CDMeets.h"

typedef enum : NSUInteger {
    meetActionAccepted,
    meetActionRejected,
    meetActionIgnored
} meetAction;

@interface Utils : NSObject<CLLocationManagerDelegate>

+(NSString *)currentMember;
+(NSString *)currentMemberName;
+(void) registerNewUserWithDictionaryParams: (NSMutableDictionary *)params profileImageData: (NSData *)imageData setCallback: (void(^)(void))callback;
+(void) connectFacebookUserWithDictionaryParams: (NSMutableDictionary *)params profileImageData: (NSData *)imageData setCallback: (void(^)(void))callback;
+(void) loginWithEmailAddress: (NSString *)email andPassword: (NSString *)password withCallback: (void(^)(void))callback;
+(void) shareCard: (CDCard *)card withMember: (NSString *)memberId callback: (void(^)(void))callback;
+(void) queryMemberInfo: (NSArray *)memberIDArray withCallback: (void(^)(NSDictionary *queryObject))callback;
+(void) saveCard: (CDCard *) cardObject withCallback: (void(^)(NSString *cardId))callback;
+(void) checkPendingShares: (void(^)(NSMutableDictionary *object, int totalPendingShares, NSArray *pendingSharesObject))callback;
+(void) changeNotificationStatus: (CDMeets *)meetObject withStatus: (meetAction)status withCallback: (void(^)(void))callback;

+(void) apiPOSTWithDictionary: (NSDictionary *)postObject withCallback: (void(^)(BOOL success, NSDictionary *object))callback;
+(void) apiPOSTWithDictionary: (NSDictionary *)postObject andImage: (NSData *)imageData andImageName: (NSString *)imageName withCallback: (void(^)(BOOL success, NSDictionary *object))callback;

-(CLLocationCoordinate2D) getLocation;

+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
+(UIImage *) screenshotFromUIImageView: (UIImageView *)imgView;

+(void)showSpinner;
+(void)hideSpinner;

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day isEndOfDay: (BOOL)eod;
+ (NSDate *) lastDayOfMonth: (int)month inYear: (int)year;
+ (NSDate *) firstDayOfMonth: (int)month inYear: (int)year;

@end
