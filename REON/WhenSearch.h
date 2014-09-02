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
}

@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end
