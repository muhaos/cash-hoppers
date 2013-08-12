//
//  CHTradeShowItemHopVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHHop;

@interface CHTradeShowMultiHopVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *multiHopTable;
@property (strong, nonatomic) IBOutlet UILabel *hopTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *hopImageView;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *grandPrizeLabel;

@property (strong, nonatomic) CHHop* currentHop;

@end
