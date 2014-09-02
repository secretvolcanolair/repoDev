//
//  Meet.h
//  REON
//
//  Created by Robert Kehoe on 6/23/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "peopleCircle.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "broadcast.h"
#import "meetConfirmation.h"

@interface Meet : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, meetConfirmationDelegate>{
    int cardStageWidth;
    Card *selectedCard;
    int selectedTag;
    UIView *selectedCardView;
    NSArray *peopleArray;
    broadcast *brodcastMe;
    bool didRange;
    UIAlertView *requestAlertView;
    bool showingRequest;
    CDMeets *requestObject;
    NSManagedObjectContext *managedObjectContext;
    meetConfirmation *meetConfirmationView;
    CDMeets *recent1;
    CDMeets *recent2;
    CDMeets *recent3;
}

@property (weak, nonatomic) IBOutlet UIScrollView *cardStage;
@property (weak, nonatomic) IBOutlet UICollectionView *peopleCollection;
@property (weak, nonatomic) IBOutlet UILabel *pendingRequestsLabel;
@property (weak, nonatomic) IBOutlet UIView *pendingRequestsView;

#pragma mark CLLocation
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

#pragma mark Recently Met Placeholders
@property (weak, nonatomic) IBOutlet UIImageView *recentlyMet1;
@property (weak, nonatomic) IBOutlet UIImageView *recentlyMet2;
@property (weak, nonatomic) IBOutlet UIImageView *recentlyMet3;

+(int)randomNumberBetween: (int)lowerBound and: (int)upperBound;

@end
