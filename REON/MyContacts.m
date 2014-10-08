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
@synthesize searchedContactsArray;

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
    
    if(!searchedContactsArray){
        
        if(contactsArray){
            totalRows = (int)[contactsArray count];
        }else{
            totalRows = (int)[[ABContactsHelper contacts] count];
        }
        
        realRowCount = totalRows;
        
        if(totalRows==0){
            totalRows = 1;
        }
        
    }else{
        
        totalRows = (int)[searchedContactsArray count];
        
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
        
        if(searchedContactsArray){
            
            contactObject = [searchedContactsArray objectAtIndex:indexPath.row];
            
        }else if(contactsArray){
            
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
        
        if(searchedContactsArray){
            
            selectedContact = [searchedContactsArray objectAtIndex:indexPath.row];
            
        }else if(contactsArray){
            
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
    searchedContactsArray = Nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(!searchText || searchText.length==0){
        
        searchedContactsArray = Nil;
        
    }else{
        
        searchedContactsArray = [[NSMutableArray alloc] init];
        
        if(contactsArray){
            
            for(ABContact *contactObject in contactsArray){
                
                if( [[[contactObject compositeName] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound ){
                    [searchedContactsArray addObject:contactObject];
                }
                
            }
            
        }else{
            
            for(ABContact *contactObject in [ABContactsHelper contacts]){
                
                if( [[[contactObject compositeName] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound ){
                    [searchedContactsArray addObject:contactObject];
                }
                
            }
            
        }
        
        
        
    }
    
    [self.tableView reloadData];
    
}

@end
