//
//  CHIndividualMessageCell.m
//  CashHoppers
//
//  Created by Vova Musiienko on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHIndividualMessageCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation CHIndividualMessageCell

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

    // Configure the view for the selected state
}


- (void) awakeFromNib {
    [super awakeFromNib];
    self.messageTextView.font = [UIFont fontWithName:@"DroidSans" size:12.0f];
    self.avatarImageView.layer.cornerRadius = 22.0f;
    self.avatarImageView.layer.masksToBounds = YES;
}


@end
