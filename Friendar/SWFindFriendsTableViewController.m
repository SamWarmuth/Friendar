//
//  SWFindFriendsTableViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWFindFriendsTableViewController.h"
#import "SWAddFriendCell.h"

@interface SWFindFriendsTableViewController ()

@end

@implementation SWFindFriendsTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"User"];
    self = [super initWithCoder:aDecoder];
    if (self) {        
        // The className to query on
        self.className = @"User";
        
        // The key of the PFObject to display in the label of the default cell style
        self.keyToDisplay = @"email";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 250;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryForUser];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *CellIdentifier = @"SWAddFriendCell";    
    SWAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SWAddFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.emailLabel.text = [NSString stringWithFormat:@"%@ %@", [object objectForKey:@"firstName"], [object objectForKey:@"lastName"]];
    cell.avatarImageView.clipsToBounds = TRUE;
    if ([object objectForKey:@"profilePicture"]) cell.avatarImageView.image = [UIImage imageWithData:[object objectForKey:@"profilePicture"]];
    else cell.avatarImageView.image = [UIImage imageNamed:@"avatar"];
    
    if (cell.addConfirmButton != nil){
        [cell.addConfirmButton removeFromSuperview];
        cell.addConfirmButton = nil;
    }
    
    NSPredicate *youPredicate = [NSPredicate predicateWithFormat:@"objectId MATCHES %@", object.objectId];
    NSArray *youFilteredArray = [[[PFUser currentUser] valueForKey:@"friends"] filteredArrayUsingPredicate:youPredicate];
    BOOL youFriended = ([youFilteredArray count] != 0);
    
    NSPredicate *theyPredicate = [NSPredicate predicateWithFormat:@"objectId MATCHES %@", [PFUser currentUser].objectId];
    NSArray *theyFilteredArray = [[object valueForKey:@"friends"] filteredArrayUsingPredicate:theyPredicate];
    BOOL theyFriended = ([theyFilteredArray count] != 0);
    
    
    
    if ([object.objectId isEqualToString:[PFUser currentUser].objectId]){
        cell.addConfirmButton = [MAConfirmButton buttonWithDisabledTitle:@"You"];
    } else if (youFriended && theyFriended) {
        cell.addConfirmButton = [MAConfirmButton buttonWithDisabledTitle:@"Friend"];
    } else if (youFriended && !theyFriended) {
        cell.addConfirmButton = [MAConfirmButton buttonWithDisabledTitle:@"Request Sent"];
    } else if (!youFriended && theyFriended) {
        cell.addConfirmButton = [MAConfirmButton buttonWithTitle:@"Accept" confirm:nil];
        [cell.addConfirmButton addTarget:self action:@selector(addFriendPressed:) forControlEvents:UIControlEventTouchUpInside];	
        [cell.addConfirmButton setTintColor:[UIColor colorWithRed:0.380 green:0.792 blue:0.161 alpha:1.]];
    } else {
        cell.addConfirmButton = [MAConfirmButton buttonWithTitle:@"Add Friend" confirm:@"Confirm"];
        [cell.addConfirmButton addTarget:self action:@selector(addFriendPressed:) forControlEvents:UIControlEventTouchUpInside];	
        [cell.addConfirmButton setTintColor:[UIColor colorWithRed:0.024 green:0.514 blue:0.796 alpha:1.]];
    }
    
    [cell.addConfirmButton setAnchor:CGPointMake(300, 8)];	
    cell.addConfirmButton.tag = indexPath.row + SWButtonTagOffset; 
    [cell addSubview:cell.addConfirmButton]; 
    
    return cell;
}

- (void)addFriendPressed:(MAConfirmButton *)button
{
    PFUser *selectedUser = [self.objects objectAtIndex:(button.tag - SWButtonTagOffset)];
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *youPredicate = [NSPredicate predicateWithFormat:@"objectId MATCHES %@", selectedUser.objectId];
    NSArray *youFilteredArray = [[currentUser objectForKey:@"friends"] filteredArrayUsingPredicate:youPredicate];
    BOOL youFriended = ([youFilteredArray count] != 0);
    
    NSPredicate *theyPredicate = [NSPredicate predicateWithFormat:@"objectId MATCHES %@", currentUser.objectId];
    NSArray *theyFilteredArray = [[selectedUser objectForKey:@"friends"] filteredArrayUsingPredicate:theyPredicate];
    BOOL theyFriended = ([theyFilteredArray count] != 0);
    
    //If you've already friended them, there's nothing to do. You shouldn't be able to get here.
    if (youFriended) return;
    
    if (theyFriended){
        //confirm request
        NSLog(@"Confirm Request");
        [[currentUser objectForKey:@"friends"] addObject:selectedUser];
        [currentUser saveInBackground];
        
        [button disableWithTitle:@"Friend"];
        NSString *messageText = [NSString stringWithFormat:@"%@ %@ accepted your friend request", [currentUser objectForKey:@"firstName"], [currentUser objectForKey:@"lastName"]];
        NSDictionary *alert = [NSDictionary dictionaryWithObjectsAndKeys:
                               messageText, @"body",
                               @"View", @"action-loc-key",
                               nil];
        
        NSDictionary *pingData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  alert, @"alert",
                                  @"friendRequestConfirm", @"type",
                                  currentUser.objectId, @"senderID", 
                                  nil];
        NSLog(@"confirmed friend request.");
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:[@"U" stringByAppendingString:selectedUser.objectId]];
        [push setData:pingData];
        [push expireAfterTimeInterval:86400];
        [push sendPushInBackground];
    } else{
        //Send request
        NSLog(@"Send Request");
        [[currentUser objectForKey:@"friends"] addObject:selectedUser];
        [currentUser saveInBackground];
        NSString *messageText = [NSString stringWithFormat:@"%@ %@ wants to be your friend", [currentUser objectForKey:@"firstName"], [currentUser objectForKey:@"lastName"]];
        
        NSDictionary *alert = [NSDictionary dictionaryWithObjectsAndKeys:
                               messageText, @"body",
                               @"View", @"action-loc-key",
                               nil];
        
        NSDictionary *pingData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  alert, @"alert",
                                  @"friendRequest", @"type",
                                  currentUser.objectId, @"senderID", 
                                  nil];
        NSLog(@"sending Friend Request.");
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:[@"U" stringByAppendingString:selectedUser.objectId]];
        [push setData:pingData];
        [push expireAfterTimeInterval:86400];
        [push sendPushInBackground];
        [button disableWithTitle:@"Request Sent"];
    }
    

    
    NSLog(@"%@, %@", currentUser, selectedUser);

    
}

- (void)objectsWillLoad
{
    //NSLog(@"Loading....?");
}
- (void)objectsDidLoad:(NSError *)error
{
    //NSLog(@"Loaded....? :: %@ :: %d", error, self.objects.count);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end


