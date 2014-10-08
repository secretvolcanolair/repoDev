//
//  SocialCell.h
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDMeets.h"

@interface SocialCell : UITableViewCell{
    BOOL showLinkedIn;
    BOOL showFacebook;
    BOOL showTwitter;
    BOOL showInstagram;
}
@property (weak, nonatomic) IBOutlet UIButton *linkedInButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (strong, nonatomic) CDMeets *meetObject;

-(void) configureCellWithMeetObject: (CDMeets *)object;

@end
