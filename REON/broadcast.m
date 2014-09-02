//
//  broadcast.m
//  REON 1.0.1
//
//  Created by Chad McElwain on 6/3/14.
//  Copyright (c) 2014 Remember Everyone. All rights reserved.
//

#import "broadcast.h"

@interface broadcast ()

@end

@implementation broadcast
static int keyLimit = 20000;

-(id)initWithUserIDString: (NSString *)userIdString{
    
    self = [super init];
    
    //--- Obtain Major/Minor Values based on UserID
    NSMutableDictionary *minMajDict = [broadcast encodeUserIDString:userIdString];
    major = [[minMajDict objectForKey:@"major"] intValue];
    minor = [[minMajDict objectForKey:@"minor"] intValue];
    
    //--- Start broadcasting
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"4FC2E30B-46B8-4636-B97A-694CE0975A0C"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:major minor:minor identifier:@"reon.remembereveryone.com"];
    
    return self;
    
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn){
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    }
    
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        [self.peripheralManager stopAdvertising];
    }
    
}

-(void)startBroadcasting{
    
    if(!self.beaconPeripheralData || self.peripheralManager){
        self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    
    [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    
}

-(void)stopBroadcasting{
    [self.peripheralManager stopAdvertising];
}

//--- Encode user ID into major/minor values
+(NSMutableDictionary *) encodeUserIDString: (NSString *)userIdString{
    
    int userId = [userIdString intValue];
   
    NSMutableDictionary *majMinObject = [[NSMutableDictionary alloc] init];
    majMinObject[@"major"] = [NSNumber numberWithInt:(userId%keyLimit)];
    majMinObject[@"minor"] = [NSNumber numberWithInt:(floor(userId)/keyLimit)];
    
    return majMinObject;
    
}

//--- Decode major/minor values into a userId
+(NSNumber *) decodeForUserIdWithMajor: (int)major andMinor: (int)minor{
    return [NSNumber numberWithInt:(major + (keyLimit * minor))];
}

@end
