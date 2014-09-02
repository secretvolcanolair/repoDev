//
//  WhereSearch.m
//  REON
//
//  Created by Chad McElwain on 8/5/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "WhereSearch.h"
#import "MapPin.h"
#import "CDMeets.h"
#import "AppDelegate.h"
#import "MeetCard.h"
#import "Utils.h"

@interface WhereSearch ()

@end

@implementation WhereSearch

@synthesize mapview;
@synthesize searchField;
@synthesize connectionsLabel;

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [searchField setDelegate:self];
    
    //--- Get geo coordinates from coreLocation
    Utils *utilsClass = [[Utils alloc] init];
    CLLocationCoordinate2D geoCoordinates = [utilsClass getLocation];
    
    MKCoordinateRegion region = {{0.0,0.0}, {0.0,0.0}};
    region.center.latitude = geoCoordinates.latitude;
	region.center.longitude = geoCoordinates.longitude;
    region.span.longitudeDelta = 0.5;
    region.span.latitudeDelta = 0.5;
    
    [mapview setRegion:region animated:YES];
    [mapview setDelegate:self];
    [mapview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped)]];
    
    //--- Establish the managed object context (For CoreData)
    appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    //--- Plot Pins
    [self searchAndPlotPins];
    
}

-(void)searchAndPlotPins{
    
    //--- Remove ALL current pins before processing new ones
    if(locations.count > 0){
        [self.mapview removeAnnotations:locations];
    }
    
    //--- Get ALL contacts from the database
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *meets = [NSEntityDescription entityForName:@"CDMeets" inManagedObjectContext:managedObjectContext];
    
    //--- Check if the user has text in the search field
    NSPredicate *filterPredicate;
    
    if(![searchField.text isEqualToString:@""]){
        filterPredicate = [NSPredicate predicateWithFormat:@"status=2 AND (cardFirstname contains[cd] %@ or cardLastname contains[cd] %@)", searchField.text, searchField.text];
    }else{
        filterPredicate = [NSPredicate predicateWithFormat:@"status = 2"];
    }
    
    [request setPredicate:filterPredicate];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"meet_id" ascending:NO]]];
    [request setEntity:meets];
    
    NSArray *meetObjects = [managedObjectContext executeFetchRequest:request error:Nil];
    
    //--- Star the annotation object
    locations = [[NSMutableArray alloc] init];
    
    //--- Loop through meet objects and add annotations
    if(meetObjects.count > 0){
        
        connectionsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)meetObjects.count];
        
        for(CDMeets *meetObject in meetObjects){
            
            MapPin *myAnn = [[MapPin alloc] initWithMeetObject:meetObject];
            [locations addObject:myAnn];
            
        }
        
    }
    
    [self.mapview addAnnotations:locations];
    
}

-(void)mapTapped{
    [searchField resignFirstResponder];
}

-(IBAction)setMap:(id)sender{
    
    switch (((UISegmentedControl *) sender).selectedSegmentIndex){
        case 0:
            mapview.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapview.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapview.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }

}

-(IBAction)Getlocation:(id)sender{
    mapview.showsUserLocation = YES;
}

-(IBAction)Direction:(id)sender{
    
    NSString * urlString = @"http://maps.apple.com/maps?daddr=";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    //--- If the annotation ISN'T the user location annotation then show contact card
    
    if(![view.annotation isKindOfClass:[MKUserLocation class]]){
    
        MapPin *pin = (MapPin *)view.annotation;
        CDMeets *meetObject = [pin meetObject];
        
        [mapView deselectAnnotation:view.annotation animated:NO];
        
        MeetCard *meetCard = [[MeetCard alloc] initWithCDMeetObject:meetObject];
        
        [self presentViewController:meetCard animated:YES completion:Nil];
        
    }
    
}

#pragma mark TextField Delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self searchAndPlotPins];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self searchAndPlotPins];
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [textField resignFirstResponder];
    [textField setText:@""];
    [self searchAndPlotPins];
    return NO;
}

@end
