//
//  IdentityCell.h
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Star.h"
#import "CDMeets.h"

@interface IdentityCell : UITableViewCell<starDelegate>{
    NSManagedObjectContext *managedObjectContext;
}

@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet Star *redStar;
@property (weak, nonatomic) IBOutlet Star *goldStar;
@property (weak, nonatomic) IBOutlet UIImageView *salesForceImageView;
@property (strong, nonatomic) CDMeets *meetObject;

-(void) setSelectedGoldStar: (BOOL)goldBool redStar: (BOOL)redBool;

@end
