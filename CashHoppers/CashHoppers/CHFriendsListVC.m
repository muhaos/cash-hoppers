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

@end

@implementation CHFriendsListVC
@synthesize friendsTable;


- (void)viewDidLoad
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"button_nav_back"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
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
    
    [cell numberCommentsLabel].layer.cornerRadius = 3.0f;
    [cell numberLikesLabel].layer.cornerRadius = 3.0f;
    
    if (indexPath.row == 0) {
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
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setFriendsTable:nil];
    [super viewDidUnload];
}

@end
