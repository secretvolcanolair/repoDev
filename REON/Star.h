//
//  Star.h
//  REON
//
//  Created by Robert Kehoe on 7/22/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol starDelegate <NSObject>
@required
-(void) starWasTapped: (id)star isSelected: (BOOL)isSelected;
@end

typedef enum : NSUInteger {
    StarTypeGold,
    StarTypeRed
} StarType;

@interface Star : UIImageView{
    UIImage *starImage;
    StarType starType;
    BOOL isSelected;
    NSString *starFileName;
    id<starDelegate>delegate;
}

-(void)setStarType: (StarType)type isSelected: (BOOL)selected;

@property (strong, nonatomic) id<starDelegate>delegate;

@end
