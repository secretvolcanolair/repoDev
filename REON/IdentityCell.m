//
//  IdentityCell.m
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "IdentityCell.h"
#import "AppDelegate.h"

@implementation IdentityCell

@synthesize redStar;
@synthesize goldStar;
@synthesize meetObject;

#pragma mark StarDelegate

-(id) initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    //--- Set object context
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    return self;
    
}

-(void) setSelectedGoldStar: (BOOL)goldBool redStar: (BOOL)redBool{
    
    //--- Set star delegates
    redStar.delegate = self;
    goldStar.delegate = self;
    
    [redStar setStarType:StarTypeRed isSelected:redBool];
    [goldStar setStarType:StarTypeGold isSelected:goldBool];
    
}

-(void)starWasTapped:(id)star isSelected:(BOOL)isSelected{
    
    NSError *error;
    
    if(star == goldStar){
        
        NSLog(@"Gold Star %@", isSelected ? @"Selected" : @"Unselected");
        [meetObject setGoldStar:[NSNumber numberWithBool:isSelected]];
        [managedObjectContext save:&error];
        
    }
    
    else if(star == redStar){
        
        NSLog(@"Red Star %@", isSelected ? @"Selected" : @"Unselected");
        [meetObject setRedStar:[NSNumber numberWithBool:isSelected]];
        [managedObjectContext save:&error];
        
    }
    
    if(error){
        NSLog(@"Error: %@", error);
    }
    
}

@end
