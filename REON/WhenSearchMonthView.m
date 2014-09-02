//
//  WhenSearchMonthView.m
//  REON
//
//  Created by Robert Kehoe on 8/28/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "WhenSearchMonthView.h"
#import "MyContacts.h"

@interface WhenSearchMonthView ()

@end

@implementation WhenSearchMonthView

@synthesize scrollView;

@synthesize previousMonth;
@synthesize previousYear;

@synthesize thisMonth;
@synthesize thisYear;

@synthesize nextMonth;
@synthesize nextYear;

-(void)viewWillAppear:(BOOL)animated{
    
    /*
     
     Infinite Scrolling Logic:
     
        Load 3 screens - Previous Month, Current Month & Next Month
        When swiple to new screen, load the following month
        If swipe to previous screen, load the previous month
     
        To keep memory low, we should ONLY keep 3 in memory
     
     */
    
    scrollView.delegate = self;
    
    screenWidth = scrollView.frame.size.width;
    screenHeight = scrollView.frame.size.height;
    
    UIView *previousMonthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    previousMonthView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:previousMonthView];
    
    UIView *currentMonthView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth*1, 0, screenWidth, screenHeight)];
    currentMonthView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:currentMonthView];
    
    UIView *nextMonthView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth*2, 0, screenWidth, screenHeight)];
    nextMonthView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:nextMonthView];
    
    [scrollView setContentSize:CGSizeMake(screenWidth*3, screenHeight)];
    [scrollView setContentOffset:CGPointMake(screenWidth, 0)];
    
    //--- View
    mainStage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    mainStage.backgroundColor = [UIColor grayColor];
    mainStage.alpha = 0;
    [currentMonthView addSubview:mainStage];
    
    [self resetScrollViewValues];
    
    monthView = [[MonthView alloc] init];
    monthView.delegate = self;
    
    [mainStage addSubview:monthView.view];
    
    [monthView loadMonth:thisMonth andYear:thisYear withEvents:Nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        [mainStage setAlpha:1.0];
    }];
    
}

#pragma mark ScrollView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(inFadeOutAnimation == NO){
    
        inFadeOutAnimation = YES;
        [UIView animateWithDuration:0.3 animations:^{
            [mainStage setAlpha:0.0];
        }];
        
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)sv{
    
    //--- Check if scrolling to show new month or previous
    BOOL scrollingNextMonth = currentScrollPosition>sv.contentOffset.x ? NO : YES;
    currentScrollPosition = sv.contentOffset.x;
    
    int previousScreen = currentScreen;
    currentScreen = currentScrollPosition/screenWidth;
    int difference = abs(previousScreen-currentScreen);
    thisMonth = scrollingNextMonth ? thisMonth+difference : thisMonth-difference;
    
    //--- Check if we need to switch years
    if(scrollingNextMonth==YES && thisMonth==13){
        thisMonth = 1;
        thisYear++;
    }
    
    //--- Check if we need to switch years
    if(scrollingNextMonth==NO && thisMonth==0){
        thisMonth = 12;
        thisYear--;
    }
    
    [scrollView setContentOffset:CGPointMake(screenWidth, 0)];
    [self resetScrollViewValues];
    
    //--- FADE IN THE MONTH
    [monthView loadMonth:thisMonth andYear:thisYear withEvents:Nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        [mainStage setAlpha:1.0];
    }];
    
}

-(void) resetScrollViewValues{
    currentScreen = 1;
    currentScrollPosition = screenWidth;
    inFadeOutAnimation = NO;
}

#pragma mark RCalendar Delegate

-(void)daySelectedWithEvents:(NSMutableArray *)eventArray{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"General" bundle:nil];
    MyContacts *contactsTableView = (MyContacts *)[storyboard instantiateViewControllerWithIdentifier:@"myContactsVC"];
    
    [contactsTableView setShowCloseButton:YES];
    [contactsTableView setContactsArray:eventArray];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contactsTableView];
    
    [self.navigationController presentViewController:navigationController animated:YES completion:Nil];
    
}

@end
