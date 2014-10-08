//
//  MyContacts.h
//  REON
//
//  Created by Robert Kehoe on 7/31/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDMeets.h"

@interface MyContacts : UITableViewController<UIAlertViewDelegate, UISearchBarDelegate>{
    UIAlertView *requestAlertView;
    CDMeets *requestObject;
    NSInteger realRowCount;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSMutableArray *contactsArray;
@property (strong, nonatomic) NSMutableArray *searchedContactsArray;
@property BOOL showCloseButton;

@end
