//
//  CHHopsListCell.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/21/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHopsListCell.h"

@implementation CHHopsListCell

@synthesize yourDailyHopLable;
@synthesize yourImageView;
@synthesize yourJackpotLabel;
@synthesize availableImageView;
@synthesize avDailyHopLabel;
@synthesize avJackpotLabel;
@synthesize av_delta;
@synthesize your_delta;

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

@end
