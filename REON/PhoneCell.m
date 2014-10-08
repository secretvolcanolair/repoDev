//
//  PhoneCell.m
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "PhoneCell.h"
#import "MeetCardMain.h"

@implementation PhoneCell

@synthesize valueLabel;

- (IBAction)sendMessage:(id)sender {
    
    NSString *cleanedPhoneNumber = [[valueLabel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    picker = [[MFMessageComposeViewController alloc] init];
    picker.recipients = [NSArray arrayWithObjects:cleanedPhoneNumber, nil];
    picker.messageComposeDelegate = self;
    
    [_parentTVC presentViewController:picker animated:YES completion:Nil];
    
}

- (IBAction)placePhoneCall:(id)sender {
    
    NSString *cleanedPhoneNumber = [[valueLabel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedPhoneNumber]]];
    
}

#pragma mark MessageComposer Delegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:Nil];
}

@end
