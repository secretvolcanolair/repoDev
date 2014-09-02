//
//  meetConfirmation.m
//  REON
//
//  Created by Robert Kehoe on 7/16/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "meetConfirmation.h"
#import "AppDelegate.h"

@interface meetConfirmation ()

@end

@implementation meetConfirmation

@synthesize scrollView;
@synthesize nameLabel;
@synthesize titleLabel;
@synthesize companyLabel;
@synthesize profileImage;
@synthesize delegate;

@synthesize goldStar;
@synthesize redStar;

static float dim = 0.2;

-(id) initWithPendingMeet: (CDMeets *)pendingMeet{
    
    self = [super init];
    
    //--- Store Pending Meet Object (Core Data: CDMeet)
    pendingMeetObject = pendingMeet;
    
    //--- Set object context
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    return self;

}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    
    //--- Save switches when modal closes
    [pendingMeetObject setShowLinkedIn:[NSNumber numberWithBool:_linkedInSwitch.on]];
    [pendingMeetObject setShowFacebook:[NSNumber numberWithBool:_facebookSwitch.on]];
    [pendingMeetObject setShowTwitter:[NSNumber numberWithBool:_twitterSwitch.on]];
    [pendingMeetObject setShowInstagram:[NSNumber numberWithBool:_instagramSwitch.on]];
    
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.scrollView.contentOffset = CGPointMake(183, 0);
    
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@", [pendingMeetObject cardFirstname], [pendingMeetObject cardLastname]]];
    [titleLabel setText:[pendingMeetObject cardTitle]];
    [companyLabel setText:[pendingMeetObject cardCompany]];
    [profileImage setImage:[UIImage imageWithData:[pendingMeetObject cardImage]]];
    
    //--- Gold Star
    BOOL isGoldSelected = [[pendingMeetObject goldStar] boolValue];
    [goldStar setStarType:StarTypeGold isSelected:isGoldSelected];
    [goldStar setDelegate:self];
    
    //--- Red Star
    BOOL isRedStar = [[pendingMeetObject redStar] boolValue];
    [redStar setStarType:StarTypeRed isSelected:isRedStar];
    [redStar setDelegate:self];
    
    //--- Disable Phone Icon
    if([pendingMeetObject cardPhonecell].length == 0 && [pendingMeetObject cardPhonework].length == 0 && [pendingMeetObject cardPhoneother].length == 0){
        [_phoneIcon setAlpha:dim];
    }
    
    //--- Disable Email Icon
    if([pendingMeetObject cardEmailhome].length == 0 && [pendingMeetObject cardEmailother].length == 0 && [pendingMeetObject cardEmailwork].length == 0){
        [_emailIcon setAlpha:dim];
    }
    
    //--- Disable LinkedIn
    if([pendingMeetObject cardLinkedIn].length == 0){
        [_linkedInSwitch setEnabled:NO];
        [_linkedInSwitch setOn:NO];
        [_linkedInSwitch setAlpha:dim];
        [_linkedInIcon setAlpha:dim];
    }
    
    //--- Disable Facebook
    if([pendingMeetObject cardFacebook].length == 0){
        [_facebookSwitch setEnabled:NO];
        [_facebookSwitch setOn:NO];
        [_facebookSwitch setAlpha:dim];
        [_facebookIcon setAlpha:dim];
    }
    
    //--- Disable Twitter
    if([pendingMeetObject cardTwitter].length == 0){
        [_twitterSwitch setEnabled:NO];
        [_twitterSwitch setOn:NO];
        [_twitterSwitch setAlpha:dim];
        [_twitterIcon setAlpha:dim];
    }
    
    //--- Disable Instagram
    if([pendingMeetObject cardInstagram].length == 0){
        [_instagramSwitch setEnabled:NO];
        [_instagramSwitch setOn:NO];
        [_instagramSwitch setAlpha:dim];
        [_instagramIcon setAlpha:dim];
    }
    
}

- (IBAction)meetConnectAction:(id)sender {
    if([pendingMeetObject meet_id]){
        [delegate meetConfirmationDidCompleteWithObject:pendingMeetObject andAction:meetActionAccepted];
    }
}

- (IBAction)meetLaterAction:(id)sender {
    if([pendingMeetObject meet_id]){
        [delegate meetConfirmationDidCompleteWithObject:pendingMeetObject andAction:meetActionIgnored];
    }
}

- (IBAction)meetNoAction:(id)sender {
    if([pendingMeetObject meet_id]){
        [delegate meetConfirmationDidCompleteWithObject:pendingMeetObject andAction:meetActionRejected];
    }
}

#pragma mark StarDelegate

-(void)starWasTapped:(id)star isSelected:(BOOL)isSelected{
    
    if(star == goldStar){
        [pendingMeetObject setGoldStar:[NSNumber numberWithBool:isSelected]];
        [managedObjectContext save:Nil];
    }
    else if(star == redStar){
        [pendingMeetObject setRedStar:[NSNumber numberWithBool:isSelected]];
        [managedObjectContext save:Nil];
    }
    
}

@end
