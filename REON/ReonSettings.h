//
//  ReonSettings.h
//  REON
//
//  Created by Chad McElwain on 9/16/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImage+Resize.h>

@interface ReonSettings : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImage *profileImage;
    UIImage *maskedProfileImage;
     UIImageView *largeProfileImage;
    NSTimer* ImageTime;
    UIActivityIndicatorView * activityindicator1;
}

@property (nonatomic, strong)IBOutlet UISwitch *FacebookSwitch;
@property (nonatomic, strong)IBOutlet UISwitch *LinkedinSwitch;
@property (nonatomic, strong)IBOutlet UISwitch *TiwtterSwitch;
@property (nonatomic, strong)IBOutlet UISwitch *InstagramSwitch;
@property(nonatomic,retain) IBOutlet UIImageView *Userimage;

@end
