//
//  WhenSearchMonthView.h
//  REON
//
//  Created by Robert Kehoe on 8/28/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthView.h"

@interface WhenSearchMonthView : UIViewController<UIScrollViewDelegate, RCalendarDelegate>{
    int screenWidth;
    int screenHeight;
    int currentScreen;
    int currentScrollPosition;
    BOOL inFadeOutAnimation;
    UIView *mainStage;
    MonthView *monthView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property int thisMonth;
@property int thisYear;

@property int previousMonth;
@property int previousYear;

@property int nextMonth;
@property int nextYear;

@property (strong, nonatomic) NSArray *eventArray;

@end
