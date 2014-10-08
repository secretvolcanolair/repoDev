//
//  CDUserInfo.h
//  REON
//
//  Created by admin on 29/09/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CDUserInfo : NSManagedObject

@property (nonatomic, retain) NSString * rName;
@property (nonatomic, retain) NSString * rImage;
@property (nonatomic, retain) NSString * rEmail;
@property (nonatomic, retain) NSString * rPwd;
@property (nonatomic, retain) NSString * rSalesForce;
@property (nonatomic, retain) NSString * rFacebookID;
@property (nonatomic, retain) NSString * rFacebookToken;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * middle_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * rFBusername;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * rLinkedInID;
@property (nonatomic, retain) NSString * rLinkedInToken;
@property (nonatomic, retain) NSString * userinfoID;
@property (nonatomic, retain) NSString * phoneNumber;

@end
