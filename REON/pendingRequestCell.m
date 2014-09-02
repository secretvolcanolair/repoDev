//
//  pendingRequestCell.m
//  REON
//
//  Created by Robert Kehoe on 7/15/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "pendingRequestCell.h"

@implementation pendingRequestCell

@synthesize delegate;

- (IBAction)accept:(id)sender {
    [delegate pendingRequestWasAccepted];
}

- (IBAction)reject:(id)sender {
    [delegate pendingRequestWasRejected];
}

@end
