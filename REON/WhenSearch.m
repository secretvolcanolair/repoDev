//
//  WhenSearch.m
//  REON
//
//  Created by Robert Kehoe on 8/16/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "WhenSearch.h"
#import "Utils.h"
#import "SmallMonthCell.h"
#import "WhenSearchMonthView.h"

@interface WhenSearch ()

@end

@implementation WhenSearch

@synthesize yearLabel;

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //--- Get Current date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //-- Current Month
    [formatter setDateFormat:@"MM"]; // 08
    currentMonthString = [formatter stringFromDate:[NSDate date]];
    currentMonth = [[formatter stringFromDate:[NSDate date]] intValue];
    
    //--- Current Day
    [formatter setDateFormat:@"dd"]; // 22
    currentDayString = [formatter stringFromDate:[NSDate date]];
    currentDay = [[formatter stringFromDate:[NSDate date]] intValue];
    
    //--- Current Year
    [formatter setDateFormat:@"yyyy"]; // 2014
    currentYearString = [formatter stringFromDate:[NSDate date]];
    yearLabel.text = currentYearString;
    currentYear = [currentYearString intValue];
    
}

#pragma mark Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    
    WhenSearchMonthView *monthView = (WhenSearchMonthView *)segue.destinationViewController;
    monthView.thisMonth = (int)(indexPath.row + 1);
    monthView.thisYear = currentYear;
    
}

#pragma mark CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SmallMonthCell *cell = (SmallMonthCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"smallMonth" forIndexPath:indexPath];
    
    int cellMonth = (int)(indexPath.row + 1);
    int daysInMonth = (int)[self daysInMonth:cellMonth];
    
    cell.monthLabel.text = [self intToMonthName:cellMonth isAbbrev:YES];
    cell.daysInMonth = daysInMonth;
    
    cell.cellMonth = cellMonth;
    cell.cellYear = currentYear;
    
    cell.currentMonth = currentMonth;
    cell.currentYear = currentYear;
    cell.currentDay = currentDay;
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"monthSegue" sender:indexPath];
}

#pragma mark Date Utilities

-(NSString *) intToMonthName: (int)monthInteger isAbbrev: (BOOL)isAbbrev{
    
    NSString *returnString;
    
    switch(monthInteger){
        case 1: returnString = isAbbrev ? @"Jan" : @"January"; break;
        case 2: returnString = isAbbrev ? @"Feb" : @"February"; break;
        case 3: returnString = isAbbrev ? @"Mar" : @"March"; break;
        case 4: returnString = isAbbrev ? @"Apr" : @"April"; break;
        case 5: returnString = isAbbrev ? @"May" : @"May"; break;
        case 6: returnString = isAbbrev ? @"Jun" : @"June"; break;
        case 7: returnString = isAbbrev ? @"Jul" : @"July"; break;
        case 8: returnString = isAbbrev ? @"Aug" : @"August"; break;
        case 9: returnString = isAbbrev ? @"Sep" : @"September"; break;
        case 10: returnString = isAbbrev ? @"Oct" : @"October"; break;
        case 11: returnString = isAbbrev ? @"Nov" : @"November"; break;
        case 12: returnString = isAbbrev ? @"Dec" : @"December"; break;
    }
    
    return returnString;
    
}

-(NSUInteger) daysInMonth: (int)monthInt{
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setMonth:monthInt];
    
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[cal dateFromComponents:comps]];
    
    return range.length;
    
}

@end
