//
//  Login.h
//  REON
//
//  Created by Robert Kehoe on 7/25/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginDelegate <NSObject>
@required
-(void) loginIsEditing;
-(void) loginIsFinishedEditing;
@end

@interface Login : UIView<UITextFieldDelegate>{
    id<loginDelegate>delegate;
    bool isEditing;
}

@property (strong, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) id<loginDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
