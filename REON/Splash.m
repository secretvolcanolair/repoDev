//
//  Splash.m
//  REON
//
//  Created by Robert Kehoe on 8/11/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "Splash.h"
#import "RegistrationController.h"
#import <FacebookSDK.h>
#import "AppDelegate.h"
#import "Utils.h"
#import <UIImage+Resize.h>
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "Card.h"
#import "CDUserInfo.h"


#define LINKEDIN_CLIENT_ID          @"75500hgkoaywpp"
#define LINKEDIN_CLIENT_SECRET     @"V76q0R9EERum7ejs"

@interface Splash ()
@property (nonatomic, strong) LIALinkedInHttpClient *client;
@property (nonatomic, strong) CDCard *cardObject;
@property (nonatomic, strong) CDUserInfo *UserinfoObject;
@end

@implementation Splash
@synthesize cardObject,UserinfoObject;

- (IBAction)facebookLogin:(id)sender {
    
    //--- Session active, close it first, then re-open
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    //--- Request a new session
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"publish_actions", @"user_friends"] allowLoginUI:YES completionHandler:^(FBSession *se, FBSessionState st, NSError *er) {
        
        if(st == FBSessionStateOpen || st == FBSessionStateOpenTokenExtended){
            
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                NSLog(@"fb details %@",user);
                //--- All the data retuned from Facebook
                NSString *firstName = [user first_name];
                NSString *middleName = [user middle_name];
                NSString *lastName = [user last_name];
                NSString *username = [user username];
                NSString *emailAddress = [user valueForKey:@"email"];
                NSString *profileImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectID]];
                NSString *facebookID = [user objectID];
                NSString *facebookToken = [[[FBSession activeSession] accessTokenData] accessToken];
                NSString *street = [[[user location] location] street];
                NSString *city = [[[user location] location] city];
                NSString *state = [[[user location] location] state];
                NSString *country = [[[user location] location] country];
                NSString *zip = [[[user location] location] zip];
                NSString *lat = [NSString stringWithFormat:@"%@", [[[user location] location] longitude]];
                NSString *lon = [NSString stringWithFormat:@"%@", [[[user location] location] latitude]];
                NSString *link = [user link];
                NSString *birthday = [user birthday];
                
                //--- Check if user is registered already
                NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] init];
                [mutableParams setValue:firstName forKey:@"first_name"];
                [mutableParams setValue:lastName forKey:@"last_name"];
                [mutableParams setValue:emailAddress forKey:@"email_address"];
                [mutableParams setValue:facebookID forKey:@"facebook_id"];
                [mutableParams setValue:facebookToken forKey:@"facebook_token"];
                
                //--- Addition Params.
                [mutableParams setValue:middleName forKey:@"middle_name"];
                [mutableParams setValue:username forKey:@"username"];
                [mutableParams setValue:street forKey:@"street"];
                [mutableParams setValue:city forKey:@"city"];
                [mutableParams setValue:state forKey:@"state"];
                [mutableParams setValue:zip forKey:@"zip"];
                [mutableParams setValue:country forKey:@"country"];
                [mutableParams setValue:lat forKey:@"lat"];
                [mutableParams setValue:lon forKey:@"lon"];
                [mutableParams setValue:link forKey:@"link"];
                [mutableParams setValue:birthday forKey:@"birthday"];
                
                [Utils showSpinner];
                
                ///--- Convert image URL to NSData
                NSURL *url = [NSURL URLWithString:profileImageURL];
                NSData *imgData = [[NSData alloc] initWithContentsOfURL:url];
                UIImage *profileImage = [[UIImage alloc] initWithData:imgData];
                
                //--- Resize Image
                [profileImage resizedImageToSize:CGSizeMake(345.0, 345.0)];
                
                UIImage *maskedProfileImage = [Utils maskImage:profileImage withMask:[UIImage imageNamed:@"circle_mask.jpg"]];
                
                UIImageView *largeProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 345.0, 345.0)];
                largeProfileImage.image = maskedProfileImage;
                largeProfileImage.backgroundColor = [UIColor whiteColor];
                largeProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                
                //--- UIIMage
                UIImage *paramsProfileImage;
                
                if(maskedProfileImage){
                    paramsProfileImage = [Utils screenshotFromUIImageView:largeProfileImage];
                }
                
                //--- Register User via API
                [Utils connectFacebookUserWithDictionaryParams:mutableParams profileImageData:UIImagePNGRepresentation(paramsProfileImage) setCallback:^{
                
                      
                    AppDelegate*  applicationDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
                    
                    NSManagedObjectContext *managedObjectContent = [applicationDelegate managedObjectContext];
                    
                    CDCard *cards;
                    
                    if(cardObject){
                        cards = cardObject;
                    }else{
                        cards = [NSEntityDescription insertNewObjectForEntityForName:@"CDCard" inManagedObjectContext:managedObjectContent];
                    }
                    
                    [cards setCardLabel:@"FB"];
                    
                    [cards setCardSuffix:@""];
                    [cards setCardPrefix:@""];
                    [cards setCardFirstname:firstName];
                    [cards setCardLastname:lastName];
                    [cards setCardPhonecell:@""];
                    [cards setCardPhonework:@""];
                    [cards setCardPhoneother:@""];
                    [cards setCardEmailhome:emailAddress];
                    [cards setCardEmailother:@""];
                    [cards setCardEmailwork:@""];
                    [cards setCardTitle:@""];
                    [cards setCardCompany:@""];
                    
                    //--- Social network values
                    [cards setCardLinkedIn:@""];
                    [cards setCardFacebook:link];
                    [cards setCardTwitter:@""];
                    [cards setCardInstagram:@""];
                    
                    //--- Card notes
                    
                    [managedObjectContent save:Nil];
                    
                    [Utils saveCard:cards withCallback:Nil];
                    [Utils hideSpinner];
                    [AppDelegate determineRootViewController];
                    
                   NSManagedObjectContext *usermanagedObjectContent = [applicationDelegate managedObjectContext];
                    
                    CDUserInfo *userinfo;
                    
                    if(UserinfoObject){
                        userinfo = UserinfoObject;
                    }else{
                        userinfo = [NSEntityDescription insertNewObjectForEntityForName:@"CDUserInfo" inManagedObjectContext:usermanagedObjectContent];
                    }
                    
                     [userinfo setREmail:emailAddress];
                     [userinfo setRFacebookID:facebookID];
                     [userinfo setRFacebookToken:facebookToken];
                     [userinfo setRImage:[NSString stringWithFormat:@"%@.png",[Utils currentMember]]];
                     [userinfo setRLinkedInID:@""];
                     [userinfo setRLinkedInToken:@""];
                     [userinfo setRName:username];
                     [userinfo setRPwd:@""];
                     [userinfo setRSalesForce:@""];
                     [userinfo setState:state];
                     [userinfo setStreet:street];
                     [userinfo setZip:zip];
                     [userinfo setCity:city];
                     [userinfo setCountry:country];
                     [userinfo setRFBusername:username];
                     [userinfo setFirst_name:firstName];
                     [userinfo setMiddle_name:lastName];
                     [userinfo setLink:link];
                     [userinfo setLast_name:lastName];
                     [userinfo setLat:lat];
                     [userinfo setLon:lon];
                     [userinfo setBirthday:birthday];
                     [userinfo setPhoneNumber:@""];
                    
                    [usermanagedObjectContent save:Nil];
                    NSError *error;
                    if (![usermanagedObjectContent save:&error]) {
                        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    }
                    
                    
                   

                    
                }];
                
            }];
            
        }else{
            
            //--- FB Error login
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Problem..." message:@"There was an issue connecting to your Facebook. Try registering via Email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [error show];
            
        }
        
    }];
    
}

- (IBAction)emailLogin:(id)sender {
    RegistrationController *registerViewController = [[RegistrationController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.expertcyber.net" clientId:LINKEDIN_CLIENT_ID clientSecret:LINKEDIN_CLIENT_SECRET state:@"DCEEFWF45453sdffef424" grantedAccess:@[@"r_fullprofile",@"r_emailaddress",@"r_network",@"r_contactinfo", @"rw_nus"]];
    self.client = [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
    
    
}

- (IBAction) linkedInClicked:(id)sender { // Login into the account
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}



- (void)requestMeWithToken:(NSString *)accessToken {
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,email-address)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
     {
         
         NSLog(@"current user %@", result);
         
         NSString *FirstName = [result valueForKey:@"firstName"];
         NSString *LastName = [result valueForKey:@"lastName"];
         NSString *LinkedinID=[result valueForKey:@"id"];
         NSString *EmailID=[result valueForKey:@"emailAddress"];
         
         
         NSString *profileImageURL;
         //--- Check if user is registered already
         
         NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] init];
         [mutableParams setValue:FirstName forKey:@"first_name"];
         [mutableParams setValue:LastName forKey:@"last_name"];
         [mutableParams setValue:accessToken forKey:@"linkedin_token"];
         [mutableParams setValue:LinkedinID forKey:@"linkedin_id"];
         [mutableParams setValue:EmailID forKey:@"email_address"];
         [Utils showSpinner];
         
         ///--- Convert image URL to NSData
         NSURL *url = [NSURL URLWithString:profileImageURL];
         NSData *imgData = [[NSData alloc] initWithContentsOfURL:url];
         UIImage *profileImage = [[UIImage alloc] initWithData:imgData];
         
         //--- Resize Image
         [profileImage resizedImageToSize:CGSizeMake(345.0, 345.0)];
         
         UIImage *maskedProfileImage = [Utils maskImage:profileImage withMask:[UIImage imageNamed:@"circle_mask.jpg"]];
         
         UIImageView *largeProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 345.0, 345.0)];
         largeProfileImage.image = maskedProfileImage;
         largeProfileImage.backgroundColor = [UIColor whiteColor];
         largeProfileImage.contentMode = UIViewContentModeScaleAspectFill;
         
         //--- UIIMage
         UIImage *paramsProfileImage;
         
         if(maskedProfileImage){
             paramsProfileImage = [Utils screenshotFromUIImageView:largeProfileImage];
         }
         
         //--- Register User via API
         
         [Utils connectLinkedinUserWithDictionaryParams:mutableParams profileImageData:UIImagePNGRepresentation(paramsProfileImage) setCallback:^{
             [Utils hideSpinner];
             [AppDelegate determineRootViewController];
             
             AppDelegate*  applicationDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
             
             NSManagedObjectContext *managedObjectContent = [applicationDelegate managedObjectContext];
             
             CDCard *cards;
             
             if(cardObject){
                 cards = cardObject;
             }else{
                 cards = [NSEntityDescription insertNewObjectForEntityForName:@"CDCard" inManagedObjectContext:managedObjectContent];
             }
             
             [cards setCardLabel:@"Linkedin"];
             
             [cards setCardSuffix:@""];
             [cards setCardPrefix:@""];
             [cards setCardFirstname:FirstName];
             [cards setCardLastname:LastName];
             [cards setCardPhonecell:@""];
             [cards setCardPhonework:@""];
             [cards setCardPhoneother:@""];
             [cards setCardEmailhome:@""];
             [cards setCardEmailother:EmailID];
             [cards setCardEmailwork:@""];
             [cards setCardTitle:@""];
             [cards setCardCompany:@""];
             
             //--- Social network values
             [cards setCardLinkedIn:FirstName];
             [cards setCardFacebook:@""];
             [cards setCardTwitter:@""];
             [cards setCardInstagram:@""];
             
             //--- Card notes
             
             [managedObjectContent save:Nil];
             
             [Utils saveCard:cards withCallback:Nil];
             [Utils hideSpinner];
             [AppDelegate determineRootViewController];
           
             NSManagedObjectContext *usermanagedObjectContent = [applicationDelegate managedObjectContext];
             
             CDUserInfo *userinfo;
             
             if(UserinfoObject){
                 userinfo = UserinfoObject;
             }else{
                 userinfo = [NSEntityDescription insertNewObjectForEntityForName:@"CDUserInfo" inManagedObjectContext:usermanagedObjectContent];
             }
             
             [userinfo setREmail:EmailID];
             [userinfo setRFacebookID:@""];
             [userinfo setRFacebookToken:@""];
             [userinfo setRImage:[NSString stringWithFormat:@"%@.png",[Utils currentMember]]];
             [userinfo setRLinkedInID:LinkedinID];
             [userinfo setRLinkedInToken:@""];
             [userinfo setRName:FirstName];
             [userinfo setRPwd:@""];
             [userinfo setRSalesForce:@""];
             [userinfo setState:@""];
             [userinfo setStreet:@""];
             [userinfo setZip:@""];
             [userinfo setCity:@""];
             [userinfo setCountry:@""];
             [userinfo setRFBusername:FirstName];
             [userinfo setFirst_name:FirstName];
             [userinfo setMiddle_name:@""];
             [userinfo setLink:@""];
             [userinfo setLast_name:LastName];
             [userinfo setLat:@""];
             [userinfo setLon:@""];
             [userinfo setBirthday:@""];
             [userinfo setPhoneNumber:@""];
             
             [usermanagedObjectContent save:Nil];
             NSError *error;
             if (![usermanagedObjectContent save:&error]) {
                 NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
             }
             
             
         }];
         
         
         
     }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"failed to fetch current user %@", error);
     }];
}

@end
