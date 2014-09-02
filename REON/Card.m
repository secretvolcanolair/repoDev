//
//  Card.m
//  REON
//
//  Created by Robert Kehoe on 6/23/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize iconImageView;
@synthesize nameLabel;

-(id)initWithName: (NSString *)nameString atInstance: (int)instance{
    
    Card *cardInstance = [[[NSBundle mainBundle] loadNibNamed:@"Card" owner:self options:Nil] firstObject];
    
    //--- Change card icon image
    self.generatedIconType = [Card generateIconTypeForInstance:instance];
    [iconImageView setImage:[UIImage imageNamed:[Card findImageNameByIconType:self.generatedIconType]]];
        
    //--- Change card name
    [nameLabel setText:nameString];
    
    return cardInstance;
    
}

+(iconType)generateIconTypeForInstance: (int)instance{
    
    iconType iconType = CardRed;
    
    if(instance==1){
        iconType = CardGreen;
    }
    
    else if(instance==2){
        iconType = CardYellow;
    }
    
    else if(instance==3){
        iconType = CardPurple;
    }
    
    return iconType;
    
}

+(NSString *)findImageNameByIconType: (iconType)type{
    
    __block NSString *imageName;
    
    switch (type) {
            
        case CardRed:
            imageName = @"contact-card-red.png";
            break;
            
        case CardGreen:
            imageName = @"contact-card-green.png";
            break;
            
        case CardYellow:
            imageName = @"contact-card-yellow.png";
            break;
            
        case CardPurple:
            imageName = @"contact-card-purple.png";
            break;
            
    }
    
    return imageName;
    
}

@end
