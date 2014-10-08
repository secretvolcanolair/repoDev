//
//  MeetCardMain.h
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "IdentityCell.h"
#import "MetCell.h"
#import "PhoneCell.h"
#import "EmailCell.h"
#import "SocialCell.h"
#import "CDMeets.h"

#import <ECPhoneNumberFormatter.h>

@interface MeetCardMain : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    
    CDMeets *meetObject;
    ECPhoneNumberFormatter *phoneNumberFormatter;
    
    BOOL phoneCellShown;
    BOOL phoneOtherSown;
    BOOL phoneWorkShown;
    
    BOOL emailHomeShown;
    BOOL emailOtherShown;
    BOOL emailWorkShown;
    
}

@end
