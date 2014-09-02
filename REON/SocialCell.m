//
//  SocialCell.m
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "SocialCell.h"

@implementation SocialCell
@synthesize meetObject;

@synthesize linkedInButton;
@synthesize facebookButton;
@synthesize twitterButton;
@synthesize instagramButton;

static float dim = 0.15;

-(void) configureCellWithMeetObject: (CDMeets *)object{
    
    meetObject = object;
    
    //--- Define show vars in class scope
    showLinkedIn = [[meetObject showLinkedIn] boolValue];
    showFacebook = [[meetObject showFacebook] boolValue];
    showTwitter = [[meetObject showTwitter] boolValue];
    showInstagram = [[meetObject showInstagram] boolValue];
    
    //--- Check social values and double-verify if we should show the social network
    if(showLinkedIn) showLinkedIn = [[meetObject cardLinkedIn] isEqualToString:@""] ? NO : YES;
    if(showFacebook) showFacebook = [[meetObject cardFacebook] isEqualToString:@""] ? NO : YES;
    if(showTwitter) showTwitter = [[meetObject cardTwitter] isEqualToString:@""] ? NO : YES;
    if(showInstagram) showInstagram = [[meetObject cardInstagram] isEqualToString:@""] ? NO : YES;
    
    NSLog(@"Linkedin: %@\nFacebook: %@\nTwitter: %@\nInstagram: %@", showLinkedIn ? @"Yes" : @"No", showFacebook ? @"Yes" : @"No", showTwitter ? @"Yes" : @"No", showInstagram ? @"Yes" : @"No");
    
    //--- LinkedIn
    if(!showLinkedIn){
        [linkedInButton setAlpha:dim];
        [linkedInButton setEnabled:NO];
    }
    
    //--- Facebook
    if(!showFacebook){
        [facebookButton setAlpha:dim];
        [facebookButton setEnabled:NO];
    }
    
    //--- Twitter
    if(!showTwitter){
        [twitterButton setAlpha:dim];
        [twitterButton setEnabled:NO];
    }
    
    //--- Instagram
    if(!showInstagram){
        [instagramButton setAlpha:dim];
        [instagramButton setEnabled:NO];
    }
    
    //--- Add tap gestures to social buttons
    if(showLinkedIn){
        [linkedInButton setUserInteractionEnabled:YES];
        [linkedInButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(socialButtonClicked:)]];
    }
    
    if(showFacebook){
        [facebookButton setUserInteractionEnabled:YES];
        [facebookButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(socialButtonClicked:)]];
    }
    
    if(showTwitter){
        [twitterButton setUserInteractionEnabled:YES];
        [twitterButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(socialButtonClicked:)]];
    }
    
    if(showInstagram){
        [instagramButton setUserInteractionEnabled:YES];
        [instagramButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(socialButtonClicked:)]];
    }
    
}

-(void) socialButtonClicked: (UITapGestureRecognizer *)gesture{
    
    UIButton *buttonTapped = (UIButton *)[gesture view];
    NSLog(@"Social clicked: %@", buttonTapped);
    
    //--- LinkedIn
    if(buttonTapped == linkedInButton && showLinkedIn){
        NSLog(@"LinkedIn: %@", [NSString stringWithFormat:@"LinkedIn: %@", [meetObject cardLinkedIn]]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://www.linkedin.com/in/%@", [meetObject cardLinkedIn]]]];
    }
    
    //--- Facebook
    else if(buttonTapped == facebookButton && showFacebook){
        NSLog(@"Facebook: %@", [NSString stringWithFormat:@"Facebook: %@", [meetObject cardFacebook]]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://www.facebook.com/%@", [meetObject cardFacebook]]]];
    }
    
    //--- Twitter
    else if(buttonTapped == twitterButton && showTwitter){
        NSLog(@"Twitter: %@", [NSString stringWithFormat:@"Twitter: %@", [meetObject cardTwitter]]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://www.twitter.com/%@", [meetObject cardTwitter]]]];
    }
    
    //--- Instagram
    else if(buttonTapped == instagramButton && showInstagram){
        NSLog(@"Instagram: %@", [NSString stringWithFormat:@"Instagram: %@", [meetObject cardInstagram]]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://www.instagram.com/%@", [meetObject cardInstagram]]]];
    }
    
}

@end
