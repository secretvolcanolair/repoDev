//
//  PhoneCell.h
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PhoneCell : UITableViewCell<UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate>{
    MFMessageComposeViewController *picker;
}

@property (strong, nonatomic) UITableViewController *parentTVC;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end
