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

// other hops list
@property (strong, nonatomic) IBOutlet UIView* firstHopContainer;
@property (strong, nonatomic) IBOutlet UIView* secondHopContainer;
@property (strong, nonatomic) IBOutlet UILabel* firstHopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* firstHopPrizeLabel;
@property (strong, nonatomic) IBOutlet UILabel* secondHopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* secondHopPrizeLabel;
@property (strong, nonatomic) IBOutlet UILabel* otherHopsCountLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* otherHopsIndicator;

// Friends feed
@property (strong, nonatomic) IBOutlet UIView* feedContainer;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* feedIndicator;
@property (strong, nonatomic) IBOutlet UIImageView* feedHopImageView;
@property (strong, nonatomic) IBOutlet UIImageView* feedAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel* feedHopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* feedHopTaskNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* feedFriendNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* feedTimeLabel;


- (IBAction) backButtonPressed:(id)sender;
- (IBAction) dailyHopPressed:(id)sender;
- (IBAction) playNowPressed:(id)sender;
- (IBAction) menuTapped:(id)sender;
- (IBAction) topBannerTapped:(id)sender;


@end
