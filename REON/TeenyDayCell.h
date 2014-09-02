//
//  TeenyDayCell.h
//  REON
//
//  Created by Robert Kehoe on 8/22/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeenyDayCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property BOOL isToday;
@property BOOL isEvent;
- (void)performSetup;
@end
