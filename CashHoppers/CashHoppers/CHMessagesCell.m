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


- (void) setDefaultAttributedTextForString:(NSString *)str {
    NSDictionary *normAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]};
    
    NSMutableAttributedString* mStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSInteger str_length = [str length];
    [mStr setAttributes:normAttribs range:NSMakeRange(0, str_length)];
    
    self.messageLabel.attributedText = mStr;
}


- (IBAction) acceptTapped:(id)sender {
    [self.delegate acceptTappedForNotification:(CHFriendInviteNotification*)self.currentNotification];
}


- (IBAction) declineTapped:(id)sender {
    [self.delegate declineTappedForNotification:(CHFriendInviteNotification*)self.currentNotification];
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
    [self photoImageView].layer.cornerRadius = 22.0f;
    [self photoImageView].layer.masksToBounds = YES;
    [self messageTextView].font = [UIFont fontWithName:@"DroidSans" size:12.0f];
}

@end
