//
//  meetConfirmation.h
//  REON
//
//  Created by Robert Kehoe on 7/16/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "CDMeets.h"
#import "Star.h"

//--- Define delegate
@protocol meetConfirmationDelegate <NSObject>
@required
-(void) meetConfirmationDidCompleteWithObject: (CDMeets *)meetObject andAction: (meetAction) action;
@end

@interface meetConfirmation : UIViewController<starDelegate>{
    CDMeets *pendingMeetObject;
    id<meetConfirmationDelegate>delegate;
    NSManagedObjectContext *managedObjectContext;
}

#pragma mark Misc.
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

#pragma mark Switches
@property (weak, nonatomic) IBOutlet UISwitch *linkedInSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *instagramSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *salesForceSwitch;

#pragma mark Icons
@property (weak, nonatomic) IBOutlet UIImageView *emailIcon;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *salesForceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *linkedInIcon;
@property (weak, nonatomic) IBOutlet UIImageView *facebookIcon;
@property (weak, nonatomic) IBOutlet UIImageView *twitterIcon;
@property (weak, nonatomic) IBOutlet UIImageView *instagramIcon;

#pragma mark Stars
@property (weak, nonatomic) IBOutlet Star *goldStar;
@property (weak, nonatomic) IBOutlet Star *redStar;

@property (strong, nonatomic) id<meetConfirmationDelegate>delegate;

-(id) initWithPendingMeet: (CDMeets *)pendingMeet;


@end
