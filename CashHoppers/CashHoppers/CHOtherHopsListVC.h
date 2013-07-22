//
//  CHOtherHopsListVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/27/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHOtherHopsListVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *otherHopsTable;
@property (strong, nonatomic) IBOutlet UILabel* hopsGroupTitleLabel;
@property (nonatomic, assign) BOOL isDailyHops;

@end
