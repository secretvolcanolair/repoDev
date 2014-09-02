//
//  pendingRequests.m
//  REON
//
//  Created by Robert Kehoe on 7/15/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "pendingRequests.h"
#import "AppDelegate.h"
#import "pendingRequestCell.h"
#import "Utils.h"

@interface pendingRequests ()

@end

@implementation pendingRequests
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext;

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
}

#pragma mark NSFetchedResultController

-(NSFetchedResultsController *) fetchedResultsController{
    
    //--- Get Object Context
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    if(!_fetchedResultsController){
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *meets = [NSEntityDescription entityForName:@"CDMeets" inManagedObjectContext:managedObjectContext];
        
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"status = 0"];
        [request setPredicate:filterPredicate];
        
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"meet_id" ascending:NO]]];
        [request setEntity:meets];

        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:Nil cacheName:Nil];
        _fetchedResultsController.delegate = self;
        
    }
    
    return _fetchedResultsController;
    
}

#pragma mark TableView Data source & Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSInteger totalRows = [sectionInfo numberOfObjects];
    realRowCount = totalRows;
    
    if(totalRows==0){
        totalRows = 1;
    }
    
    return totalRows;
    
}

- (void)configureCell:(pendingRequestCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    CDMeets *object = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    //--- Card name
    if([[object cardFirstname] length] > 0||[[object cardLastname] length] > 0){
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@", [object cardFirstname], [object cardLastname]]];
    }else{
        [cell.nameLabel setText:@"N/A"];
    }
    
    [cell.cardLabel setText:[object cardTitle]];
    [cell.userImage setImage:[UIImage imageWithData:[object cardImage]]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(realRowCount == 0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
    
        pendingRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if(!cell){
            cell = [[pendingRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(realRowCount > 0){
    
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        requestObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        
        meetConfirmationView = [[meetConfirmation alloc] initWithPendingMeet:requestObject];
        meetConfirmationView.delegate = self;
        
        [self.navigationController presentViewController:meetConfirmationView animated:YES completion:Nil];
        
    }
    
}

#pragma mark MeetActionDelegate

-(void)meetConfirmationDidCompleteWithObject:(CDMeets *)meetObject andAction:(meetAction)action{
    
    //--- Update the meet request and obtain the card information so we can save it
    [meetConfirmationView dismissViewControllerAnimated:YES completion:Nil];
    
    if([[meetObject status] isEqualToString:@"0"] == NO){
        [Utils changeNotificationStatus:meetObject withStatus:action withCallback:Nil];
    }else{
        NSLog(@"Not saving the status because no need to...");
    }
    
}

#pragma mark NSFetchResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(pendingRequestCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
