//
//  CHFriendsListCell.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFriendsListCell.h"
#import "CHAddFriendVC.h"

@implementation CHFriendsListCell
@synthesize numberCommentsLabel;
@synthesize numberLikesLabel;
@synthesize currentFeedItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)commentTapped:(id)sender {
}

- (IBAction)likeTapped:(id)sender {
    
    [_delegate likeTappedInCell:self];
    
}


- (IBAction)addFriendTapped:(id)sender
{
    [self.delegate addToFriendsTappedInCell: self];
}


@end
