//
//  MonthCell.m
//  REON
//
//  Created by Robert Kehoe on 8/31/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "MonthCell.h"

@implementation MonthCell

-(void)awakeFromNib{
    _eventIcon.hidden = YES;
    _redCircle.layer.cornerRadius = 15;
    _redCircle.hidden = YES;
}

-(void)setDayAsWeekendDay{
    _dayLabel.textColor = [UIColor lightGrayColor];
}

-(void)setAsEventDay{
    _eventIcon.hidden = NO;
}

-(void)setAsTodaysDay{
    _redCircle.hidden = NO;
    _dayLabel.textColor = [UIColor whiteColor];
}

@end
