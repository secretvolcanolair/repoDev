//
//  SmallMonthCell.m
//  REON
//
//  Created by Robert Kehoe on 8/22/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "SmallMonthCell.h"
#import "TeenyDayCell.h"
#import "Utils.h"

@implementation SmallMonthCell

@synthesize dayCollectionView;
@synthesize currentMonth;
@synthesize currentYear;
@synthesize currentDay;

@synthesize cellMonth;
@synthesize cellYear;

@synthesize eventDictionary;


#pragma mark CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _daysInMonth;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //--- Teeny Tiny Cells within month view
    TeenyDayCell *cell = (TeenyDayCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"dayCell" forIndexPath:indexPath];
    cell.dayLabel.text = [NSString stringWithFormat:@"%i", (int)(indexPath.row+1)];
    
    cell.isToday = NO;
    cell.isEvent = NO;
    
    [cell clearSetup];
    
    //--- Today's Cell
    if(currentMonth == cellMonth && (indexPath.row+1) == currentDay && currentYear == cellYear){
        cell.isToday = YES;
        [cell performSetup];
    }
    
    //--- Event Cells
    else if(cellYear <= currentYear && cellMonth <= currentMonth){
        
        NSString *keyString = [NSString stringWithFormat:@"%li%i%li", (long)cellMonth, (indexPath.row+1), (long)cellYear];
        
        if([eventDictionary objectForKey:keyString]){
            cell.isEvent = YES;
            [cell performSetup];
        }
        
    }
    
    return cell;
    
}

@end
