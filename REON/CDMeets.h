//
//  CDMeets.h
//  REON
//
//  Created by Robert Kehoe on 9/1/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDMeets : NSManagedObject

@property (nonatomic, retain) NSString * cardCompany;
@property (nonatomic, retain) NSString * cardEmailhome;
@property (nonatomic, retain) NSString * cardEmailother;
@property (nonatomic, retain) NSString * cardEmailwork;
@property (nonatomic, retain) NSString * cardFacebook;
@property (nonatomic, retain) NSString * cardFirstname;
@property (nonatomic, retain) NSString * cardID;
@property (nonatomic, retain) NSData * cardImage;
@property (nonatomic, retain) NSString * cardInstagram;
@property (nonatomic, retain) NSString * cardLabel;
@property (nonatomic, retain) NSString * cardLastname;
@property (nonatomic, retain) NSNumber * cardLat;
@property (nonatomic, retain) NSString * cardLinkedIn;
@property (nonatomic, retain) NSNumber * cardLon;
@property (nonatomic, retain) NSString * cardPhonecell;
@property (nonatomic, retain) NSString * cardPhoneother;
@property (nonatomic, retain) NSString * cardPhonework;
@property (nonatomic, retain) NSString * cardPrefix;
@property (nonatomic, retain) NSString * cardSuffix;
@property (nonatomic, retain) NSString * cardTitle;
@property (nonatomic, retain) NSString * cardTwitter;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSNumber * goldStar;
@property (nonatomic, retain) NSString * meet_id;
@property (nonatomic, retain) NSNumber * redStar;
@property (nonatomic, retain) NSNumber * showFacebook;
@property (nonatomic, retain) NSNumber * showInstagram;
@property (nonatomic, retain) NSNumber * showLinkedIn;
@property (nonatomic, retain) NSNumber * showSalesforce;
@property (nonatomic, retain) NSNumber * showTwitter;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * addedFromAdressbook;

@end
