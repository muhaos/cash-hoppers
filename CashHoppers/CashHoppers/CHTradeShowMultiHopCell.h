//
//  CHTradeShowMultiHopCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTradeShowMultiHopCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *completeIndicatorImageView;
@property (strong, nonatomic) IBOutlet UIImageView *compVerticalIndicatorImageView;
@property (strong, nonatomic) IBOutlet UILabel *compTextLabel;

@property (strong, nonatomic) IBOutlet UILabel *notCompTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *notCompVerticalIndicatorImageView;

@end
