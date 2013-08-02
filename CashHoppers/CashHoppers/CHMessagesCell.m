//
//  CHMessagesCell.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/18/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHMessagesCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation CHMessagesCell
@synthesize photoImageView, nameLabel, likeCommentImageView, messageTextView, timeLabel, deleteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


//messages_cell_id

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonTapped:(id)sender {
}


- (void) awakeFromNib {
    [self photoImageView].layer.cornerRadius = 20.0f;
    [self photoImageView].layer.masksToBounds = YES;
}

@end
