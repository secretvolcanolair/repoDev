//
//  AppDelegate.h
//  REON
//
//  Created by Robert Kehoe on 6/23/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "broadcast.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>{
    broadcast *_broadcast;
}

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (void) saveContext;
- (NSURL *) applicationDocumentsDirectory;
+ (void) determineRootViewController;

@end
