//
//  Star.m
//  REON
//
//  Created by Robert Kehoe on 7/22/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "Star.h"

@implementation Star

@synthesize delegate;

 -(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    [self setUserInteractionEnabled:YES];
    [self setStarEmpty];
    
    //--- Initalize TAP Gestures
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleStarSelection)];
    [self addGestureRecognizer:tap];
    
    return self;

}

-(void)setStarType: (StarType)type isSelected: (BOOL)selected{
    
    //--- Save data points to memory
    starType = type;
    isSelected = selected;
    
    switch(starType){
            
        case StarTypeGold:
            starFileName = @"star_gold.png";
            break;
            
        case StarTypeRed:
            starFileName = @"star_red.png";
            break;
            
    }
    
    //--- Set empty or filled
    if(isSelected){
        [self setStarSelected];
    }else{
        [self setStarEmpty];
    }
    
}

-(void)toggleStarSelection{
    
    if(isSelected){
        [self setStarEmpty];
    }else{
        [self setStarSelected];
    }
    
    [delegate starWasTapped:self isSelected:isSelected];
    
}

-(void)setStarEmpty{
    self.image = [UIImage imageNamed:@"star_empty.png"];
    isSelected = NO;
}

-(void)setStarSelected{
    self.image = [UIImage imageNamed:starFileName];
    isSelected = YES;
}

@end
