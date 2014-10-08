//
//  ReonSettings.m
//  REON
//
//  Created by Chad McElwain on 9/16/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "ReonSettings.h"
#import "AppDelegate.h"
#import "Utils.h"
#import <FacebookSDK.h>
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "Card.h"
#import "CDUserInfo.h"

#define LINKEDIN_ID           @"75500hgkoaywpp"
#define LINKEDIN_SECRETID     @"V76q0R9EERum7ejs"

@interface ReonSettings ()
{
    NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, strong) LIALinkedInHttpClient *client;
@property (nonatomic, strong) CDCard *cardObject;
@property (nonatomic, strong) CDUserInfo *UserinfoObject;

@property (strong, nonatomic) IBOutlet UITextField *UserFirsNameText;
@property (strong, nonatomic) IBOutlet UITextField *UserLastNameText;
@property (strong, nonatomic) IBOutlet UITextField *UserEmailText;
@property (strong, nonatomic) IBOutlet UITextField *UserPhoneText;
@property (strong, nonatomic) CDUserInfo *UserObject;
@end

@implementation ReonSettings

@synthesize UserEmailText,UserFirsNameText,UserLastNameText,UserPhoneText;
@synthesize Userimage,cardObject,UserinfoObject,client;
@synthesize UserObject;
@synthesize FacebookSwitch,LinkedinSwitch,TiwtterSwitch,InstagramSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self UserFirsNameText]setDelegate:self];
    [[self UserLastNameText]setDelegate:self];
    [[self UserEmailText]setDelegate:self];
    [[self UserPhoneText]setDelegate:self];
    
    [self.FacebookSwitch setOn:NO];
    [self.LinkedinSwitch setOn:NO];
    [self.TiwtterSwitch setOn:NO];
    [self.InstagramSwitch setOn:NO];
   
    activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(55, 106, 30, 30)];
    [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityindicator1 setColor:[UIColor grayColor]];
    [self.view addSubview:activityindicator1];
    [activityindicator1 startAnimating];
    [self performSelector:@selector(ImageGet) withObject:activityindicator1 afterDelay:0.1];

   
    
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.expertcyber.net" clientId:LINKEDIN_ID clientSecret:LINKEDIN_SECRETID state:@"DCEEFWF45453sdffef424" grantedAccess:@[@"r_fullprofile",@"r_emailaddress",@"r_network",@"r_contactinfo", @"rw_nus"]];
    self.client = [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];

   
    [self.FacebookSwitch addTarget:self
                      action:@selector(FacebookSwitchIsChanged:)
            forControlEvents:UIControlEventValueChanged];
    
    [self.LinkedinSwitch addTarget:self
                            action:@selector(LinkedinSwitchIsChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    AppDelegate*  appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    managedObjectContext = [appDelegate managedObjectContext];
    
   
    //--- Build Request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *cards = [NSEntityDescription entityForName:@"CDUserInfo" inManagedObjectContext:managedObjectContext];
    [request setEntity:cards];
    
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:Nil] mutableCopy];
    
    if([mutableFetchResults count] > 0){
        UserObject = [mutableFetchResults objectAtIndex:0];
    }
    if(UserObject){
        
        
        //--- Populate form fields
        [UserFirsNameText setText:[UserObject first_name]];
        [UserLastNameText setText:[UserObject last_name]];
        [UserEmailText setText:[UserObject rEmail]];
        [UserPhoneText setText:[UserObject phoneNumber]];
      
        if([UserObject rFacebookID])
        {
            [self.FacebookSwitch setOn:YES];
            [self.FacebookSwitch setUserInteractionEnabled:NO];
           
        }
        else if ([UserObject rLinkedInID])
        {
            [self.LinkedinSwitch setOn:YES];
            [self.LinkedinSwitch setUserInteractionEnabled:NO];
        }
        
    }
   
}
-(void)ImageGet
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imageURL=[NSString stringWithFormat:@"http://api.reon.social/img/users/%@.png",[Utils currentMember]];
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[Utils currentMember]]];
    if(image != NULL)
    {
        //Store the image in Document
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile: imagePath atomically:NO];
        
    }
    NSArray *arrayPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* FileName = [path stringByAppendingPathComponent:[UserObject rImage]];
    UIImage *image1=[UIImage imageWithContentsOfFile:FileName];
    Userimage.image=image1;
    [activityindicator1 stopAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
- (IBAction)LogOut:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:Nil forKey:@"memberId"];
    [AppDelegate determineRootViewController];
    
}
*/

- (IBAction)uploadPhotoFromButton:(id)sender {
    [self showUploadPhotoOptions];
}

-(void)showUploadPhotoOptions{
   
    UIActionSheet *uploadPhotoAS = [[UIActionSheet alloc] initWithTitle:@"Upload A Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles:@"Upload From Camera Roll", @"Take A New Photo", nil];
    
    [uploadPhotoAS showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex != 2){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setDelegate:self];
        [imagePicker setAllowsEditing:YES];
        
        if(buttonIndex==1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        [self presentViewController:imagePicker animated:YES completion:Nil];
        
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
    //--- Save larger version
    profileImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [profileImage resizedImageToSize:CGSizeMake(345.0, 345.0)];
    
    maskedProfileImage = [Utils maskImage:profileImage withMask:[UIImage imageNamed:@"circle_mask.jpg"]];
    
    largeProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 345.0, 345.0)];
    largeProfileImage.image = maskedProfileImage;
    largeProfileImage.backgroundColor = [UIColor whiteColor];
    UIImage *paramsProfileImage;
    
    if(maskedProfileImage){
        paramsProfileImage = [Utils screenshotFromUIImageView:largeProfileImage];
    }

    Userimage.image = maskedProfileImage;
    Userimage.contentMode = UIViewContentModeScaleAspectFill;
    NSData *imagen=UIImagePNGRepresentation(paramsProfileImage);
    [Utils showSpinner];
    NSLog(@" user Id: %@", [Utils currentMember]);
    [Utils UpdateProfileImageWithDictionaryParams:[Utils currentMember] profileImageData:imagen setCallback:^{
        NSLog(@"check");
    }];
    [Utils hideSpinner];
}
- (void) FacebookSwitchIsChanged:(UISwitch *)paramSender{
    
    if ([paramSender isOn])
    {
        
        NSLog(@"The switch is turned on.");
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
                    UIImage *profileImage1 = [[UIImage alloc] initWithData:imgData];
                    
                    //--- Resize Image
                    [profileImage1 resizedImageToSize:CGSizeMake(345.0, 345.0)];
                    
                    UIImage *maskedProfileImage1 = [Utils maskImage:profileImage withMask:[UIImage imageNamed:@"circle_mask.jpg"]];
                    
                    UIImageView *largeProfileImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 345.0, 345.0)];
                    largeProfileImage1.image = maskedProfileImage1;
                    largeProfileImage1.backgroundColor = [UIColor whiteColor];
                    largeProfileImage1.contentMode = UIViewContentModeScaleAspectFill;
                    
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
                        
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *imageURL=[NSString stringWithFormat:@"http://api.reon.social/img/users/%@.png",[Utils currentMember]];
                        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[Utils currentMember]]];
                        if(image != NULL)
                        {
                            //Store the image in Document
                            NSData *imageData = UIImagePNGRepresentation(image);
                            [imageData writeToFile: imagePath atomically:NO];
                            
                        }
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
    else
    {
         NSLog(@"The switch is turned off.");
    }
    
}

- (void) LinkedinSwitchIsChanged:(UISwitch *)paramSender{
    
    if ([paramSender isOn])
    {
        
        NSLog(@"The switch is turned on.");
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
    else
    {
        NSLog(@"The switch is turned off.");
    }
    
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
         UIImage *profileImage1 = [[UIImage alloc] initWithData:imgData];
         
         //--- Resize Image
         [profileImage1 resizedImageToSize:CGSizeMake(345.0, 345.0)];
         
         UIImage *maskedProfileImage1 = [Utils maskImage:profileImage withMask:[UIImage imageNamed:@"circle_mask.jpg"]];
         
         UIImageView *largeProfileImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 345.0, 345.0)];
         largeProfileImage1.image = maskedProfileImage1;
         largeProfileImage1.backgroundColor = [UIColor whiteColor];
         largeProfileImage1.contentMode = UIViewContentModeScaleAspectFill;
         
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
             [cards setCardLinkedIn:@""];
             [cards setCardFacebook:FirstName];
             [cards setCardTwitter:@""];
             [cards setCardInstagram:@""];
             
             //--- Card notes
             
             [managedObjectContent save:Nil];
             
             [Utils saveCard:cards withCallback:Nil];
             [Utils hideSpinner];
             [AppDelegate determineRootViewController];
             
             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             NSString *imageURL=[NSString stringWithFormat:@"http://api.reon.social/img/users/%@.png",[Utils currentMember]];
             NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
             UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
             NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[Utils currentMember]]];
             if(image != NULL)
             {
                 //Store the image in Document
                 NSData *imageData = UIImagePNGRepresentation(image);
                 [imageData writeToFile: imagePath atomically:NO];
                 
             }
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
             [userinfo setRLinkedInID:@""];
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

#pragma mark - UITextField Delegate


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


@end
