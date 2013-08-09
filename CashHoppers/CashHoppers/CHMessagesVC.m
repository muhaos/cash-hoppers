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
#import "CHDetailsFeedVC.h"
#import "CHFriendsFeedManager.h"


@interface CHMessagesVC () <CHMessagesCellDelegate>

@property (assign, nonatomic) BOOL messagesButtonActive;
@property (nonatomic, retain) NSArray* currentMessagesList;
@property (nonatomic, retain) NSArray* currentNotificationsList;
@property (nonatomic, retain) NSArray* currentItemsList;

@property (nonatomic, retain) id arrivedMessagesNotification;
@property (nonatomic, retain) id notifUpdatedNotification;

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
    
    self.notifUpdatedNotification  = [[NSNotificationCenter defaultCenter] addObserverForName:CH_NOTIFICATION_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {

        if (!self.messagesButtonActive) {
            CHBaseNotification* notif = note.object;
            NSUInteger index = [self.currentItemsList indexOfObject:notif];
            if (index != NSNotFound) {
                [self.messagesTable beginUpdates];
                [self.messagesTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.messagesTable endUpdates];
            }

        }
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
    [self showAdsWithType:@"RPOU" andHopID:nil];
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


- (void) acceptTappedForNotification:(CHFriendInviteNotification*) notif {
    
}


- (void) declineTappedForNotification:(CHFriendInviteNotification*) notif {
    
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
    
    cell.acceptButton.hidden = YES;
    cell.declineButton.hidden = YES;
    
    if (self.messagesButtonActive) {
        CHMessage* message = [self.currentItemsList objectAtIndex:indexPath.row];
        
        NSString* friendName = [NSString stringWithFormat:@"%@ %@", message.friend_first_name, message.friend_last_name];
        [[cell nameLabel] setText:friendName];
        [[cell photoImageView] setImageWithURL:[message friendAvatarURL]];
        [cell setDefaultAttributedTextForString:message.text];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ ago", message.time_ago];
        [[cell likeCommentImageView] setHidden:NO];
        [[cell likeCommentImageView ] setImage:[UIImage imageNamed:@"comment_icon_on"]];
    } else {
        CHBaseNotification* notif = [self.currentItemsList objectAtIndex:indexPath.row];

        cell.currentNotification = notif;
        cell.delegate = self;
        
        [[cell nameLabel] setText: notif.userName];
        [[cell photoImageView] setImageWithURL: [notif userAvatarURL]];
        cell.messageLabel.attributedText = [notif notificationDescription];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ ago", notif.time_ago];
        
        switch (notif.notificationType) {
            case CHNotificationTypeNone:
            case CHNotificationTypeFriendInviteAccepted:
            case CHNotificationTypeEndOfHop: {
                [[cell likeCommentImageView] setHidden:YES];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                break;
            }
            case CHNotificationTypeFriendInvite: {
                cell.acceptButton.hidden = NO;
                cell.declineButton.hidden = NO;

                [[cell likeCommentImageView] setHidden:YES];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                break;
            }
            case CHNotificationTypeComment: {
                [[cell likeCommentImageView] setHidden:NO];
                [[cell likeCommentImageView ] setImage:[UIImage imageNamed:@"comment_icon_on"]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            }
            case CHNotificationTypeLike: {
                [[cell likeCommentImageView] setHidden:NO];
                [[cell likeCommentImageView ] setImage:[UIImage imageNamed:@"like_icon_on"]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            }
        }
        
        
    }

    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.messagesButtonActive) {
        return indexPath;
    } else {
        
        CHBaseNotification* notif = [self.currentItemsList objectAtIndex:indexPath.row];
        
        switch (notif.notificationType) {
            case CHNotificationTypeFriendInviteAccepted:
            case CHNotificationTypeEndOfHop:
            case CHNotificationTypeFriendInvite: {
                return nil;
            }
            case CHNotificationTypeComment:
            case CHNotificationTypeLike: {
                return indexPath;
            }
        }

    }
    
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.messagesButtonActive) {
        CHMessage* message = [self.currentMessagesList objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"individual_message" sender:message.friend_id];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        CHBaseNotification* notif = [self.currentItemsList objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"news_feed_segue" sender:notif];
    }
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"individual_message"]) {
        CHIndividualMessageVC* vc = (CHIndividualMessageVC*)segue.destinationViewController;
        vc.currentFriendID = sender;
    }
    if ([segue.identifier isEqualToString:@"news_feed_segue"]) {
        
        CHBaseNotification* notif = (CHBaseNotification*)sender;
        CHFriendsFeedItem* feedItem = nil;
        
        switch (notif.notificationType) {
            case CHNotificationTypeFriendInviteAccepted:
            case CHNotificationTypeEndOfHop:
            case CHNotificationTypeFriendInvite: {
                break;
            }
            case CHNotificationTypeComment: {
                feedItem = ((CHCommentNotification*)notif).feedItem;
                break;
            }
            case CHNotificationTypeLike: {
                feedItem = ((CHLikeNotification*)notif).feedItem;
                break;
            }
        }
        
        CHDetailsFeedVC *detailVC = (CHDetailsFeedVC*)segue.destinationViewController;
        detailVC.feedItem = feedItem;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self.notifUpdatedNotification];
    [self setMessagesTable:nil];
    [self setMessagesButton:nil];
    [self setNotificationsButton:nil];
    [super viewDidUnload];
}


@end
