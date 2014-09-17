//
//  WhenSearch.h
//  REON
//
//  Created by Robert Kehoe on 8/16/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhenSearch : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSString *currentMonthString;
    NSString *currentDayString;
    NSString *currentYearString;
    int currentYear;
    int currentDay;
    int currentMonth;
    int cellYear;
}

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *yearlyCollectionView;
@property (strong, nonatomic) NSMutableDictionary *eventDictionary;

@end
