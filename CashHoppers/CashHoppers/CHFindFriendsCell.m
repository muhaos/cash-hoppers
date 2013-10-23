//
//  CHFindFriendsCell.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFindFriendsCell.h"

@implementation CHFindFriendsCell
@synthesize nameLabel, photoImageView;

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

@end
