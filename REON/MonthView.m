//
//  MonthView.m
//  REON
//
//  Created by Robert Kehoe on 8/31/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "MonthView.h"
#import "MonthCell.h"
#import <ABContactsHelper.h>

@interface MonthView ()

@end

@implementation MonthView

@synthesize delegate;

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MonthCell" bundle:nil] forCellWithReuseIdentifier:@"MonthCell"];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Blank"];
    
}

-(void)loadMonth: (int)m andYear: (int)y withEvents: (NSArray *)arr{
    
    _month = m;
    _year = y;
    eventArray = arr;
    totalDaysInMonth = (int)[self daysInMonth:m];
    _monthLabel.text = [NSString stringWithFormat:@"%@ %i", [self intToMonthName:m isAbbrev:NO], y];
    
    [_collectionView reloadData];
    
}

#pragma mark CollectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    totalBlankDays = [self checkDayOfFirstDayOfMonth]-1;
    
    return totalDaysInMonth + totalBlankDays;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row >= totalBlankDays){
    
        MonthCell *cell = (MonthCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MonthCell" forIndexPath:indexPath];
        
        cell.dayLabel.text = [NSString stringWithFormat:@"%i", (int)(indexPath.row+1)-totalBlankDays];
        
        for(ABContact *contact in [ABContactsHelper contacts]){
            
            NSDate *date = [contact creationDate];
            NSCalendar *gregorian = [NSCalendar currentCalendar];
            NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
            
            NSInteger monthInteger = [dateComponents month];
            NSInteger dayInteger = [dateComponents day];
            NSInteger yearInteger = [dateComponents year];
            
            //--- Event day
            if(monthInteger == _month && dayInteger == (indexPath.row+1) && yearInteger == _year){
                [cell setAsEventDay];
                break;
            }else{
                [cell.eventIcon setHidden:YES];
            }
            
        }
        
        return cell;
        
    }else{
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Blank" forIndexPath:indexPath];
        return cell;
        
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *returnEventArray = [[NSMutableArray alloc] init];
    
    for(ABContact *contact in [ABContactsHelper contacts]){
        
        NSDate *date = [contact creationDate];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
        
        NSInteger monthInteger = [dateComponents month];
        NSInteger dayInteger = [dateComponents day];
        NSInteger yearInteger = [dateComponents year];
        
        //--- Event day
        if(monthInteger == _month && dayInteger == ((indexPath.row+1)-totalBlankDays) && yearInteger == _year){
            [returnEventArray addObject:contact];
        }
        
    }
    
    //--- Delegate
    [delegate daySelectedWithEvents:returnEventArray.count == 0 ? Nil : returnEventArray];
    
}

#pragma mark Duplicated Utility Functions

-(int) checkDayOfFirstDayOfMonth{
    
    //--- Convert String to Date
    NSString *dateString = [NSString stringWithFormat:@"%i-%i-01 01:00:00 AM", _year, _month];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSDate *myDate = [df dateFromString: dateString];
    
    //--- Convert date to weekday EEEE
    [df setDateFormat:@"EEEE"];
    NSString *weekdayLabel = [df stringFromDate:myDate];
    
    int weekdayInt = 0;
    
    if([weekdayLabel isEqualToString:@"Sunday"]) weekdayInt = 1;
    else if([weekdayLabel isEqualToString:@"Monday"]) weekdayInt = 2;
    else if([weekdayLabel isEqualToString:@"Tuesday"]) weekdayInt = 3;
    else if([weekdayLabel isEqualToString:@"Wednesday"]) weekdayInt = 4;
    else if([weekdayLabel isEqualToString:@"Thursday"]) weekdayInt = 5;
    else if([weekdayLabel isEqualToString:@"Friday"]) weekdayInt = 6;
    else weekdayInt = 7;
    
    return weekdayInt;
    
}

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
