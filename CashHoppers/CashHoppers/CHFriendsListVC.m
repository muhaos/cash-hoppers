//
//  CHFriendsListVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFriendsListVC.h"
#import "CHFriendsListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CHFriendsFeedManager.h"
#import "CHFriendsFeedItem.h"
#import "CHUser.h"
#import "CHHopTask.h"
#import "CHHop.h"
#import "CHAPIClient.h"
#import "CHDetailsFeedVC.h"

@interface CHFriendsListVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;
@property (assign, nonatomic) BOOL friendsButtonActive;

@property (nonatomic, strong) id friendsFeedUpdatedNotification;
@property (nonatomic, strong) id globalFeedUpdatedNotification;
@property (nonatomic, strong) id feedItemUpdatedNotification;

@property (nonatomic, strong) NSMutableArray* feedItems;

@end

@implementation CHFriendsListVC
@synthesize friendsTable;


- (void)viewDidLoad
{
    [self setupTriangleBackButton];
    self.friendsButtonActive = YES;
    [self activeButton:YES];
    
    self.friendsFeedUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_FRIEND_FEED_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self refreshList];
    }];

    self.globalFeedUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_GLOBAL_FEED_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self refreshList];
    }];
    
    self.feedItemUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_FEED_ITEM_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        
        CHFriendsFeedItem* updatedItem = note.object;
        NSUInteger index = [self.feedItems indexOfObject:updatedItem];
        if (index != NSNotFound) {
            [self.friendsTable beginUpdates];
            [self.friendsTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.friendsTable endUpdates];
        }
    }];
    
    [[CHFriendsFeedManager instance] refreshFeeds];
    [self refreshList];
}


- (void) refreshList {
    if (self.friendsButtonActive) {
        self.feedItems = [CHFriendsFeedManager instance].friendsFeedItems;
    } else {
        self.feedItems = [CHFriendsFeedManager instance].globalFeedItems;
    }
    
    [self.friendsTable reloadData];
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}
    

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.oldNavBarStatus = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailsFeed"]){
        
        CHDetailsFeedVC *detailVC = (CHDetailsFeedVC*)segue.destinationViewController;
        detailVC.feedItem = (CHFriendsFeedItem*)[self.feedItems objectAtIndex:[friendsTable indexPathForSelectedRow].row];
        
    }
}

#pragma mark -  tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedItems.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 157;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *friendsCellIdentifier = @"friends_list_cell";
    
    CHFriendsListCell *cell = (CHFriendsListCell*) [tableView dequeueReusableCellWithIdentifier:friendsCellIdentifier];
    
    CHFriendsFeedItem *fItem = (CHFriendsFeedItem*)[self.feedItems objectAtIndex:indexPath.row];
    cell.delegate = self;
    NSString *name = fItem.user.first_name;
    NSString *lastName = fItem.user.last_name;
    NSString *namePersonText = [name stringByAppendingFormat:@" %@",lastName];

    NSTimeInterval time = [fItem.hop.time_end timeIntervalSinceNow];
//    int timeSinceCompleted = time/60;
    
    [[cell namePersonLabel] setText:namePersonText];
    [[cell nameHopLabel] setText:fItem.hop.name];
    [[cell timeLabel] setText:@"some time ago"];
    
    [[cell photoHopImageView] setImageWithURL:[fItem hopImageURL]];
    [[cell photoPersonImageView] setImageWithURL:[fItem.user avatarURL]];
    
    [[cell taskCompletedLabel] setText:[fItem completedTaskName]];
    [[cell addFriendButton] setImage:[UIImage imageNamed:@"button_add_friend"] forState:UIControlStateNormal];
    
    //cell.timeLabel.text = [NSString stringWithFormat:@"%i m",timeSinceCompleted];
    cell.numberLikesLabel.text = [fItem.numberOfLikes stringValue];
    [cell numberCommentsLabel].layer.cornerRadius = 3.0f;
    [cell numberLikesLabel].layer.cornerRadius = 3.0f;
    
    [cell.imageView setImage:nil];
    

    if (self.friendsButtonActive == YES) {
        
        [[cell commentButton] setHidden:NO];
        [[cell likeButton] setHidden:NO];
        [[cell numberCommentsLabel] setHidden:NO];
        [[cell numberLikesLabel] setHidden:NO];
        [[cell verticalSeparatorImageView] setHidden:NO];
        [[cell addFriendButton] setHidden:YES];
        
        if ([[cell numberCommentsLabel] isEqual: @""]  &&  [[cell numberLikesLabel] isEqual: @""]) {
            [[cell commentButton] setBackgroundImage:[UIImage imageNamed:@"comment_icon_n"] forState:UIControlStateNormal];
            [[cell likeButton] setBackgroundImage:[UIImage imageNamed:@"like_icon_n"] forState:UIControlStateNormal];
            [[cell numberCommentsLabel] setHidden:YES];
            [[cell numberLikesLabel] setHidden:YES];
        } else {
            [[cell commentButton] setBackgroundImage:[UIImage imageNamed:@"comment_icon_on"] forState:UIControlStateNormal];
            if([fItem.liked integerValue]==0){
                [[cell likeButton] setBackgroundImage:[UIImage imageNamed:@"like_icon_off"] forState:UIControlStateNormal];
            }else{
                [[cell likeButton] setBackgroundImage:[UIImage imageNamed:@"like_icon_on"] forState:UIControlStateNormal];

            }
            
        }
        
    } else {
        [[cell commentButton] setHidden:YES];
        [[cell likeButton] setHidden:YES];
        [[cell numberCommentsLabel] setHidden:YES];
        [[cell numberLikesLabel] setHidden:YES];
        [[cell verticalSeparatorImageView] setHidden:YES];
        [[cell addFriendButton] setHidden:NO];
        
    }
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [self performSegueWithIdentifier:@"detailsFeed" sender:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)friendsButtonTapped:(id)sender {
    self.friendsButtonActive = YES;
    [self activeButton:self.friendsButtonActive];
    [self refreshList];
}


- (IBAction)allHopppersButtonTapped:(id)sender {
    self.friendsButtonActive = NO;
    [self activeButton:self.friendsButtonActive];
    [self refreshList];
}


- (IBAction)addFriendTapped:(id)sender {
}


-(void)activeButton:(BOOL)friendsButton {
    if (friendsButton == YES) {
        [self.friendsButton setImage:[UIImage imageNamed:@"button_friends_ac"] forState:UIControlStateNormal];
        [self.allHoppersButton setImage:[UIImage imageNamed:@"button_all_hops_no"] forState:UIControlStateNormal];
    } else {
        [self.friendsButton setImage:[UIImage imageNamed:@"button_friends_no"] forState:UIControlStateNormal];
        [self.allHoppersButton setImage:[UIImage imageNamed:@"button_all_hops_ac"] forState:UIControlStateNormal];
    }
}

- (void)likeTappedInCell:(CHFriendsListCell*)cell{
    NSIndexPath *indPath = [friendsTable indexPathForCell:cell];
    CHFriendsFeedItem *fItem = (CHFriendsFeedItem*)[_feedItems objectAtIndex:indPath.row];

    if([fItem.liked boolValue]){
        return;
    }
    
    [[CHFriendsFeedManager instance]postLikeForFeedItem:fItem completionHandler:^(NSError *error) {
        if(!error){
            [[cell likeButton] setBackgroundImage:[UIImage imageNamed:@"like_icon_on"] forState:UIControlStateNormal];
            fItem.liked = @1;
            fItem.numberOfLikes = @([fItem.numberOfLikes intValue]+1);
            cell.numberLikesLabel.text = [NSString stringWithFormat:@"%d", [fItem.numberOfLikes intValue]];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setFriendsTable:nil];
    [self setFriendsButton:nil];
    [self setAllHoppersButton:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.friendsFeedUpdatedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.globalFeedUpdatedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.feedItemUpdatedNotification];
    
    [super viewDidUnload];
}


@end
