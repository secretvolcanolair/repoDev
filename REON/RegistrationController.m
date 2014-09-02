//
//  RegistrationController.m
//  REON
//
//  Created by Robert Kehoe on 7/25/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "RegistrationController.h"

@interface RegistrationController ()

@end

@implementation RegistrationController

@synthesize scrollView;
@synthesize joinButton;
@synthesize signInButton;

//-(void)viewWillAppear:(BOOL)animated{
-(id)init{
    
    // [super viewWillAppear:animated];
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"Register" owner:self options:Nil] firstObject];
    
    if(didLoad != YES){
        
        //--- Adjust scrollview
        [scrollView setContentSize:CGSizeMake(640.0, 285.0)];
        [scrollView setDelegate:self];
        
        //--- Register
        registerPage = [[Register alloc] init];
        registerPage.delegate = self;
        registerPage.parentViewController = self;
        [registerPage setFrame:CGRectMake(0, 0, 320.0, 285.0)];
        [scrollView addSubview:registerPage];
        
        //--- Login
        loginPage = [[Login alloc] init];
        loginPage.delegate = self;
        loginPage.parentViewController = self;
        [loginPage setFrame:CGRectMake(320.0, 0, 320.0, 285.0)];
        [scrollView addSubview:loginPage];
        
        //--- Colors
        darkGray = [UIColor colorWithRed:209.0/255.0 green:210.0/255.0 blue:213.0/255.0 alpha:1];
        lightGray = [UIColor colorWithRed:231.0/255.0 green:232.0/255.0 blue:233.0/255.0 alpha:1];
        
        //--- Store original frame position
        originalFramePosition = self.view.frame;
        
        [self JoinAction:Nil];
        didLoad = YES;
        
    }
    
    return self;
    
}

- (IBAction)JoinAction:(id)sender {
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 320.0, 285.0) animated:YES];
    [joinButton setBackgroundColor:lightGray];
    [signInButton setBackgroundColor:darkGray];
}

- (IBAction)SignInAction:(id)sender {
    [scrollView scrollRectToVisible:CGRectMake(320.0, 0, 320.0, 285.0) animated:YES];
    [joinButton setBackgroundColor:darkGray];
    [signInButton setBackgroundColor:lightGray];
}

#pragma mark ScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)sv{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        //--- Register
        if(sv.contentOffset.x == 0){
            
            [joinButton setBackgroundColor:lightGray];
            [signInButton setBackgroundColor:darkGray];
            
        }
        
        //--- Login
        else{
            
            [joinButton setBackgroundColor:darkGray];
            [signInButton setBackgroundColor:lightGray];
            
        }
        
    }];
    
}

-(void)revertViewToOriginalPosition{
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view setFrame:originalFramePosition];
    }];
    
}

#pragma mark RegistrationDelegate

-(void)registerIsEditing{
    
    [UIView animateWithDuration:0.34 animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, -140, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
}

-(void)registerIsFinishedEditing{
    [self revertViewToOriginalPosition];
}

#pragma mark LoginDelegate

-(void)loginIsEditing{
    
    [UIView animateWithDuration:0.34 animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, -140, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
}

-(void)loginIsFinishedEditing{
    [self revertViewToOriginalPosition];
}

- (IBAction)cancelRegistration:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
