//
//  MonthView.h
//  REON
//
//  Created by Robert Kehoe on 8/31/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCalendarDelegate <NSObject>
@required
-(void) daySelectedWithEvents: (NSMutableArray *)eventArray;
@end

@interface MonthView : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSArray *eventArray;
    int totalDaysInMonth;
    id<RCalendarDelegate>delegate;
    int totalBlankDays;
}

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) id<RCalendarDelegate>delegate;

@property int month;
@property int year;

-(void)loadMonth: (int)m andYear: (int)y withEvents: (NSArray *)arr;

@end
