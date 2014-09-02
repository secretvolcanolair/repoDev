//
//  NewCard.m
//  REON
//
//  Created by Robert Kehoe on 6/24/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "NewCard.h"
#import "AppDelegate.h"
#import "Utils.h"

@interface NewCard ()

@end

@implementation NewCard

@synthesize scrollView;
@synthesize cardlabelTextfield;
@synthesize cardprefixTextfield;
@synthesize cardsuffixTextfield;
@synthesize cardfirstnameTextfield;
@synthesize cardlastnameTextfield;
@synthesize cardphonecellTextfield;
@synthesize cardphoneworkTextfield;
@synthesize cardphoneotherTextfield;
@synthesize cardemailworkTextfield;
@synthesize cardemailotherTextfield;
@synthesize cardemailhomeTextfield;
@synthesize cardprofessionaltitleTextfield;
@synthesize cardCompanyField;

//--- Social networks
@synthesize cardLinkedInField;
@synthesize cardFacebookField;
@synthesize cardTwitterField;
@synthesize cardInstagramField;

@synthesize addButton;
@synthesize cardObject;

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [[self cardlabelTextfield]setDelegate:self];
    [[self cardprefixTextfield]setDelegate:self];
    [[self cardsuffixTextfield]setDelegate:self];
    [[self cardfirstnameTextfield]setDelegate:self];
    [[self cardlastnameTextfield]setDelegate:self];
    [[self cardphonecellTextfield]setDelegate:self];
    [[self cardphoneworkTextfield]setDelegate:self];
    [[self cardphoneotherTextfield]setDelegate:self];
    [[self cardemailhomeTextfield]setDelegate:self];
    [[self cardemailotherTextfield]setDelegate:self];
    [[self cardemailworkTextfield]setDelegate:self];
    [[self cardprofessionaltitleTextfield]setDelegate:self];
    
    //--- Background Tap
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    //--- Notifications when keyboard becomes active/inactive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustScrollViewWhenKeyboardActive:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustScrollViewWhenKeyboardInactive) name:UIKeyboardDidHideNotification object:nil];
    
    [self adjustScrollViewWhenKeyboardInactive];
    
    if(cardObject){
        
        //--- Change save button title
        [addButton setTitle:@"Save"];
        
        //--- Populate form fields
        [cardlabelTextfield setText:[cardObject cardLabel]];
        [cardCompanyField setText:[cardObject cardCompany]];
        [cardprefixTextfield setText:[cardObject cardPrefix]];
        [cardsuffixTextfield setText:[cardObject cardSuffix]];
        [cardfirstnameTextfield setText:[cardObject cardFirstname]];
        [cardlastnameTextfield setText:[cardObject cardLastname]];
        [cardphonecellTextfield setText:[cardObject cardPhonecell]];
        [cardphoneworkTextfield setText:[cardObject cardPhonework]];
        [cardphoneotherTextfield setText:[cardObject cardPhoneother]];
        [cardemailhomeTextfield setText:[cardObject cardEmailhome]];
        [cardemailotherTextfield setText:[cardObject cardEmailother]];
        [cardemailworkTextfield setText:[cardObject cardEmailwork]];
        [cardprofessionaltitleTextfield setText:[cardObject cardTitle]];
        [cardLinkedInField setText:[cardObject cardLinkedIn]];
        [cardFacebookField setText:[cardObject cardFacebook]];
        [cardTwitterField setText:[cardObject cardTwitter]];
        [cardInstagramField setText:[cardObject cardInstagram]];
        
    }
    
}

- (IBAction)addcardButton:(id)sender {
    
    if([[cardlabelTextfield text] isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a title for this card" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    } else if([[cardfirstnameTextfield text] isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a first name for this card" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
    
    else{
    
        AppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *managedObjectContent = [applicationDelegate managedObjectContext];
        
        CDCard *cards;
        
        if(cardObject){
            cards = cardObject;
        }else{
            cards = [NSEntityDescription insertNewObjectForEntityForName:@"CDCard" inManagedObjectContext:managedObjectContent];
        }
        
        [cards setCardLabel:cardlabelTextfield.text];
        
        [cards setCardSuffix:cardsuffixTextfield.text];
        [cards setCardPrefix:cardprefixTextfield.text];
        [cards setCardFirstname:cardfirstnameTextfield.text];
        [cards setCardLastname:cardlastnameTextfield.text];
        [cards setCardPhonecell:cardphonecellTextfield.text];
        [cards setCardPhonework:cardphoneworkTextfield.text];
        [cards setCardPhoneother:cardphoneotherTextfield.text];
        [cards setCardEmailhome:cardemailhomeTextfield.text];
        [cards setCardEmailother:cardemailotherTextfield.text];
        [cards setCardEmailwork:cardemailworkTextfield.text];
        [cards setCardTitle:cardprofessionaltitleTextfield.text];
        [cards setCardCompany:cardCompanyField.text];
        
        //--- Social network values
        [cards setCardLinkedIn:cardLinkedInField.text];
        [cards setCardFacebook:cardFacebookField.text];
        [cards setCardTwitter:cardTwitterField.text];
        [cards setCardInstagram:cardInstagramField.text];
        
        [managedObjectContent save:Nil];
        
        [Utils saveCard:cards withCallback:Nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark TextField Delegate
-(void)backgroundTapped{
    [[self.view superview] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark Scrollview Adjustments
-(void)adjustScrollViewWhenKeyboardInactive{
    
    //--- Get Screen Size
    float scrollviewWidth = [UIScreen mainScreen].bounds.size.width;
    float scrollviewHeight = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        [scrollView setFrame:CGRectMake(0, 0, scrollviewWidth, scrollviewHeight)];
    }];
    
}

-(void)adjustScrollViewWhenKeyboardActive:(NSNotification*)notification{
    
    //--- Get Keyboard Size
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    //--- Navigation Bar Height
    float navbarHeight = self.navigationController.navigationBar.frame.size.height;
    float statusbarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //--- Get Screen Size Minus keyboard height, navbar height and statusbar height
    float scrollviewWidth = [UIScreen mainScreen].bounds.size.width;
    float scrollviewHeight = [UIScreen mainScreen].bounds.size.height - keyboardFrameBeginRect.size.height - navbarHeight - statusbarHeight;
    
    [UIView animateWithDuration:0.3 animations:^{
        [scrollView setFrame:CGRectMake(0, 0, scrollviewWidth, scrollviewHeight)];
    }];
    
}

@end
