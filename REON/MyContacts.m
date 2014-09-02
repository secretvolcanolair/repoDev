//
//  MyContacts.m
//  REON
//
//  Created by Robert Kehoe on 7/31/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "MyContacts.h"
#import "AppDelegate.h"
#import "pendingRequestCell.h"
#import "Utils.h"
#import "MeetCard.h"
#import <ABContactsHelper.h>

@interface MyContacts ()

@end

@implementation MyContacts
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext;
@synthesize contactsArray;
@synthesize showCloseButton;

-(void)viewWillAppear:(BOOL)animated{
    
    if(!showCloseButton){
        showCloseButton = NO;
    }
    
    if(showCloseButton){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeModal)];
    }
    
}

-(void) closeModal{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark TableView Data source & Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int totalRows;
    
    if(!contactsArray){
    
        totalRows = (int)[[ABContactsHelper contacts] count];
        
        realRowCount = totalRows;
        
        if(totalRows==0){
            totalRows = 1;
        }
        
    }else{
        
        totalRows = (int)[contactsArray count];
        
        realRowCount = totalRows;
        
        if(totalRows==0){
            totalRows = 1;
        }
        
    }
    
    return totalRows;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(realRowCount == 0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        pendingRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        ABContact *contactObject;
        
        if(contactsArray){
            contactObject = [contactsArray objectAtIndex:indexPath.row];
        }else{
            contactObject = [[ABContactsHelper contacts] objectAtIndex:indexPath.row];
        }
        
        cell.nameLabel.text = [contactObject compositeName];
        cell.userImage.image = [contactObject image];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(realRowCount > 0){
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        ABContact *selectedContact;
        
        if(contactsArray){
            selectedContact = [contactsArray objectAtIndex:indexPath.row];
        }else{
            selectedContact = [[ABContactsHelper contacts] objectAtIndex:indexPath.row];
        }
        
        MeetCard *meetCardVC = [[MeetCard alloc] initWithABContactObject:selectedContact];
        [self.navigationController presentViewController:meetCardVC animated:YES completion:Nil];
        
    }
    
}

#pragma mark SearchBar Delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    contactsArray = Nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(!searchText || searchText.length==0){
        
        contactsArray = Nil;
        
    }else{
        
        contactsArray = [[NSMutableArray alloc] init];
        
        for(ABContact *contactObject in [ABContactsHelper contacts]){
            
            if( [[[contactObject compositeName] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound ){
                [contactsArray addObject:contactObject];
            }
            
        }
        
    }
    
    [self.tableView reloadData];
    
}

@end
