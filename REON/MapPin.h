//
//  MapPin.h
//  REON
//
//  Created by Chad McElwain on 8/5/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CDMeets.h"

@interface MapPin : MKAnnotationView {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property(strong, nonatomic) CDMeets *meetObject;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *subtitle;
@property CLLocationCoordinate2D coordinate;

-(id) initWithMeetObject: (CDMeets *)object;

@end
