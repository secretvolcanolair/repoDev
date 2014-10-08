//
//  pendingRequests.h
//  REON
//
//  Created by Robert Kehoe on 7/15/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDMeets.h"
#import "meetConfirmation.h"

@interface pendingRequests : UITableViewController<NSFetchedResultsControllerDelegate, UIAlertViewDelegate, meetConfirmationDelegate>{
    UIAlertView *requestAlertView;
    CDMeets *requestObject;
    meetConfirmation *meetConfirmationView;
    NSInteger realRowCount;
}

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
