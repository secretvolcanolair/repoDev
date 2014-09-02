//
//  SmallMonthCell.h
//  REON
//
//  Created by Robert Kehoe on 8/22/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallMonthCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *calendarStage;
@property (weak, nonatomic) IBOutlet UICollectionView *dayCollectionView;
@property (strong, nonatomic) NSArray *eventArray;
@property NSUInteger daysInMonth;

@property NSInteger currentMonth;
@property NSInteger currentDay;
@property NSInteger currentYear;

@property NSInteger cellMonth;
@property NSInteger cellYear;

@end
