//
//  CHHopsListCell.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/21/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHHopsListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *yourDailyHopLable;
@property (strong, nonatomic) IBOutlet UILabel *yourJackpotLabel;
@property (strong, nonatomic) IBOutlet UILabel *avDailyHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *avJackpotLabel;
@property (strong, nonatomic) IBOutlet UIImageView *yourImageView;
@property (strong, nonatomic) IBOutlet UIImageView *availableImageView;
@property (strong, nonatomic) IBOutlet UIImageView *your_delta;
@property (strong, nonatomic) IBOutlet UIImageView *av_delta;

@end
