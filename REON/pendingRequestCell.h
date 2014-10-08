//
//  pendingRequestCell.h
//  REON
//
//  Created by Robert Kehoe on 7/15/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pendingRequestDelegate <NSObject>
@required
-(void)pendingRequestWasAccepted;
-(void)pendingRequestWasRejected;
@end

@interface pendingRequestCell : UITableViewCell{
    id<pendingRequestDelegate>delegate;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) id<pendingRequestDelegate>delegate;

@end
