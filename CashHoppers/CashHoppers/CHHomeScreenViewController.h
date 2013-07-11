//
//  CHHomeScreenViewController.h
//  CashHoppers
//
//  Created by Eugene on 21.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHHomeScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIImageView *bannerImView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)dailyHopPressed:(id)sender;
- (IBAction)playNowPressed:(id)sender;
- (IBAction)menuTapped:(id)sender;

@end
