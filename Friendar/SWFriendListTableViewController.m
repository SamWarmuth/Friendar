//
//  SWFriendListTableViewController.m
//  Friendar
//
//  Created by Sam Warmuth on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWFriendListTableViewController.h"
#import "SWFriendCell.h"
#import "SWFriendListRequestCell.h"
#import "SWUserDetailViewController.h"
#import "SWHelpers.h"

@interface SWFriendListTableViewController ()

@end

@implementation SWFriendListTableViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isLoading)[self loadObjects];
    //either it will be zero (right after first login), or one (just you).
    if (self.objects.count == 0){
        [SVProgressHUD show];
        [SVProgressHUD dismissWithSuccess:@"You don't have any friends. Tap the '+' button above to add some!" afterDelay:100];
    } else {
        [SVProgressHUD dismiss];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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
    [query whereKey:@"friends" equalTo:[PFUser currentUser]];
    
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
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *youPredicate = [NSPredicate predicateWithFormat:@"objectId MATCHES %@", object.objectId];
    NSArray *youFilteredArray = [[currentUser objectForKey:@"friends"] filteredArrayUsingPredicate:youPredicate];
    BOOL youFriended = ([youFilteredArray count] != 0);
    if (!youFriended){
        //If you haven't friended them, this means that it is a request.
        static NSString *CellIdentifier = @"SWFriendListRequestCell";    
        SWFriendListRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SWFriendListRequestCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.emailLabel.text = [NSString stringWithFormat:@"%@ %@", [object objectForKey:@"firstName"], [object objectForKey:@"lastName"]];
        cell.avatarImageView.layer.cornerRadius = 4.0;
        cell.avatarImageView.clipsToBounds = TRUE;
        
        if ([object objectForKey:@"profilePicture"]) cell.avatarImageView.image = [UIImage imageWithData:[object objectForKey:@"profilePicture"]];
        else cell.avatarImageView.image = [UIImage imageNamed:@"avatar"];

        return cell;
    } else {
        //normal friend
        static NSString *CellIdentifier = @"SWFriendCell";    
        SWFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SWFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.emailLabel.text = [NSString stringWithFormat:@"%@ %@", [object objectForKey:@"firstName"], [object objectForKey:@"lastName"]];
        cell.avatarImageView.layer.cornerRadius = 4.0;
        cell.avatarImageView.clipsToBounds = TRUE;
        if ([object objectForKey:@"profilePicture"]) cell.avatarImageView.image = [UIImage imageWithData:[object objectForKey:@"profilePicture"]];
        else cell.avatarImageView.image = [UIImage imageNamed:@"avatar"];

    
        NSDictionary *currentAddress = [object objectForKey:@"current"];
        
        if (currentAddress == nil || [[NSDate date] timeIntervalSinceDate:(NSDate *)[currentAddress objectForKey:@"timestamp"]] > 60*60*2){
            cell.locationLabelOne.text = @"";
            cell.locationLabelTwo.text = @"Location Not Available";
        } else {
            cell.locationLabelOne.text = [NSString stringWithFormat:@"%@ %@", [currentAddress valueForKey:@"streetNumber"], [currentAddress valueForKey:@"street"]];
            cell.locationLabelTwo.text = [NSString stringWithFormat:@"%@, %@", [currentAddress valueForKey:@"city"], [currentAddress valueForKey:@"state"]];
        }
        
        
        if (cell.pushConfirmButton != nil){
            [cell.pushConfirmButton removeFromSuperview];
            cell.pushConfirmButton = nil;
        }
        
        if ([object.objectId isEqualToString:[PFUser currentUser].objectId]){
            cell.pushConfirmButton = [MAConfirmButton buttonWithDisabledTitle:@"You"];
        } else {
            cell.pushConfirmButton = [MAConfirmButton buttonWithTitle:@"Send Ping" confirm:@"Confirm"];
            [cell.pushConfirmButton addTarget:self action:@selector(spotConfirmPressed:) forControlEvents:UIControlEventTouchUpInside];	
            [cell.pushConfirmButton setTintColor:[UIColor colorWithRed:0.024 green:0.514 blue:0.796 alpha:1.]];
        }
        
        [cell.pushConfirmButton setAnchor:CGPointMake(300, 15)];	
        cell.pushConfirmButton.tag = indexPath.row + SWButtonTagOffset; 
        [cell addSubview:cell.pushConfirmButton]; 
        return cell;
    }

}

- (void)spotConfirmPressed:(MAConfirmButton *)button
{
    int userIndex = button.tag - SWButtonTagOffset;
    PFUser *selectedUser = [self.objects objectAtIndex:userIndex];
    [SWHelpers pingUser:selectedUser];
    [button disableWithTitle:@"Ping Sent"];
}

- (void)objectsWillLoad
{
    //NSLog(@"Loading....?");
}
- (void)objectsDidLoad:(NSError *)error
{
    //NSLog(@"Loaded....? :: %@ :: %d", error, self.objects.count);
    if (self.objects.count == 0){
        [SVProgressHUD show];
        [SVProgressHUD dismissWithSuccess:@"You don't have any friends. Tap the '+' button above to add some!" afterDelay:100];
    } else {
        [SVProgressHUD dismiss];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SWMainToDetail"]){
        SWUserDetailViewController *destinationView = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFUser *user = [self.objects objectAtIndex:indexPath.row];
        destinationView.user = user;
    }

}

@end


