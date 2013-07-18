//
//  CHOtherHopsListCell.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/27/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHOtherHopsListCell.h"
#import "CHHopsManager.h"

@implementation CHOtherHopsListCell

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

- (IBAction)previewButtonTapped:(id)sender {
}

- (IBAction)joinButtonTapped:(id)sender {
}

- (NSString*) dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd"];
    NSString* startDate = [df stringFromDate:self.currentHop.time_start];
    NSString* endDate = [df stringFromDate:self.currentHop.time_end];
    return [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
}


- (void) configureCompletedHop {
    [[self nameHopLabel] setText:self.currentHop.name];
    [[self dateHopLabel] setText:[self dateString]];
    [[self namePrizeLabel] setText:@"Grand Prize:"];
    [[self countPrizeLabel] setText:[NSString stringWithFormat:@"$%i", [self.currentHop.jackpot integerValue]]];
    [[self verticalIndicatorImageView] setImage:[UIImage imageNamed:@"vertical_indicator_green"]];
    [[self horizontalIndicatorImageView] setImage:[UIImage imageNamed:@"horizontal_indicator_green"]];
}


- (void) configureHopWithFee {
    [[self prewNameHopLabel] setText:self.currentHop.name];
    [[self prewDateHopLabel] setText:[self dateString]];
    [[self prewPrizeHopLabel] setText:@"Grand Prize:"];
    [[self prewCountHopLabel] setText:[NSString stringWithFormat:@"$%i", [self.currentHop.jackpot integerValue]]];
    [[self prewFeeLabel] setText:@"Entry Fee:"];
    [[self prewCountFeeLabel] setText:[NSString stringWithFormat:@"$%@", self.currentHop.price]];
    [[self prewVerticalIndicator] setImage:[UIImage imageNamed:@"av_indicator_cell"]];
}


- (void) configureHopWithCode {
    [[self joinNameHopLabel] setText:self.currentHop.name];
    [[self joinDateHopLabel] setText:[self dateString]];
    [[self joinPrizeHopLabel] setText:@"Grand Prize:"];
    [[self joinCountHopLabel] setText:[NSString stringWithFormat:@"$%i", [self.currentHop.jackpot integerValue]]];
    [[self joinVerticalIndicatorImageView] setImage:[UIImage imageNamed:@"av_indicator_cell"]];
}


- (void) configureFreeHop {
    [[self nameHopLabel] setText:self.currentHop.name];
    [[self dateHopLabel] setText:[self dateString]];
    [[self namePrizeLabel] setText:@"Grand Prize:"];
    [[self countPrizeLabel] setText:[NSString stringWithFormat:@"$%i", [self.currentHop.jackpot integerValue]]];
    [[self verticalIndicatorImageView] setImage:nil];
    [[self horizontalIndicatorImageView] setImage:nil];
}





@end
