//
//  MapPin.m
//  REON
//
//  Created by Chad McElwain on 8/5/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

@synthesize meetObject;
@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

-(id) initWithMeetObject: (CDMeets *)object{
    
    self = [super init];
    
    meetObject = object;
    
    coordinate = CLLocationCoordinate2DMake([[meetObject cardLat] doubleValue], [[meetObject cardLon] doubleValue]);
    title = [NSString stringWithFormat:@"%@ %@", [meetObject cardFirstname], [meetObject cardLastname]];
    
    return self;
    
}

@end
