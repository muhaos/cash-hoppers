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


@interface CHFriendsListVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;
@property (assign, nonatomic) BOOL friendsButtonActive;

@end

@implementation CHFriendsListVC
@synthesize friendsTable;


- (void)viewDidLoad
{
    [self setupTriangleBackButton];
    self.friendsButtonActive = YES;
    [self activeButton:YES];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 157;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *friendsCellIdentifier = @"friends_list_cell";
    
    CHFriendsListCell *cell = (CHFriendsListCell*) [tableView dequeueReusableCellWithIdentifier:friendsCellIdentifier];

    [[cell namePersonLabel] setText:@"Brian Kelly"];
    [[cell nameHopLabel] setText:@"NBM Trade Show HOP"];
    [[cell timeLabel] setText:@"15 mins ago"];
    [[cell photoHopImageView] setImage:[UIImage imageNamed:@"photo_hop"]];
    [[cell photoPersonImageView] setImage:[UIImage imageNamed:@"photo_BrianKelly"]];
    [[cell taskCompletedLabel] setText:@"Screen Printer"];
    [[cell addFriendButton] setImage:[UIImage imageNamed:@"button_add_friend"] forState:UIControlStateNormal];
    [cell numberCommentsLabel].layer.cornerRadius = 3.0f;
    [cell numberLikesLabel].layer.cornerRadius = 3.0f;
    
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
            [[cell likeButton] setBackgroundImage:[UIImage imageNamed:@"like_icon_on"] forState:UIControlStateNormal];
            [[cell numberCommentsLabel] setText:@"10"];
            [[cell numberLikesLabel] setText:@"5"];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setFriendsTable:nil];
    [self setFriendsButton:nil];
    [self setAllHoppersButton:nil];
    [super viewDidUnload];
}


- (IBAction)friendsButtonTapped:(id)sender {
    self.friendsButtonActive = YES;
    [self activeButton:self.friendsButtonActive];
    [friendsTable reloadData];
}


- (IBAction)allHopppersButtonTapped:(id)sender {
    self.friendsButtonActive = NO;
    [self activeButton:self.friendsButtonActive];
    [friendsTable reloadData];
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


@end
