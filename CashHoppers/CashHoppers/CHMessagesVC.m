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
#import "CHIndividualMessageVC.h"
#import "CHNotificationsManager.h"

@interface CHMessagesVC ()

@property (assign, nonatomic) BOOL messagesButtonActive;
@property (nonatomic, retain) NSArray* currentMessagesList;
@property (nonatomic, retain) NSArray* currentNotificationsList;
@property (nonatomic, retain) NSArray* currentItemsList;

@property (nonatomic, retain) id arrivedMessagesNotification;

@end

@implementation CHMessagesVC
@synthesize messagesTable;

- (void)viewDidLoad
{
    self.messagesButtonActive = YES;   
    [self activeButton:YES];
    
    
    self.arrivedMessagesNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_NEW_MESSAGES_ARRIVED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self reloadData];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}


- (void) reloadData {
    
    if (self.messagesButtonActive) {
        self.currentItemsList = self.currentMessagesList;
        
        [[CHMessagesManager instance] loadMessagesOverviewWithCompletionHandler:^(NSArray* messages){
            self.currentMessagesList = messages;
            if (self.messagesButtonActive) {
                self.currentItemsList = self.currentMessagesList;
                [messagesTable reloadData];
            }
        }];
    } else {
        self.currentItemsList = self.currentNotificationsList;
        
        [[CHNotificationsManager instance] loadNotificationsWithCompletionHandler:^(NSArray* notifications) {
            self.currentNotificationsList = notifications;
            if (!self.messagesButtonActive) {
                self.currentItemsList = self.currentNotificationsList;
                [messagesTable reloadData];
            }
        }];
    }

    [messagesTable reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentItemsList count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messagesCellIdentifier = @"messages_cell_id";
    
    CHMessagesCell *cell = (CHMessagesCell*) [tableView dequeueReusableCellWithIdentifier:messagesCellIdentifier];

    if (self.messagesButtonActive) {
        CHMessage* message = [self.currentItemsList objectAtIndex:indexPath.row];
        
        NSString* friendName = [NSString stringWithFormat:@"%@ %@", message.friend_first_name, message.friend_last_name];
        [[cell nameLabel] setText:friendName];
        [[cell photoImageView] setImageWithURL:[message friendAvatarURL]];
        [[cell messageTextView] setText:message.text];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ ago", message.time_ago];
        [[cell likeCommentImageView] setHidden:NO];
        [[cell likeCommentImageView ] setImage:[UIImage imageNamed:@"comment_icon_on"]];
    } else {
        CHBaseNotification* notif = [self.currentItemsList objectAtIndex:indexPath.row];
        
        [[cell nameLabel] setText: notif.userName];
        [[cell photoImageView] setImageWithURL: [notif userAvatarURL]];
        [[cell messageTextView] setText: [notif notificationDescription]];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ ago", notif.time_ago];

        
        switch (notif.notificationType) {
            case CHNotificationTypeFriendInvite: {
                [[cell likeCommentImageView] setHidden:YES];
                break;
            }
            case CHNotificationTypeEndOfHop: {
                [[cell likeCommentImageView] setHidden:YES];
                break;
            }
            case CHNotificationTypeComment: {
                [[cell likeCommentImageView] setHidden:NO];
                [[cell likeCommentImageView ] setImage:[UIImage imageNamed:@"comment_icon_on"]];
                break;
            }
            case CHNotificationTypeLike: {
                [[cell likeCommentImageView] setHidden:NO];
                [[cell likeCommentImageView ] setImage:[UIImage imageNamed:@"like_icon_on"]];
                break;
            }
            case CHNotificationTypeFriendInviteAccepted: {
                [[cell likeCommentImageView] setHidden:YES];
                break;
            }
        }
        
        
    }

    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHMessage* message = [self.currentMessagesList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"individual_message" sender:message.friend_id];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"individual_message"]) {
        CHIndividualMessageVC* vc = (CHIndividualMessageVC*)segue.destinationViewController;
        vc.currentFriendID = sender;
    }
}

- (IBAction)messagesTapped:(id)sender {
    self.messagesButtonActive = YES;
    [self activeButton:self.messagesButtonActive];
    [self reloadData];
}


- (IBAction)notificationsTapped:(id)sender {
    self.messagesButtonActive = NO;
    [self activeButton:self.messagesButtonActive];
    [self reloadData];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self.arrivedMessagesNotification];
    [self setMessagesTable:nil];
    [self setMessagesButton:nil];
    [self setNotificationsButton:nil];
    [super viewDidUnload];
}


@end
