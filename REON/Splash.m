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

@interface Splash ()

@end

@implementation Splash

- (IBAction)facebookLogin:(id)sender {
    
    //--- Session active, close it first, then re-open
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    //--- Request a new session
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"publish_actions", @"user_friends"] allowLoginUI:YES completionHandler:^(FBSession *se, FBSessionState st, NSError *er) {
        
        if(st == FBSessionStateOpen || st == FBSessionStateOpenTokenExtended){
            
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                
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
                    [Utils hideSpinner];
                    [AppDelegate determineRootViewController];
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

@end
