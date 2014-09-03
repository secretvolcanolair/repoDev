//
//  SmallMonthCell.m
//  REON
//
//  Created by Robert Kehoe on 8/22/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "SmallMonthCell.h"
#import "TeenyDayCell.h"
#import <ABContactsHelper.h>
#import "Utils.h"

@implementation SmallMonthCell

@synthesize dayCollectionView;
@synthesize currentMonth;
@synthesize currentYear;
@synthesize currentDay;

@synthesize cellMonth;
@synthesize cellYear;

@synthesize eventArray;

-(void)checkEvents{
    
    eventArray = [[NSMutableArray alloc] init];
    NSArray *contactsArray = [Utils contactsByYear:(int)cellYear month:(int)cellMonth];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss Z"];
    
    for(ABContact *contact in contactsArray){
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[contact creationDate]];
        
        if(![eventArray containsObject:[NSNumber numberWithInteger:[components day]]]){
            [eventArray addObject:[NSNumber numberWithInteger:[components day]]];
        }
        
    }
    
}

#pragma mark CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _daysInMonth;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //--- Teeny Tiny Cells within month view
    TeenyDayCell *cell = (TeenyDayCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"dayCell" forIndexPath:indexPath];
    cell.dayLabel.text = [NSString stringWithFormat:@"%i", (int)(indexPath.row+1)];
    
    //--- Not Today's Cell
    NSString *dateString = [NSString stringWithFormat:@"%li/%li/%li", cellMonth, (indexPath.row+1), cellYear];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *cellDate = [formatter dateFromString:dateString];
    
    cell.isToday = NO;
    cell.isEvent = NO;
    
    [cell clearSetup];
    
    //--- Today's Cell
    if(currentMonth == cellMonth && (indexPath.row+1) == currentDay && currentYear == cellYear){
        cell.isToday = YES;
        [cell performSetup];
    }
    
    //--- Event Cells
    else if([[NSDate date] timeIntervalSinceDate:cellDate] > 0){
        
        for(NSNumber *number in eventArray){
            
            if( (indexPath.row+1) == [number intValue]){
                cell.isEvent = YES;
                [cell performSetup];
            }
            
        }
        
    }
    
    return cell;
    
}

@end
