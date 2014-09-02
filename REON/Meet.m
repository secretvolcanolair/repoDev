//
//  Meet.m
//  REON
//
//  Created by Robert Kehoe on 6/23/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "Meet.h"
#import "AppDelegate.h"
#import "CDCard.h"
#import "CDMeets.h"
#import "Utils.h"
#import <UIImageView+WebCache.h>
#import "MeetCard.h"
#import "NewCard.h"

@interface Meet ()

@end

@implementation Meet

@synthesize cardStage;
@synthesize peopleCollection;
@synthesize pendingRequestsLabel;
@synthesize pendingRequestsView;

@synthesize recentlyMet1;
@synthesize recentlyMet2;
@synthesize recentlyMet3;

-(void) viewWillAppear:(BOOL)animated{
    
    //--- Listen for coreData changes and populate recently met if neccessary
    //--- @ToDo: We should eventually extend this to listen for new records added to core data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateRecentlyMet) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    //--- Set name of app
    [self setTitle:[Utils currentMemberName]];
    
    //--- Get Object Context
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    [self populateRecentlyMet];
    
    //--- Remove all current cards from stage
    [cardStage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //--- Build Request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *cards = [NSEntityDescription entityForName:@"CDCard" inManagedObjectContext:managedObjectContext];
    [request setEntity:cards];
    
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:Nil] mutableCopy];
    
    if([mutableFetchResults count] > 0){
        
        //--- Generate Cards
        int instanceInt = 0;
        cardStageWidth = 0;
        
        for(int i=0; i<=[mutableFetchResults count]-1; i++){
            
            CDCard *cardObject = [mutableFetchResults objectAtIndex:i];
            Card *contactCardSample = [[Card alloc] initWithName:[cardObject valueForKey:@"cardLabel"] atInstance:instanceInt];
            [contactCardSample setAssociatedCDCardObject:cardObject];
            
            int cardWidth = [contactCardSample bounds].size.width+10;
            int cardHeight = [contactCardSample bounds].size.height;
            
            [contactCardSample setFrame:CGRectMake((cardWidth*i)+10, 0, cardWidth, cardHeight)];
            [contactCardSample addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editCardAction:)]];
            [cardStage addSubview:contactCardSample];
            
            cardStageWidth += cardWidth;
            
            //--- Detect a long press on this object
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapRecognized:)];
            [longPress setMinimumPressDuration:0.15];
            [contactCardSample addGestureRecognizer:longPress];
            [contactCardSample setTag:i];
            
            //--- Instance stuff
            instanceInt += 1;
            
            if(instanceInt==5){
                instanceInt = 1;
            }
            
        }
        
        //--- Set the new stage width
        [cardStage setContentSize:CGSizeMake(cardStageWidth, cardStage.frame.size.height)];
        
    }
    
}

//--- Edit card actions
-(void) editCardAction: (UITapGestureRecognizer *)gesture{
    Card *cardObject = (Card *)[gesture view];
    [self performSegueWithIdentifier:@"newCardSegue" sender:cardObject];
}

//--- On segue, do some checks
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([sender isKindOfClass:[Card class]] && [segue.identifier isEqualToString:@"newCardSegue"]){
        NewCard *newCardViewController = [segue destinationViewController];
        newCardViewController.cardObject = [(Card *)sender associatedCDCardObject];
    }
    
}

-(void) populateRecentlyMet{
    
    //--- Get the latest 3 meets
    //--- Populate the 3 placeholder circles
    NSFetchRequest *getLatestMeets = [[NSFetchRequest alloc] initWithEntityName:@"CDMeets"];
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"status = 2"];
    [getLatestMeets setPredicate:filterPredicate];
    
    getLatestMeets.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:NO]];
    getLatestMeets.fetchLimit = 3;
    
    int meetI = 1;
    NSArray *meetArray = [managedObjectContext executeFetchRequest:getLatestMeets error:Nil];
    
    for(CDMeets *meetObject in meetArray){
        
        if([meetObject cardImage]){
            
            if(meetI == 1){
                [recentlyMet1 setImage:[UIImage imageWithData:[meetObject cardImage]]];
                [recentlyMet1 setUserInteractionEnabled:YES];
                [recentlyMet1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recentlyMetTapped:)]];
                recent1 = meetObject;
            }
            
            else if(meetI == 2){
                [recentlyMet2 setImage:[UIImage imageWithData:[meetObject cardImage]]];
                [recentlyMet2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recentlyMetTapped:)]];
                [recentlyMet2 setUserInteractionEnabled:YES];
                recent2 = meetObject;
            }
            
            else if(meetI == 3){
                [recentlyMet3 setImage:[UIImage imageWithData:[meetObject cardImage]]];
                [recentlyMet3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recentlyMetTapped:)]];
                [recentlyMet3 setUserInteractionEnabled:YES];
                recent3 = meetObject;
            }
            
            meetI++;
            
        }
        
    }
    
}

-(void)viewDidLoad{
    
    didRange = NO;
    showingRequest = NO;
    peopleArray = [[NSArray alloc] init];
    
    //--- Bluetooth: Setup beacon region
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"4FC2E30B-46B8-4636-B97A-694CE0975A0C"];
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"reon.remembereveryone.com"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //--- Every 5 seconds, broadcast
    [self listenForPeople];
    
    //--- Attach an event to the pending requests view container
    [pendingRequestsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pendingRequestsTapped)]];
    
}

//--- Recently Met Has Been Tapped
-(void)recentlyMetTapped:(UITapGestureRecognizer *)recognizer{
    
    UIImageView *imageView = (UIImageView *)recognizer.view;
    
    if(imageView == recentlyMet1){
        MeetCard *meetCard = [[MeetCard alloc] initWithCDMeetObject:recent1];
        [self presentViewController:meetCard animated:YES completion:Nil];
    }
    
    else if(imageView == recentlyMet2){
        MeetCard *meetCard = [[MeetCard alloc] initWithCDMeetObject:recent2];
        [self presentViewController:meetCard animated:YES completion:Nil];
    }
    
    else if(imageView == recentlyMet3){
        MeetCard *meetCard = [[MeetCard alloc] initWithCDMeetObject:recent3];
        [self presentViewController:meetCard animated:YES completion:Nil];
    }
    
}

-(void)pendingRequestsTapped{
    
    [self performSegueWithIdentifier:@"pendingRequestsSegue" sender:self];
    
}

-(void) listenForPeople{
    
    //--- Stop previous broadcasting
    [brodcastMe stopBroadcasting];
    
    //--- Check for pending requests
    [self checkPendingShares];
    
    //--- Start monitoring
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
    
    //--- Start broadcasting after 5 seconds
    int randomListeningInt = [Meet randomNumberBetween:1 and:3];
    [NSTimer scheduledTimerWithTimeInterval:randomListeningInt target:self selector:@selector(broadcastMe) userInfo:Nil repeats:NO];
    
}

-(void) checkPendingShares{
    
    [Utils checkPendingShares:^(NSMutableDictionary *object, int totalPendingShares, NSArray *pendingSharesObject) {
        
        //--- Set the pending requests
        [pendingRequestsLabel setText:[NSString stringWithFormat:@"%i", totalPendingShares]];
        
        //--- Save the pending meets to CoreData, so we can work with them in the UITableViewController
        bool doSave = NO;
        
        for(NSDictionary *object in pendingSharesObject){
            
            //--- Check for the pending meet before adding it so we don't get duplicates
            NSFetchRequest *fetchCurrentPending = [NSFetchRequest fetchRequestWithEntityName:@"CDMeets"];
            [fetchCurrentPending setPredicate:[NSPredicate predicateWithFormat:@"meet_id = %@", [object valueForKey:@"meet_id"]]];
            
            NSArray *pendingFetchedArray = [managedObjectContext executeFetchRequest:fetchCurrentPending error:Nil];
            
            //--- If object not in core data, add that fucker!
            if([pendingFetchedArray count] == 0){
                
                doSave = YES;
                
                CDMeets *pendingMeet = [NSEntityDescription insertNewObjectForEntityForName:@"CDMeets" inManagedObjectContext:managedObjectContext];
                
                [pendingMeet setMeet_id:[object valueForKey:@"meet_id"]];
                [pendingMeet setCardPrefix:[object valueForKey:@"cardPrefix"]];
                [pendingMeet setCardFirstname:[object valueForKey:@"cardFirstname"]];
                [pendingMeet setCardLastname:[object valueForKey:@"cardLastname"]];
                [pendingMeet setCardSuffix:[object valueForKey:@"cardSuffix"]];
                [pendingMeet setCardTitle:[object valueForKey:@"cardTitle"]];
                [pendingMeet setCardCompany:[object valueForKey:@"cardCompany"]];
                [pendingMeet setCardPhonework:[object valueForKey:@"cardPhonework"]];
                [pendingMeet setCardPhoneother:[object valueForKey:@"cardPhoneother"]];
                [pendingMeet setCardPhonecell:[object valueForKey:@"cardPhonecell"]];
                [pendingMeet setCardEmailwork:[object valueForKey:@"cardEmailwork"]];
                [pendingMeet setCardEmailother:[object valueForKey:@"cardEmailother"]];
                [pendingMeet setCardEmailhome:[object valueForKey:@"cardEmailhome"]];
                [pendingMeet setCardLinkedIn:[object valueForKey:@"cardLinkedIn"]];
                [pendingMeet setCardFacebook:[object valueForKey:@"cardFacebook"]];
                [pendingMeet setCardTwitter:[object valueForKey:@"cardTwitter"]];
                [pendingMeet setCardInstagram:[object valueForKey:@"cardInstagram"]];
                [pendingMeet setDateAdded:[NSDate date]];
                [pendingMeet setStatus:@"1"];
                [pendingMeet setCardID:[object valueForKey:@"id"]];
                
                //--- Save Lat/Lon Coords
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                
                [pendingMeet setCardLat:[f numberFromString:[object valueForKey:@"cardLat"]]];
                [pendingMeet setCardLon:[f numberFromString:[object valueForKey:@"cardLon"]]];
                [pendingMeet setDateAdded:[NSDate date]];
                
                //--- Save users image if exists
                if([object valueForKey:@"userImage"] != [NSNull null]){
                    
                    NSURL *urlString = [NSURL URLWithString:[object valueForKey:@"userImage"]];
                    NSData *imageData = [NSData dataWithContentsOfURL:urlString];
                    
                    [pendingMeet setCardImage:imageData];
                    
                }
                
            }
            
        }
        
        //--- Save all objects in context
        if(doSave){
            [managedObjectContext save:Nil];
        }
        
        //--- Get the active request's CDPendingMeets object
        //--- And pass it to the event handler for active confirmation
        
        if(object && showingRequest == NO){
            
            NSFetchRequest *getPendingRequestObject = [NSFetchRequest fetchRequestWithEntityName:@"CDMeets"];
            [getPendingRequestObject setPredicate:[NSPredicate predicateWithFormat:@"meet_id = %@", [object valueForKey:@"meet_id"]]];
            
            NSArray *pendingRequestObjectArray = [managedObjectContext executeFetchRequest:getPendingRequestObject error:Nil];
            
            if([pendingRequestObjectArray count] > 0){
                
                CDMeets *pendingMeetObject = [pendingRequestObjectArray firstObject];
                [self handleNewRequest:pendingMeetObject];
                
            }
            
        }
        
    }];
    
}

-(void)handleNewRequest: (CDMeets *)object{
    
    //--- Open meet confirmation viewcontroller
    //--- Do not add this as a subview, it breaks the IBOutlets
    
    if(showingRequest == NO){
        
        showingRequest = YES;
        requestObject = object;
        
        meetConfirmationView = [[meetConfirmation alloc] initWithPendingMeet:requestObject];
        meetConfirmationView.delegate = self;
        
        [self.navigationController presentViewController:meetConfirmationView animated:YES completion:Nil];
        
    }
    
}

#pragma mark MeetActionDelegate

-(void)meetConfirmationDidCompleteWithObject:(CDMeets *)meetObject andAction:(meetAction)action{
    
    showingRequest = NO;
    [meetConfirmationView dismissViewControllerAnimated:YES completion:Nil];
    [Utils changeNotificationStatus:meetObject withStatus:action withCallback:Nil];
    
}

#pragma mark Broadcasting

-(void) broadcastMe{
    
    //--- Stop listening
    [self.locationManager stopMonitoringForRegion:self.myBeaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
    
    //--- Construct Broadcast object
    if(!brodcastMe){
        brodcastMe = [[broadcast alloc] initWithUserIDString:[Utils currentMember]];
    }
    
    [brodcastMe startBroadcasting];
    
    //--- Start Listening between 3-5 seconds
    int randomListeningInt = [Meet randomNumberBetween:1 and:3];
    [NSTimer scheduledTimerWithTimeInterval:randomListeningInt target:self selector:@selector(listenForPeople) userInfo:Nil repeats:NO];
    
}

#pragma mark Drag & Drop

//--- Custom gesture method for getting data from long tap
-(void)longTapRecognized: (UILongPressGestureRecognizer *)gesture{
    
    //--- Get the tap location of users finger & center the card image within the tap location
    CGPoint tapLocation = [gesture locationInView:self.view];
    
    int squareWidth = 106.5; // 71.0;
    int squareHeight = 69.0; // 46.0;
    int locationX = tapLocation.x - squareWidth/2;
    int locationY = tapLocation.y - squareHeight/2;
    
    //--- If card hasn't been selected already, then find the one selected
    if(!selectedCardView){
        
        selectedTag = (int)[[gesture view] tag];
        selectedCard = [[cardStage subviews] objectAtIndex:selectedTag];
    
        //--- Drag started / Save card
        if(gesture.state == UIGestureRecognizerStateBegan){
            
            selectedCardView = [[UIView alloc] initWithFrame:CGRectMake(locationX, locationY, squareWidth, squareHeight)];
            
            NSString *imageName = [Card findImageNameByIconType:[Card generateIconTypeForInstance:selectedTag]];
            
            UIImage *cardImagePlaceholder = [UIImage imageNamed:imageName];
            UIImageView *cardImagePlaceholderView = [[UIImageView alloc] initWithImage:cardImagePlaceholder];
            cardImagePlaceholderView.bounds = CGRectMake(0, 0, selectedCardView.bounds.size.width, selectedCardView.bounds.size.height);
            [selectedCardView addSubview:cardImagePlaceholderView];
            
            [self.view addSubview:selectedCardView];
            [self.view bringSubviewToFront:selectedCardView];
            
        }
        
    }
    
    //--- If card is already selected, then check state and drag or end
    else{
        
        //--- End drag / Check drop point
        if(gesture.state == UIGestureRecognizerStateEnded){
            [self dropDetectAtCoordinates:tapLocation];
            [selectedCardView removeFromSuperview];
            selectedCardView = Nil;
            selectedTag = 0;
        }
        
        //--- Drag
        else if(gesture.state == UIGestureRecognizerStateChanged){
            [UIView animateWithDuration:0.1 animations:^{
                [selectedCardView setFrame:CGRectMake(locationX, locationY, squareWidth, squareHeight)];
            }];
            
        }
        
    }
    
}

//--- Detect the drop point of the card
-(void) dropDetectAtCoordinates: (CGPoint) coordinates{
    
    for(UICollectionViewCell *cellView in peopleCollection.visibleCells){
        
        CGRect frame = [peopleCollection convertRect:cellView.frame toView:self.view];
        
        float cellXMin = frame.origin.x;
        float cellXMax = frame.origin.x + frame.size.width;
        
        float cellYMin = frame.origin.y;
        float cellYMax = frame.origin.y + frame.size.height;
        
        //--- Check if the card fits in ANY of the cells
        if( (coordinates.x >= cellXMin && coordinates.x <= cellXMax) && (coordinates.y >= cellYMin && coordinates.y <= cellYMax) ){
            
            NSIndexPath *cellIndexPath = [peopleCollection indexPathForCell:cellView];
            
            if(cellIndexPath.row < peopleArray.count){
            
                NSDictionary *memberObject = [peopleArray objectAtIndex:cellIndexPath.row];
                
                [Utils shareCard:[selectedCard associatedCDCardObject] withMember:[memberObject valueForKey:@"id"] callback:^{
                   
                    [[[UIAlertView alloc] initWithTitle:@"Sent" message:@"Request has been sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                    
                }];
                
            }
            
        }
        
    }
    
}

#pragma mark CollectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSUInteger total = [peopleArray count];
    
//    if(total == 0){
//    
//        total = 6;
//    
//    }else if([peopleArray count] < 6){
//        
//        total = [peopleArray count] + 6%[peopleArray count];
//        
//    }
//    
//    NSLog(@"Total %lu", (unsigned long)total);
    
    return total;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    peopleCircle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(!cell){
        cell = [[peopleCircle alloc] init];
    }
    
    if(indexPath.row < peopleArray.count){
        NSDictionary *peopleObject = [peopleArray objectAtIndex:indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[peopleObject valueForKey:@"image"]]];
    }
    
    return cell;
    
}

#pragma mark CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region{
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region{
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region{
    
    NSMutableArray *beaconMutableArray = [[NSMutableArray alloc] init];
    
    for(CLBeacon *beacon in beacons){
        
        int major = [[NSString stringWithFormat:@"%@", beacon.major] intValue];
        int minor = [[NSString stringWithFormat:@"%@", beacon.minor] intValue];
        
        [beaconMutableArray addObject:[broadcast decodeForUserIdWithMajor:major andMinor:minor]];
        
    }
    
    [self requestUserInfoFromServer:beaconMutableArray];
    
}

-(void)requestUserInfoFromServer: (NSMutableArray *)requestArray{
    
    if(didRange == NO){
        
        didRange = YES;
        
        if(requestArray){
            
            [Utils queryMemberInfo:requestArray withCallback:^(NSDictionary *queryObject) {
                
                NSLog(@"QUery Object: %@", [queryObject objectForKey:@"members"]);
                
                didRange = NO;
                
                peopleArray = (NSArray *)[queryObject objectForKey:@"members"];
                [peopleCollection reloadData];
                
            }];
            
        }else{
            
            didRange = NO;
            
        }
        
    }
    
}

+(int)randomNumberBetween: (int)lowerBound and: (int)upperBound{
    return lowerBound + arc4random() % (upperBound - lowerBound);
}

- (IBAction)openMyContacts:(id)sender {
    [self performSegueWithIdentifier:@"contactsSegue" sender:Nil];
}

@end
