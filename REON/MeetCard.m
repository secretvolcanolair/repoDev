//
//  MeetCard.m
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "MeetCard.h"
#import "AppDelegate.h"
#import "Utils.h"

@interface MeetCard ()

@end

@implementation MeetCard

@synthesize meetObject;

//--- Throw in an object from the address book (less useful data output)
-(id) initWithABContactObject: (ABContact *)obj{
    
    self = [[UIStoryboard storyboardWithName:@"MeetCard" bundle:Nil] instantiateInitialViewController];
    
    //--- Show spinner
    [Utils showSpinner];
    
    //--- Get Object Context
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    //--- Check for this contact IN coredata (check all phone numbers)
    //--- Insert contact IF needed, then load the meetObject from there
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *cards = [NSEntityDescription entityForName:@"CDMeets" inManagedObjectContext:managedObjectContext];
    [request setEntity:cards];
    
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:Nil] mutableCopy];
    
    BOOL shouldAddNewCoreDataObject = YES;
    CDMeets *foundMeetObject;
    
    if(mutableFetchResults.count > 0){
        
        //--- Loop through all Meetobjects and
        //--- cross references with current contact objects phone numbers
        for(CDMeets *mo in mutableFetchResults){
            
            NSString *firstName = [mo cardFirstname];
            NSString *lastName = [mo cardLastname];
            
            NSString *objectCompositeName = [obj compositeName];
            NSRange nameWithinCompositeRange;
            
            //--- Build range depending on if the last name is available
            if(firstName != Nil && lastName != Nil){
                
                nameWithinCompositeRange = [objectCompositeName rangeOfString:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
                
            }else{
            
                nameWithinCompositeRange = [objectCompositeName rangeOfString:firstName];
            
            }
            
            NSLog(@"Search: %@ %@ (Object: %@)", [mo cardFirstname], [mo cardLastname], [obj compositeName]);
            
            //--- Check for the location of the composite range
            if(nameWithinCompositeRange.location != NSNotFound ){
                foundMeetObject = mo;
                shouldAddNewCoreDataObject = NO;
                break;
            }
            
        }
        
    }
    
    //--- Add core data object or not
    if(shouldAddNewCoreDataObject){
        
        CDMeets *pendingMeet = [NSEntityDescription insertNewObjectForEntityForName:@"CDMeets" inManagedObjectContext:managedObjectContext];
        
        [pendingMeet setCardFirstname:[obj firstname]];
        [pendingMeet setCardLastname:[obj lastname]];
        [pendingMeet setCardTitle:[obj jobtitle]];
        [pendingMeet setCardCompany:[obj organization]];
        if([obj phoneArray].count >= 1) [pendingMeet setCardPhonework:[[obj phoneArray] objectAtIndex:0]];
        if([obj phoneArray].count >= 2) [pendingMeet setCardPhoneother:[[obj phoneArray] objectAtIndex:1]];
        if([obj phoneArray].count >= 3) [pendingMeet setCardPhonecell:[[obj phoneArray] objectAtIndex:2]];
        if([obj emailArray].count >= 1) [pendingMeet setCardEmailwork:[[obj emailArray] objectAtIndex:0]];
        if([obj emailArray].count >= 2) [pendingMeet setCardEmailother:[[obj emailArray] objectAtIndex:1]];
        if([obj emailArray].count >= 3) [pendingMeet setCardEmailhome:[[obj emailArray] objectAtIndex:2]];
        [pendingMeet setDateAdded:[obj creationDate]];
        [pendingMeet setStatus:@"1"];
        [pendingMeet setAddedFromAdressbook:[NSNumber numberWithBool:YES]];
        
        //--- Save users image if exists
        if([obj image]){
            [pendingMeet setCardImage:UIImagePNGRepresentation([obj image])];
        }
        
        [managedObjectContext save:Nil];
        
        foundMeetObject = pendingMeet;
        
    }
    
    //--- Set the create/found object to the meetObject
    meetObject = foundMeetObject;
    
    //--- Hide spinner
    [Utils hideSpinner];
    
    return self;
    
}

//--- Throw in an object from core data (more useful data output)
-(id) initWithCDMeetObject: (CDMeets *)object{
    self = [[UIStoryboard storyboardWithName:@"MeetCard" bundle:Nil] instantiateInitialViewController];
    meetObject = object;
    return self;
}

@end
