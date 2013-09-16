//
//  CHBuyAdFreeVC.h
//  CashHoppers
//
//  Created by Eugene on 30.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHCheckMarkView;

@interface CHBuyAdFreeVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *buyNowButton;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet CHCheckMarkView *checkMark;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *balanceActivityView;
@property (strong, nonatomic) IBOutlet UILabel *topDescription;


- (IBAction)buyPressed:(id)sender;

@end
