//
//  CHMessagesCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/18/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHFriendInviteNotification;
@class CHBaseNotification;

@protocol CHMessagesCellDelegate <NSObject>

- (void) acceptTappedForNotification:(CHFriendInviteNotification*) notif;
- (void) declineTappedForNotification:(CHFriendInviteNotification*) notif;

@end


@interface CHMessagesCell : UITableViewCell

@property (nonatomic, assign) id <CHMessagesCellDelegate> delegate;
@property (nonatomic, retain) CHBaseNotification* currentNotification;

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *likeCommentImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
// friends notif
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *declineButton;

- (IBAction) acceptTapped:(id)sender;
- (IBAction) declineTapped:(id)sender;

- (IBAction)deleteButtonTapped:(id)sender;
- (void) setDefaultAttributedTextForString:(NSString*) str;

@end
