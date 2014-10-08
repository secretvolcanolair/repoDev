//
//  Register.h
//  SnapAHottie
//
//  Created by Robert Kehoe on 4/6/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImage+Resize.h>

@protocol registerDelegate <NSObject>
@required
-(void) registerIsEditing;
-(void) registerIsFinishedEditing;
@end

@interface Register : UIView<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>{
    UIImage *profileImage;
    UIImage *maskedProfileImage;
    BOOL isEditing;
    id<registerDelegate>delegate;
    UIImageView *largeProfileImage;
}

@property (strong, nonatomic) UIViewController *parentViewController;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoButton;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) id<registerDelegate>delegate;

- (IBAction)uploadPhotoFromButton:(id)sender;
- (IBAction)continueAction:(id)sender;

@end
