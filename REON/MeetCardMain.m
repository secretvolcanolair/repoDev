//
//  MeetCardMain.m
//  REON
//
//  Created by Robert Kehoe on 7/29/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "MeetCardMain.h"
#import "MeetCard.h"
#import <SVGeocoder.h>

@implementation MeetCardMain

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    //--- Obtain the meet object from the parent controller
    MeetCard *parentVC = (MeetCard *)[self parentViewController];
    meetObject = [parentVC meetObject];
    
    phoneNumberFormatter = [[ECPhoneNumberFormatter alloc] init];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

#pragma mark TableView Delegate & Datasource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger rowInt = indexPath.row;
    
    //--- Identity Cell
    if(rowInt == 0){
        return 215.0;
    }
    
    //--- Met Cell
    else if(rowInt == 1){
        return 120.0;
    }
    
    else{
        
        //--- All other rows
        return 65.0;
        
    }
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //--- Define the total number of rows
    //--- Base is 2 (Identity and Met Cells)
    //--- Add one for every email and phone number
    
    int totalRows = 3;
    
    //--- Phones
    totalRows += ![meetObject.cardPhonecell isEqualToString:@""] ? 1 : 0;
    totalRows += ![meetObject.cardPhoneother isEqualToString:@""] ? 1 : 0;
    totalRows += ![meetObject.cardPhonework isEqualToString:@""] ? 1 : 0;
    
    //--- Emails
    totalRows += ![meetObject.cardEmailhome isEqualToString:@""] ? 1 : 0;
    totalRows += ![meetObject.cardEmailother isEqualToString:@""] ? 1 : 0;
    totalRows += ![meetObject.cardEmailwork isEqualToString:@""] ? 1 : 0;
    
    NSLog(@"Here: %i", totalRows);
    
    return totalRows;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger rowInt = indexPath.row;
    UITableViewCell *returnCell;
    
    //--- Identity Cell
    if(rowInt == 0){
        IdentityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdentityCell"];
        cell.profilePhotoImageView.image = [UIImage imageWithData:[meetObject cardImage]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [meetObject cardFirstname], [meetObject cardLastname]];
        cell.titleLabel.text = [meetObject cardTitle];
        cell.companyLabel.text = [meetObject cardCompany];
        [cell setMeetObject:meetObject];
        [cell setSelectedGoldStar:[[meetObject goldStar] boolValue] redStar:[[meetObject redStar] boolValue]];
        returnCell = cell;
    }
    
    //--- Met Cell
    else if(rowInt == 1){
        
        MetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MetCell"];
        
        //--- Break down the date
        NSDate *dateMet = [meetObject dateAdded];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat = @"EEEE";
        NSString *weekDayName = [dateFormatter stringFromDate:dateMet];
        
        dateFormatter.dateFormat = @"LLLL dd, YYYY";
        NSString *dateFormatString = [dateFormatter stringFromDate:dateMet];
        
        dateFormatter.dateFormat = @"hh:mm aaa";
        NSString *timeFormatString = [dateFormatter stringFromDate:dateMet];
        
        cell.dayOfWeekLabel.text = weekDayName;
        cell.dateLabel.text = dateFormatString;
        cell.timeLabel.text = timeFormatString;
        
        //--- Find out the geo location of lat/lon where met
        cell.localityLabel.text = @"Loading...";
        cell.provinceLabel.text = @"...";
        cell.countryLabel.text = @"...";
        
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake([meetObject.cardLat doubleValue], [meetObject.cardLon doubleValue]) completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            SVPlacemark *placemarkObject = [placemarks firstObject];
            
            cell.localityLabel.text = [placemarkObject locality];
            cell.provinceLabel.text = [placemarkObject administrativeArea];
            cell.countryLabel.text = [placemarkObject country];
            
        }];
        
        returnCell = cell;
    }
    
    else if(rowInt == 2){
        
        SocialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialCell"];
        [cell configureCellWithMeetObject:meetObject];
        returnCell = cell;
        
    }
    
    else{
        
        //+++ PHONES
        //--- Cell Phone
        if(![meetObject.cardPhonecell isEqualToString:@""] && !phoneCellShown){
            phoneCellShown = YES;
            PhoneCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneCell"];
            cell.mainLabel.text = @"Mobile";
            cell.valueLabel.text = [phoneNumberFormatter stringForObjectValue:[meetObject cardPhonecell]];
            cell.parentTVC = self;
            returnCell = cell;
        }
        
        //--- Other Phone
        else if(![meetObject.cardPhoneother isEqualToString:@""] && !phoneOtherSown){
            phoneOtherSown = YES;
            PhoneCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneCell"];
            cell.mainLabel.text = @"Other";
            cell.valueLabel.text = [phoneNumberFormatter stringForObjectValue:[meetObject cardPhoneother]];
            cell.parentTVC = self;
            returnCell = cell;
        }
        
        //--- Work Phone
        else if(![meetObject.cardPhonework isEqualToString:@""] && !phoneWorkShown){
            phoneWorkShown = YES;
            PhoneCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneCell"];
            cell.mainLabel.text = @"Work";
            cell.valueLabel.text = [phoneNumberFormatter stringForObjectValue:[meetObject cardPhonework]];
            cell.parentTVC = self;
            returnCell = cell;
        }
        
        //+++ EMAILS
        //--- Home Email
        else if(![meetObject.cardEmailhome isEqualToString:@""] && !emailHomeShown){
            emailHomeShown = YES;
            EmailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
            cell.mainLabel.text = @"Home";
            cell.valueLabel.text = [meetObject cardEmailhome];
            cell.parentTVC = self;
            returnCell = cell;
        }
        
        //--- Other Email
        else if(![meetObject.cardEmailother isEqualToString:@""] && !emailOtherShown){
            emailOtherShown = YES;
            EmailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
            cell.mainLabel.text = @"Other";
            cell.valueLabel.text = [meetObject cardEmailother];
            cell.parentTVC = self;
            returnCell = cell;
        }
        
        //--- Work Email
        else if(![meetObject.cardEmailwork isEqualToString:@""] && !emailWorkShown){
            emailWorkShown = YES;
            EmailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
            cell.mainLabel.text = @"Work";
            cell.valueLabel.text = [meetObject cardEmailwork];
            cell.parentTVC = self;
            returnCell = cell;
        }
        
        //--- If a field is missing for whatever reason... show the EMAIL field
        //--- Hopefully this shoulnd't get called
        
        else{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmailCell" forIndexPath:indexPath];
            returnCell = cell;
            
        }
        
    }
    
    //--- Disbale selection style
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return returnCell;
    
}

/*
 * Explanation of this shitty bit of code
 * Because of the way this was done, I have to reset the "WasShown" booleans OR the cell would not display properly
 * Yes, stupid, I know... sorry. It was the easiest way to fix this small issue
 */

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row > 2){
        
        //+++ PHONES
        //--- Cell Phone
        if(![meetObject.cardPhonecell isEqualToString:@""] && phoneCellShown){
            phoneCellShown = NO;
        }
        
        //--- Other Phone
        else if(![meetObject.cardPhoneother isEqualToString:@""] && phoneOtherSown){
            phoneOtherSown = NO;
        }
        
        //--- Work Phone
        else if(![meetObject.cardPhonework isEqualToString:@""] && phoneWorkShown){
            phoneWorkShown = NO;
        }
        
        //+++ EMAILS
        //--- Home Email
        else if(![meetObject.cardEmailhome isEqualToString:@""] && emailHomeShown){
            emailHomeShown = NO;
        }
        
        //--- Other Email
        else if(![meetObject.cardEmailother isEqualToString:@""] && emailOtherShown){
            emailOtherShown = NO;
        }
        
        //--- Work Email
        else if(![meetObject.cardEmailwork isEqualToString:@""] && emailWorkShown){
            emailWorkShown = NO;
        }
        
    }
    
}

//--- Dismiss
- (IBAction)dismissMeetCard:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

@end
