//
//  Login.m
//  REON
//
//  Created by Robert Kehoe on 7/25/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "AppDelegate.h"
#import "Login.h"
#import "Utils.h"

@implementation Login
@synthesize emailField;
@synthesize passwordField;
@synthesize delegate;

-(id)init{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"Register" owner:self options:Nil] objectAtIndex:2];
    
    [emailField setDelegate:self];
    [passwordField setDelegate:self];
    
    isEditing = NO;
    
    return self;
    
}

- (IBAction)proceedWithSignIn:(id)sender {
    
    [Utils loginWithEmailAddress:emailField.text andPassword:passwordField.text withCallback:^{
        [AppDelegate determineRootViewController];
    }];
    
}

#pragma mark TextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(isEditing == NO){
        
        isEditing = YES;
        
        [delegate loginIsEditing];
        
    }
    
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [delegate loginIsFinishedEditing];
    return YES;
}

@end
