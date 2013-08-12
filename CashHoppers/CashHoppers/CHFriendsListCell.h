//
//  CHFriendsListCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHFriendsFeedItem.h"

@class CHFriendsListCell;

@protocol CHFriendsListCellDelegate <NSObject>

- (void)likeTappedInCell:(CHFriendsListCell*)cell;
- (void)addToFriendsTappedInCell:(CHFriendsListCell*)cell;

@end

@interface CHFriendsListCell : UITableViewCell

@property (nonatomic, weak) id<CHFriendsListCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *photoPersonImageView;
@property (strong, nonatomic) IBOutlet UILabel *namePersonLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskCompletedLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoHopImageView;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *numberCommentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLikesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *verticalSeparatorImageView;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) CHFriendsFeedItem *currentFeedItem;

- (IBAction)commentTapped:(id)sender;
- (IBAction)likeTapped:(id)sender;
- (IBAction)addFriendTapped:(id)sender;

@end
