//
//  TeenyDayCell.m
//  REON
//
//  Created by Robert Kehoe on 8/22/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "TeenyDayCell.h"

@implementation TeenyDayCell
@synthesize dayLabel;
@synthesize isToday;
@synthesize isEvent;

- (void)performSetup{
    
    self.backgroundColor = [UIColor clearColor];
    
    //--- Event
    //--- 0, 143, 176
    if(isEvent){
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0,1.0,12.0,12.0)];
        circleView.layer.cornerRadius = 6;
        circleView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:143.0/255.0 blue:176.0/255.0 alpha:1.0];
        dayLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:circleView];
        [self sendSubviewToBack:circleView];
        
    }
    
    //--- Today
    //--- 252, 61, 30
    if(isToday){
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0,1.0,12.0,12.0)];
        circleView.layer.cornerRadius = 6;
        circleView.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:61.0/255.0 blue:30.0/255.0 alpha:1.0];
        dayLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:circleView];
        [self sendSubviewToBack:circleView];
        
    }
    
}

@end
