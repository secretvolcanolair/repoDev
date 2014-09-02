//
//  NewCard.h
//  REON
//
//  Created by Robert Kehoe on 6/24/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDCard.h"

@interface NewCard : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *cardlabelTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardprefixTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardfirstnameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardlastnameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardsuffixTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardphonecellTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardphoneworkTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardphoneotherTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardemailhomeTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardemailworkTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardemailotherTextfield;
@property (strong, nonatomic) IBOutlet UITextField *cardprofessionaltitleTextfield;
@property (weak, nonatomic) IBOutlet UITextField *cardCompanyField;

//--- Social networks
@property (weak, nonatomic) IBOutlet UITextField *cardLinkedInField;
@property (weak, nonatomic) IBOutlet UITextField *cardFacebookField;
@property (weak, nonatomic) IBOutlet UITextField *cardTwitterField;
@property (weak, nonatomic) IBOutlet UITextField *cardInstagramField;

@property (strong, nonatomic) CDCard *cardObject;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addcardButton:(id)sender;

@end
