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
    
    cell.emailLabel.text = [object objectForKey:@"email"];
    cell.avatarImageView.clipsToBounds = TRUE;
    if (cell.addConfirmButton != nil){
        [cell.addConfirmButton removeFromSuperview];
        cell.addConfirmButton = nil;
    }
    
    if ([object.objectId isEqualToString:[PFUser currentUser].objectId]){
        cell.addConfirmButton = [MAConfirmButton buttonWithDisabledTitle:@"You"];
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
    NSLog(@"Add Friend");
    [button disableWithTitle:@"Request Sent"];

    
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


