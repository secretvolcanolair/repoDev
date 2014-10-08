//
//  broadcast.h
//  REON 1.0.1
//
//  Created by Chad McElwain on 6/3/14.
//  Copyright (c) 2014 Remember Everyone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface broadcast : NSObject<CBPeripheralManagerDelegate>{
    int major;
    int minor;
}

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

-(id)initWithUserIDString: (NSString *)userIdString;

-(void)startBroadcasting;
-(void)stopBroadcasting;

#pragma mark Public Methods
+(NSMutableDictionary *) encodeUserIDString: (NSString *)userIdString;
+(NSNumber *) decodeForUserIdWithMajor: (int)major andMinor: (int)minor;

@end
