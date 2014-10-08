//
//  EmailCell.m
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "EmailCell.h"

@implementation EmailCell

@synthesize valueLabel;

- (IBAction)sendMessage:(id)sender {
    
    picker = [[MFMessageComposeViewController alloc] init];
    picker.recipients = [NSArray arrayWithObjects:valueLabel.text, nil];
    picker.messageComposeDelegate = self;
    
    [_parentTVC presentViewController:picker animated:YES completion:Nil];
    
}

#pragma mark MessageComposer Delegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:Nil];
}

@end
