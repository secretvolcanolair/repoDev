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

@implementation SmallMonthCell

@synthesize dayCollectionView;
@synthesize currentMonth;
@synthesize currentYear;
@synthesize currentDay;

@synthesize cellMonth;
@synthesize cellYear;

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
    
    //--- Today's Cell
    if(currentMonth == cellMonth && (indexPath.row+1) == currentDay && currentYear == cellYear){
        cell.isToday = YES;
        [cell performSetup];
    }
    
    else if([[NSDate date] timeIntervalSinceDate:cellDate] > 0){
        
        //--- Check for events
        for(ABContact *contact in [ABContactsHelper contacts]){
            
            NSDate *date = [contact creationDate];
            NSCalendar *gregorian = [NSCalendar currentCalendar];
            NSDateComponents *dateComponents = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:date];
            
            NSInteger monthInteger = [dateComponents month];
            NSInteger dayInteger = [dateComponents day];
            NSInteger yearInteger = [dateComponents year];
            
            //--- Event day
            if(monthInteger == cellMonth && dayInteger == (indexPath.row+1) && yearInteger == cellYear){
                
                cell.isEvent = YES;
                [cell performSetup];
                break;
                
            }
            
        }
        
    }else{
        NSLog(@"Not checking for events %@", cellDate);
    }
    
    return cell;
    
}

@end
