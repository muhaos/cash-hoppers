//
//  CHAddFriendsCell.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAddFriendsCell.h"
#import "CHStartVC.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation CHAddFriendsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (IBAction)addFriendTapped:(id)sender
{
    [self.delegate selectedFollowerWithID:[self.userDic objectForKey:@"id_str"]];
    self.addButton.hidden = YES;
}


@end
