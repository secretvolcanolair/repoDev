//
//  WhereSearch.h
//  REON
//
//  Created by Chad McElwain on 8/5/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface WhereSearch : UIViewController<MKMapViewDelegate, UITextFieldDelegate>{
    MKMapView *mapview;
    NSMutableArray *locations;
    AppDelegate *appDelegate;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *connectionsLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

-(IBAction)setMap:(id)sender;

-(IBAction)Getlocation:(id)sender;

-(IBAction)Direction:(id)sender;



@end
