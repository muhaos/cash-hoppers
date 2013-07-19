//
//  CHOtherHopsListCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/27/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHHop;

@interface CHOtherHopsListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *verticalIndicatorImageView;
@property (strong, nonatomic) IBOutlet UIImageView *horizontalIndicatorImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *namePrizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countPrizeLabel;

@property (strong, nonatomic) IBOutlet UILabel *prewNameHopLabel;
@property (strong, nonatomic) IBOutlet UIImageView *prewVerticalIndicator;
@property (strong, nonatomic) IBOutlet UILabel *prewDateHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *prewPrizeHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *prewCountHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *prewFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *prewCountFeeLabel;

@property (strong, nonatomic) IBOutlet UILabel *joinNameHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *joinDateHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *joinPrizeHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *joinCountHopLabel;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;
@property (strong, nonatomic) IBOutlet UIImageView *lockImageView;
@property (strong, nonatomic) IBOutlet UIImageView *joinVerticalIndicatorImageView;

@property (strong, nonatomic) CHHop* currentHop;

- (void) configureCompletedHop;
- (void) configureHopWithFee;
- (void) configureHopWithCode;
- (void) configureFreeHop;



- (IBAction)previewButtonTapped:(id)sender;
- (IBAction)joinButtonTapped:(id)sender;

@end
