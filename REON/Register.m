//
//  Register.m
//  SnapAHottie
//
//  Created by Robert Kehoe on 4/6/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "AppDelegate.h"
#import "Register.h"
#import "Utils.h"
#import "Card.h"
#import "CDUserInfo.h"

@interface Register () 
@property (nonatomic, strong) CDCard *cardObject;
@property (nonatomic, strong) CDUserInfo *UserinfoObject;
@end

@implementation Register

@synthesize parentViewController;

@synthesize profileImageView;
@synthesize uploadPhotoButton;

@synthesize firstNameField;
@synthesize lastNameField;
@synthesize emailField;
@synthesize passwordField;
@synthesize delegate;
@synthesize cardObject;
@synthesize UserinfoObject;

- (id)init{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"Register" owner:self options:Nil] objectAtIndex:1];
    
    [firstNameField setDelegate:self];
    [lastNameField setDelegate:self];
    [emailField setDelegate:self];
    [passwordField setDelegate:self];
    
    isEditing = NO;
    
    return self;

}

- (IBAction)uploadPhotoFromButton:(id)sender {
    [self showUploadPhotoOptions];
}

-(void)showUploadPhotoOptions{
    
    [self endEditing:YES];
    [delegate registerIsFinishedEditing];
    
    UIActionSheet *uploadPhotoAS = [[UIActionSheet alloc] initWithTitle:@"Upload A Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles:@"Upload From Camera Roll", @"Take A New Photo", nil];
    
    [uploadPhotoAS showInView:self];
    
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
        
        [parentViewController presentViewController:imagePicker animated:YES completion:Nil];
        
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [parentViewController dismissViewControllerAnimated:YES completion:Nil];
    
    [uploadPhotoButton setTitle:@"Change Profile Image" forState:UIControlStateNormal];
    
    //--- Save larger version
    profileImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [profileImage resizedImageToSize:CGSizeMake(345.0, 345.0)];
    
    maskedProfileImage = [Utils maskImage:profileImage withMask:[UIImage imageNamed:@"circle_mask.jpg"]];
    
    largeProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 345.0, 345.0)];
    largeProfileImage.image = maskedProfileImage;
    largeProfileImage.backgroundColor = [UIColor whiteColor];
    
    profileImageView.image = maskedProfileImage;
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (IBAction)continueAction:(id)sender {
    
    //--- Check for errors
    NSString *alertMessage;
    
    if([firstNameField.text isEqualToString:@""]){
        alertMessage = @"Please enter your first name";
    }
    
    else if([lastNameField.text isEqualToString:@""]){
        alertMessage = @"Please enter your last name";
    }
    
    else if([emailField.text isEqualToString:@""]){
        alertMessage = @"Please enter your email address";
    }
    
    else if([passwordField.text isEqualToString:@""]){
        alertMessage = @"Please choose a password";
    }
    
    else if (profileImageView.image == nil){
        alertMessage = @"Please choose an image";
    }
    
    //--- Display errors or continue
    if(alertMessage){
        
        UIAlertView *errorAV = [[UIAlertView alloc] initWithTitle:@"Error" message:alertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAV show];
        
    }else{
        
        [firstNameField resignFirstResponder];
        [lastNameField resignFirstResponder];
        [emailField resignFirstResponder];
        [passwordField resignFirstResponder];
        
        [delegate registerIsFinishedEditing];
       //--- Check if user is registered already
        NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] init];
        [mutableParams setValue:firstNameField.text forKey:@"first_name"];
        [mutableParams setValue:lastNameField.text forKey:@"last_name"];
        [mutableParams setValue:emailField.text forKey:@"email_address"];
        [mutableParams setValue:passwordField.text forKey:@"password"];
        
        [Utils showSpinner];
        
        UIImage *paramsProfileImage;
        
        if(maskedProfileImage){
            paramsProfileImage = [Utils screenshotFromUIImageView:largeProfileImage];
        }
        
        [Utils registerNewUserWithDictionaryParams:mutableParams profileImageData:UIImagePNGRepresentation(paramsProfileImage) setCallback:^{
            AppDelegate*  applicationDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
            
            NSManagedObjectContext *managedObjectContent = [applicationDelegate managedObjectContext];
            
            CDCard *cards;
            
            if(cardObject){
                cards = cardObject;
            }else{
                cards = [NSEntityDescription insertNewObjectForEntityForName:@"CDCard" inManagedObjectContext:managedObjectContent];
            }
            
            [cards setCardLabel:@"Email"];
            
            [cards setCardSuffix:@""];
            [cards setCardPrefix:@""];
            [cards setCardFirstname:firstNameField.text];
            [cards setCardLastname:lastNameField.text];
            [cards setCardPhonecell:@""];
            [cards setCardPhonework:@""];
            [cards setCardPhoneother:@""];
            [cards setCardEmailhome:emailField.text];
            [cards setCardEmailother:@""];
            [cards setCardEmailwork:@""];
            [cards setCardTitle:@""];
            [cards setCardCompany:@""];
            
            //--- Social network values
            [cards setCardLinkedIn:@""];
            [cards setCardFacebook:@""];
            [cards setCardTwitter:@""];
            [cards setCardInstagram:@""];
            
            //--- Card notes
            
            [managedObjectContent save:Nil];
            
            [Utils saveCard:cards withCallback:Nil];
            
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
            
            [userinfo setREmail:emailField.text];
            [userinfo setRFacebookID:@""];
            [userinfo setRFacebookToken:@""];
            [userinfo setRImage:[NSString stringWithFormat:@"%@.png",[Utils currentMember]]];
            [userinfo setRLinkedInID:@""];
            [userinfo setRLinkedInToken:@""];
            [userinfo setRName:@""];
            [userinfo setRPwd:@""];
            [userinfo setRSalesForce:@""];
            [userinfo setState:@""];
            [userinfo setStreet:@""];
            [userinfo setZip:@""];
            [userinfo setCity:@""];
            [userinfo setCountry:@""];
            [userinfo setRFBusername:@""];
            [userinfo setFirst_name:firstNameField.text];
            [userinfo setMiddle_name:@""];
            [userinfo setLink:@""];
            [userinfo setLast_name:lastNameField.text];
            [userinfo setLat:@""];
            [userinfo setLon:@""];
            [userinfo setBirthday:@""];
            [userinfo setPhoneNumber:@""];
            
            [usermanagedObjectContent save:Nil];
            NSError *error;
            if (![usermanagedObjectContent save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
            [Utils hideSpinner];
            [AppDelegate determineRootViewController];

            
        }];
       
    }
    
}

#pragma mark TextField Delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    [delegate registerIsEditing];
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [delegate registerIsFinishedEditing];
    return YES;
}

@end
