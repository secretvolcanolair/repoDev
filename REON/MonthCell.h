//
//  MonthCell.h
//  REON
//
//  Created by Robert Kehoe on 8/31/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventIcon;

-(void)setDayAsWeekendDay;
-(void)setAsEventDay;
-(void)setAsTodaysDay;

@end
