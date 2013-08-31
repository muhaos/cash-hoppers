//
//  CHHopShopVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/30/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHHopShopVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *yourBalanceLabel;
- (IBAction)buy10RibbitsButtonTapped:(id)sender;
- (IBAction)buy50RibbitsButtonTapped:(id)sender;
- (IBAction)buy100RibbitsButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
