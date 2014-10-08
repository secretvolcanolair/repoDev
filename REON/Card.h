//
//  Card.h
//  REON
//
//  Created by Robert Kehoe on 6/23/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDCard.h"

@interface Card : UIView

typedef enum: NSUInteger{
    CardRed,
    CardGreen,
    CardYellow,
    CardPurple
} iconType;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) CDCard *associatedCDCardObject;
@property iconType generatedIconType;

-(id)initWithName: (NSString *)nameString atInstance: (int)instance;

+(iconType)generateIconTypeForInstance: (int)instance;
+(NSString *)findImageNameByIconType: (iconType)type;

@end
