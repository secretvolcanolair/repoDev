//
//  RegistrationController.h
//  REON
//
//  Created by Robert Kehoe on 7/25/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login.h"
#import "Register.h"

@interface RegistrationController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, registerDelegate, loginDelegate>{
    Register *registerPage;
    Login *loginPage;
    UIColor *darkGray;
    UIColor *lightGray;
    CGRect originalFramePosition;
    bool didLoad;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end
