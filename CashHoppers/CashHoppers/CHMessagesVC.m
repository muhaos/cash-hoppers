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
#import "CHMessagesManager.h"
#import "AFNetworking.h"

@interface CHMessagesVC ()

@property (assign, nonatomic) BOOL messagesButtonActive;
@property (nonatomic, retain) NSArray* currentMessagesList;

@end

@implementation CHMessagesVC
@synthesize messagesTable;

- (void)viewDidLoad
{
    self.messagesButtonActive = YES;   
    [self activeButton:YES];
    
    [[CHMessagesManager instance] loadMessagesOverviewWithCompletionHandler:^(NSArray* messages){
        self.currentMessagesList = messages;
        [messagesTable reloadData];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentMessagesList count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messagesCellIdentifier = @"messages_cell_id";
    
    CHMessagesCell *cell = (CHMessagesCell*) [tableView dequeueReusableCellWithIdentifier:messagesCellIdentifier];

    CHMessage* message = [self.currentMessagesList objectAtIndex:indexPath.row];
    
    NSString* friendName = [NSString stringWithFormat:@"%@ %@", message.friend_first_name, message.friend_last_name];
    [[cell nameLabel] setText:friendName];
    [[cell timeLabel] setText:@"some time ago"];
    [[cell photoImageView] setImageWithURL:[message friendAvatarURL]];
    [[cell messageTextView] setText:message.text];
    
    
    if (self.messagesButtonActive == YES) {
        [[cell likeCommentImageView ] setHidden:YES];
        [[cell deleteButton] setHidden:NO];
    } else {
        [[cell likeCommentImageView] setHidden:NO];
        [[cell deleteButton] setHidden:YES];
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
    [self performSegueWithIdentifier:@"individual_message" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)composeMessageTapped:(id)sender {
     [self performSegueWithIdentifier:@"compose_message" sender:self];
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


@end
