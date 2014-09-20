//
//  AppDelegate.m
//  REON
//
//  Created by Robert Kehoe on 6/23/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "AppDelegate.h"
#import "Utils.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//--- Application did finish launching.
-(void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"App closed... fire off notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopListening" object:Nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [AppDelegate determineRootViewController];
    
    //--- Keep track of iBeacon region
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(_broadcast){
        [_broadcast stopBroadcasting];
        _broadcast = Nil;
    }
    
    return YES;

}

#pragma mark CoreLocation

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    NSLog(@"Init with user id: %@", [Utils currentMember]);
    
    //--- Bluetooth: Setup beacon region
    
    if(!_broadcast){
        _broadcast = [[broadcast alloc] initWithUserIDString:[Utils currentMember]];
    }
    
    [_broadcast startBroadcasting];

}

#pragma mark Facebook

//--- Facebook
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

+(void) determineRootViewController{
    
    UIWindow *rootWindow = [[[UIApplication sharedApplication] delegate] window];
    
    //--- Member Logged In
    if([Utils currentMember]){
        NSLog(@"Init with user id: %@", [Utils currentMember]);
        UINavigationController *generalNavigationController = [[UIStoryboard storyboardWithName:@"General" bundle:Nil] instantiateInitialViewController];
        rootWindow.rootViewController = generalNavigationController;
        [rootWindow makeKeyAndVisible];
    }
    
    //--- No Member
    else{
        UINavigationController *registerStoryboard = [[UIStoryboard storyboardWithName:@"Register" bundle:Nil] instantiateInitialViewController];
        rootWindow.rootViewController = registerStoryboard;
        [rootWindow makeKeyAndVisible];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"REON" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"REON.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
