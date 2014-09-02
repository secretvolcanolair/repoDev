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

@interface Register () 

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
