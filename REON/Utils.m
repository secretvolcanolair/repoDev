//
//  Utils.m
//  REON
//
//  Created by Robert Kehoe on 6/30/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "Utils.h"
#import <AFNetworking.h>
#import <DSXActivityIndicator.h>
#import "AppDelegate.h"
#import <ABContactsHelper.h>
#import <ABStandin.h>

@implementation Utils

static NSString *apiEndpoint = @"http://api.reon.social/index2.php";

//--- Get the current member id
+(NSString *)currentMember{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"memberId"];
}

+(NSString *)currentMemberName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"memberName"];
}

+(void) registerNewUserWithDictionaryParams: (NSMutableDictionary *)params profileImageData: (NSData *)imageData setCallback: (void(^)(void))callback{
    
    /*
     * Params:
     * - first_name
     * - last_name
     * - email_address
     * - password
     */
    
    params[@"type"] = @"1";
    
    [Utils apiPOSTWithDictionary:params andImage:imageData andImageName:@"profile_image" withCallback:^(BOOL success, NSDictionary *object) {
        
        if(success){
            
            NSString *memberId = [object valueForKey:@"memberid"];
            NSString *memberName = [object valueForKey:@"name"];
            
            if(memberId){
                
                NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
                [standardDefaults setValue:memberId forKey:@"memberId"];
                [standardDefaults setValue:memberName forKey:@"memberName"];
                [standardDefaults synchronize];
                
                if(callback){
                    callback();
                }
                
            }
            
        }
        
    }];
    
}

+(void) connectFacebookUserWithDictionaryParams: (NSMutableDictionary *)params profileImageData: (NSData *)imageData setCallback: (void(^)(void))callback{
    
    /*
     * Params:
     * - first_name
     * - last_name
     * - email_address
     * - facebook_id
     * - facebook_token
     */
    
    params[@"type"] = @"facebook_connect";
    
    [Utils apiPOSTWithDictionary:params andImage:imageData andImageName:@"profile_image" withCallback:^(BOOL success, NSDictionary *object) {
        
        if(success){
            
            NSString *memberId = [object valueForKey:@"memberid"];
            NSString *memberName = [object valueForKey:@"name"];
            
            NSLog(@"Facebook name: %@", memberName);
            
            if(memberId){
                
                NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
                [standardDefaults setValue:memberId forKey:@"memberId"];
                [standardDefaults setValue:memberName forKey:@"memberName"];
                [standardDefaults synchronize];
                
                if(callback){
                    callback();
                }
                
            }
            
        }
        
    }];
    
}

+(void) loginWithEmailAddress: (NSString *)email andPassword: (NSString *)password withCallback: (void(^)(void))callback{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"email_address"] = email;
    params[@"password"] = password;
    params[@"type"] = @"login";
    
    [Utils showSpinner];
    
    [Utils apiPOSTWithDictionary:params withCallback:^(BOOL success, NSDictionary *object) {
        
        [Utils hideSpinner];
        
        if(success){
            
            if([[object valueForKey:@"error"] boolValue]){
                
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Problem" message:@"Your email address and password do not match anyone in our database. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [errorAlert show];
                
            }else{
                
                NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
                [standardDefaults setValue:[object valueForKey:@"memberid"] forKey:@"memberId"];
                [standardDefaults setValue:[object valueForKey:@"name"] forKey:@"memberName"];
                [standardDefaults synchronize];
                
                if(callback){
                    callback();
                }
                
            }
            
        }
        
    }];
    
}

//--- 2: Share/Drop Card to/on a member
+(void) shareCard: (CDCard *)card withMember: (NSString *)memberId callback: (void(^)(void))callback{
    
    if([card cardID]){
    
        [Utils showSpinner];
        
        //--- Get geo coordinates from coreLocation
        Utils *utilsClass = [[Utils alloc] init];
        CLLocationCoordinate2D geoCoordinates = [utilsClass getLocation];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[@"type"] = @"2";
        params[@"card_id"] = [card cardID];
        params[@"member_id"] = memberId;
        params[@"latitude"] = [NSString stringWithFormat:@"%f", geoCoordinates.latitude];
        params[@"longitude"] = [NSString stringWithFormat:@"%f", geoCoordinates.longitude];
        
        [Utils apiPOSTWithDictionary:params withCallback:^(BOOL success, NSDictionary *object){
            
            if(success){
                
                [Utils hideSpinner];
                callback();
                
            }
            
        }];
        
    }
    
}

//--- 3: Return Sorrounding Members
+(void) queryMemberInfo: (NSArray *)memberIDArray withCallback: (void(^)(NSDictionary *queryObject))callback{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"type"] = @"3";
    params[@"memberids"] = memberIDArray;
    
    [self apiPOSTWithDictionary:params withCallback:^(BOOL success, NSDictionary *object) {
        
        if(success){
            callback(object);
        }
        
    }];
    
}

//--- 4: Save New Card
+(void) saveCard: (CDCard *) cardObject withCallback: (void(^)(NSString *cardId))callback{
    
    [Utils showSpinner];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"type"] = @"4";
    params[@"member_id"] = [Utils currentMember];
    params[@"cardFirstname"] = [cardObject cardFirstname];
    params[@"cardLastname"] = [cardObject cardLastname];
    params[@"cardPrefix"] = [cardObject cardPrefix];
    params[@"cardSuffix"] = [cardObject cardSuffix];
    params[@"cardTitle"] = [cardObject cardTitle];
    params[@"cardCompany"] = [cardObject cardCompany];
    params[@"cardPhonework"] = [cardObject cardPhonework];
    params[@"cardPhoneother"] = [cardObject cardPhoneother];
    params[@"cardPhonecell"] = [cardObject cardPhonecell];
    params[@"cardEmailwork"] = [cardObject cardEmailwork];
    params[@"cardEmailother"] = [cardObject cardEmailother];
    params[@"cardEmailhome"] = [cardObject cardEmailhome];
    params[@"cardLinkedIn"] = [cardObject cardLinkedIn];
    params[@"cardFacebook"] = [cardObject cardFacebook];
    params[@"cardTwitter"] = [cardObject cardTwitter];
    params[@"cardInstagram"] = [cardObject cardInstagram];
    
    NSLog(@"Save card params %@", params);
    
    [Utils apiPOSTWithDictionary:params withCallback:^(BOOL success, NSDictionary *object) {
        
        [Utils hideSpinner];
        
        if(success){
            
            NSString *cardID = [object valueForKey:@"cardId"];
            
            [cardObject setCardID:cardID];
            [[cardObject managedObjectContext] save:Nil];
            
            if(callback){
                callback(cardID);
            }
            
        }
        
    }];
    
}

//--- 5: Check for pending shares
+(void) checkPendingShares: (void(^)(NSMutableDictionary *object, int totalPendingShares, NSArray *pendingSharesObject))callback{
    
    if([Utils currentMember]){
    
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        params[@"type"] = @"pending_shares";
        params[@"member_id"] = [Utils currentMember];
        
        [Utils apiPOSTWithDictionary:params withCallback:^(BOOL success, NSDictionary *object) {
            
            NSArray *pendingRequests = [object objectForKey:@"pending_requests"];
            NSMutableDictionary *currentPendingRequest = Nil;
            
            if([pendingRequests count] > 0){
                
                for(NSDictionary *object in pendingRequests){
                    if([[object valueForKey:@"status"] isEqualToString:@"1"]){
                        currentPendingRequest = [object mutableCopy];
                        break;
                    }
                }
                
            }
            
            callback(currentPendingRequest, [[object valueForKey:@"total_pending_requests"] intValue], (NSArray *)[object objectForKey:@"pending_requests"]);
            
        }];
        
    }
    
}

//--- 0: ignored, 1: pending, 2: accepted, 3:rejected
+(void) changeNotificationStatus: (CDMeets *)meetObject withStatus: (meetAction)status withCallback: (void(^)(void))callback{
    
    NSString *meetId = [meetObject meet_id];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"type"] = @"6";
    params[@"meet_id"] = meetId;
    
    switch(status){
            
        case meetActionAccepted:
            params[@"status"] = @"2";
            break;
            
        case meetActionRejected:
            params[@"status"] = @"3";
            break;
            
        case meetActionIgnored:
            params[@"status"] = @"0";
            break;
            
    }
    
    [Utils apiPOSTWithDictionary:params withCallback:^(BOOL success, NSDictionary *object) {
        
        //--- Set the status of the meetObject
        //--- Get Object Context
        
        if(status == meetActionIgnored && [[meetObject status] isEqualToString:@"0"]){
         
            NSLog(@"No need to ignore again!");
            
        }else{
        
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
            
            [meetObject setStatus:[params valueForKey:@"status"]];
            
            [managedObjectContext save:Nil];
            
            //--- Insert object into addressbook
            ABContact *person = [ABContact contact];
            person.firstname = [meetObject cardFirstname];
            person.lastname = [meetObject cardLastname];
            person.organization = [meetObject cardCompany];
            person.jobtitle = [meetObject cardTitle];
            
            //--- Set all phone numbers
            person.phoneDictionaries = [NSMutableArray arrayWithObjects:
                                      [ABContact dictionaryWithValue:[meetObject cardPhonework] andLabel:kABPersonPhoneMainLabel],
                                      [ABContact dictionaryWithValue:[meetObject cardPhonecell] andLabel:kABPersonPhoneIPhoneLabel],
                                      [ABContact dictionaryWithValue:[meetObject cardPhoneother] andLabel:kABPersonPhoneMobileLabel],
                                      nil];
            
            //--- Set all email addresses
            person.emailDictionaries = [NSMutableArray arrayWithObjects:
                                      [ABContact dictionaryWithValue:[meetObject cardEmailwork] andLabel:kABWorkLabel],
                                      [ABContact dictionaryWithValue:[meetObject cardEmailhome] andLabel:kABHomeLabel],
                                      [ABContact dictionaryWithValue:[meetObject cardEmailother] andLabel:kABOtherLabel],
                                      nil];
            
            //--- Add Image
            person.image = [UIImage imageWithData:[meetObject cardImage]];
            
            person.note = @"This contact was added via the REON app";
            
            NSError *contactAddError;
            NSError *standingError;
            
            [ABContactsHelper addContact:person withError:&contactAddError];
            
            if(contactAddError){
                
                NSLog(@"Contact add error: %@", contactAddError);
                
            }else{
           
                [ABStandin save:&standingError];
                
                if(standingError){
                    
                    NSLog(@"Standin Error %@", standingError);
                    
                }
                
            }
            
        }
        
        //--- Custom Callback
        if(callback){
            callback();
        }
        
    }];
    
}

//--- *** Standard POST Object *** ---//
//--- *** Most Like this won't be called directly, but it's available if needed *** --- //

+(void) apiPOSTWithDictionary: (NSDictionary *)postObject withCallback: (void(^)(BOOL success, NSDictionary *object))callback{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:apiEndpoint parameters:postObject success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        callback(YES, responseObject);
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        callback(NO, Nil);
        
        NSLog(@"\n\nFailure Response Body for type: %@: %@", [postObject valueForKey:@"type"], operation.responseString);
        
        //--- Show alert
        NSLog(@"HTTP ERROR: %@", error.localizedDescription);
    
    }];
    
}

+(void) apiPOSTWithDictionary: (NSDictionary *)postObject andImage: (NSData *)imageData andImageName: (NSString *)imageName withCallback: (void(^)(BOOL success, NSDictionary *object))callback
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:apiEndpoint parameters:postObject constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if(imageData){
        
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@", imageName] fileName:[NSString stringWithFormat:@"%@.png", imageName] mimeType:@"image/png"];
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        callback(YES, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        callback(NO, Nil);
        
        NSLog(@"\n\nFailure Response Body for type: %@: %@", [postObject valueForKey:@"type"], operation.responseString);
        
        //--- Show alert
//        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"HTTP Error" message:error.localizedDescription delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        
//        [errorAlert show];
        
    }];
    
}

#pragma mark Spinner Singleton

+(DSXActivityIndicator *)sharedSpinner{
    
    static DSXActivityIndicator *spinner = Nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        spinner = [[DSXActivityIndicator alloc] init];
    });
    
    return spinner;
    
}

+(void)showSpinner{
    
    UIView *view = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    DSXActivityIndicator *spinner = [Utils sharedSpinner];
    
    float middleLeft = (view.frame.size.width/2) - (spinner.frame.size.width/2);
    float middleTop = (view.frame.size.height/2) - (spinner.frame.size.height/2);
    
    [spinner setFrame:CGRectMake(middleLeft, middleTop, spinner.frame.size.width, spinner.frame.size.height)];
    
    [spinner startAnimating];
    
    [view addSubview:spinner];
        
}

+(void)hideSpinner{
    
    DSXActivityIndicator *spinner = [Utils sharedSpinner];
    [spinner stopAnimating];
    
    [spinner removeFromSuperview];
    
}


-(CLLocationCoordinate2D) getLocation{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
    
}

+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

+(UIImage *) screenshotFromUIImageView: (UIImageView *)imgView{
    
    UIGraphicsBeginImageContext(imgView.frame.size);
    [[imgView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
    
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate{
    
    if ([date compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day isEndOfDay: (BOOL)eod{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    if(eod == YES){
        
        [components setHour:23];
        [components setMinute:59];
        [components setSecond:59];
        
    }else{
        
        [components setHour:01];
        [components setMinute:0];
        [components setSecond:0];
    
    }
    
    return [calendar dateFromComponents:components];

}

+ (NSDate *) lastDayOfMonth: (int)month inYear: (int)year{
    
    NSDate *curDate = [Utils dateWithYear:year month:month day:1 isEndOfDay:NO];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange = [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:curDate];
    
    return [Utils dateWithYear:year month:month day:daysRange.length isEndOfDay:YES];
    
}

+ (NSDate *) firstDayOfMonth: (int)month inYear: (int)year{
    return [Utils dateWithYear:year month:month day:1 isEndOfDay:NO];
}

@end
