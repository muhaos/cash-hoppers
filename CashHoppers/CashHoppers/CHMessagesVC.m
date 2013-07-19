//
//  CHMessagesVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/18/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHMessagesVC.h"
#import "CHMessagesCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CHMessagesVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;
@property (assign, nonatomic) BOOL messagesButtonActive;

@end

@implementation CHMessagesVC
@synthesize messagesTable;

- (void)viewDidLoad
{
    self.messagesButtonActive = YES;   
    [self activeButton:YES];
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
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messagesCellIdentifier = @"messages_cell_id";
    
    CHMessagesCell *cell = (CHMessagesCell*) [tableView dequeueReusableCellWithIdentifier:messagesCellIdentifier];
    
    if (self.messagesButtonActive == YES) {
        [[cell nameLabel] setText:@"Brian Kelly"];
        [[cell timeLabel] setText:@"30 mins ago"];
        [[cell photoImageView] setImage:[UIImage imageNamed:@"photo_BrianKelly.png"]];
        [[cell messageTextView] setText:@"Comented on your completed Hop Item Screen Printer"];
        [[cell likeCommentImageView ] setHidden:YES];
    } else {
        [[cell nameLabel] setText:@"Brian Kelly"];
        [[cell timeLabel] setText:@"30 mins ago"];
        [[cell photoImageView] setImage:[UIImage imageNamed:@"photo_BrianKelly.png"]];
        [[cell messageTextView] setText:@"Comented on your completed Hop Item Screen Printer"];
        [[cell likeCommentImageView] setHidden:NO];
        if (indexPath.row == 0) {
            [[cell likeCommentImageView ] setImage:[UIImage imageNamed:@"comment_icon_on"]];
        }else{
            [[cell likeCommentImageView ] setImage:[UIImage imageNamed:@"like_icon_on"]];
        }
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
    [self setMessagesTable:nil];
    [self setMessagesButton:nil];
    [self setNotificationsButton:nil];
    [super viewDidUnload];
}


- (IBAction)messagesTapped:(id)sender {
    self.messagesButtonActive = YES;
    [self activeButton:self.messagesButtonActive];
    [messagesTable reloadData];
}


- (IBAction)notificationsTapped:(id)sender {
    self.messagesButtonActive = NO;
    [self activeButton:self.messagesButtonActive];
    [messagesTable reloadData];
}


-(void)activeButton:(BOOL)messagesButton {
    if (messagesButton == YES) {
        [self.messagesButton setImage:[UIImage imageNamed:@"button_messages_n"] forState:UIControlStateNormal];
        [self.notificationsButton setImage:[UIImage imageNamed:@"button_notifications_act"] forState:UIControlStateNormal];
    } else {
        [self.messagesButton setImage:[UIImage imageNamed:@"button_messages_act"] forState:UIControlStateNormal];
        [self.notificationsButton setImage:[UIImage imageNamed:@"button_notifications_n"] forState:UIControlStateNormal];
    }
}


@end
