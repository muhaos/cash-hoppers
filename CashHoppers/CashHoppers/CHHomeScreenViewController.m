//
//  CHHomeScreenViewController.m
//  CashHoppers
//
//  Created by Eugene on 21.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHomeScreenViewController.h"
#import "CHAppDelegate.h"
#import "MHCustomTabBarController.h"
#import "ECSlidingViewController.h"
#import "CHMenuSlidingVC.h"
#import "CHHopsManager.h"
#import "MFSideMenuContainerViewController.h"
#import "CHOtherHopsListVC.h"
#import "CHFriendsFeedManager.h"
#import "CHUser.h"
#import "UIImageView+AFNetworking.h"
#import "CHUserManager.h"

@interface CHHomeScreenViewController ()


@property (nonatomic, retain) id hopsUpdatedNotification;
@property (nonatomic, retain) id friendsFeedUpdatedNotification;
@property (nonatomic, retain) id globalFeedUpdatedNotification;
@property (nonatomic, retain) id feedItemUpdatedNotification;
@property (nonatomic, retain) id hopTaskUpdatedNotification;
@property (nonatomic, retain) id currentUserUpdatedNotification;
@property (nonatomic, retain) CHFriendsFeedItem* currentFeedItem;

@property (nonatomic, retain) NSURL* adsImageURL;
@property (nonatomic, retain) NSURL* adsLinkURL;


@end

@implementation CHHomeScreenViewController
@synthesize menuButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [menuButton addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView setContentSize:CGSizeMake(340,470)];
    
    self.hopTaskUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_HOPS_TASKS_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self updateDailyHopSection];
    }];
    
    self.hopsUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_HOPS_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self updateOtherHopsSection];
        [self updateDailyHopSection];
    }];
    
    self.friendsFeedUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_FRIEND_FEED_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self updateFriendsFeedSection];
    }];
    
    self.globalFeedUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_GLOBAL_FEED_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self updateFriendsFeedSection];
    }];
    
    self.feedItemUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_FEED_ITEM_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        
        CHFriendsFeedItem* updatedItem = note.object;
        if (updatedItem == self.currentFeedItem) {
            [self updateFriendsFeedSection];
        }
    }];

    self.currentUserUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_CURRENT_USER_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        if (self.bannerImView.image == nil) {
            [self loadTopADS];
        }
    }];    
    
    [[CHHopsManager instance] refreshHops];
    [[CHFriendsFeedManager instance] refreshFeeds];

    [self updateDailyHopSection];
    [self updateOtherHopsSection];
    [self updateFriendsFeedSection];
    
    if ([CHUserManager instance].currentUser != nil && [[CHUserManager instance].currentUser.adEnabled boolValue] == NO) {
        CGRect newFrame = self.scrollView.frame;
        newFrame.origin.y -= 40;
        newFrame.size.height += 40;
        self.scrollView.frame = newFrame;
    }

}


- (void) loadTopADS {
    if ([[CHUserManager instance].currentUser.adEnabled intValue] == YES) {
        NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
        NSString *path = [NSString stringWithFormat:@"/api/ads/get_ads.json?api_key=%@&authentication_token=%@&ad_type=%@", CH_API_KEY, aToken, @"RCH"];
        
        NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSDictionary* ads_json = [JSON objectForKey:@"ad"];
            if (ads_json) {
                self.adsImageURL = [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:[ads_json objectForKey:@"picture"]]];
                [self.bannerImView setImageWithURL:self.adsImageURL];
                self.adsLinkURL = [NSURL URLWithString:[ads_json objectForKey:@"link"]];
            }
        
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Can't load url: %@ \n %@", request.URL, [error localizedDescription]);
        }];
        [operation start];
    }    
}


- (IBAction) topBannerTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:self.adsLinkURL];
}


- (void) setDailyHopTaskName:(NSString*) wholeStr withBoldString:(NSString*) boldPartStr {
    
    NSDictionary *boldAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans-Bold" size:10.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]};
    NSDictionary *normAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans" size:10.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]};
    
    NSMutableAttributedString* mStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
    
    NSInteger str_length = [wholeStr length];
    
    [mStr setAttributes:normAttribs range:NSMakeRange(0, str_length)];
    if (boldPartStr != nil) {
        [mStr setAttributes:boldAttribs range:[wholeStr rangeOfString:boldPartStr]];
    }
    
    self.dailyHopNameLabel.attributedText = mStr;
}


- (void) updateDailyHopSection {
    int dailyHopsCount = [[CHHopsManager instance].dailyHops count];
    
    self.dailyHopIndicator.hidden = (dailyHopsCount > 0);
    self.dailyHopNameLabel.hidden = (dailyHopsCount <= 0);
    self.dailyHopImageView.hidden = (dailyHopsCount <= 0);
    self.dailyHopButton.hidden = (dailyHopsCount <= 0);
    self.dailyHopIndicator.hidden = (dailyHopsCount <= 0);
    
    if (dailyHopsCount > 0) {
        self.dailyHopIndicator.hidden = YES;
        CHHop* dailyHop = [CHHopsManager instance].dailyHops[0];
        NSString* hopName = dailyHop.name;
        NSString* hopTaskName = [dailyHop.tasks[0] text];
        [self setDailyHopTaskName:[NSString stringWithFormat:@"%@: %@", hopName, hopTaskName] withBoldString:hopName];
        [self.dailyHopImageView setImageWithURL:[dailyHop logoURL] placeholderImage:[UIImage imageNamed: @"spinner.png"]];
        self.dailyHopExists.hidden = (dailyHopsCount > 0);
    }
}


- (void) updateFriendsFeedSection {
    self.currentFeedItem = nil;
    if ([CHFriendsFeedManager instance].friendsFeedItems.count > 0) {
        self.currentFeedItem = [CHFriendsFeedManager instance].friendsFeedItems[0];
    } else if ([CHFriendsFeedManager instance].globalFeedItems.count > 0) {
        self.currentFeedItem = [CHFriendsFeedManager instance].globalFeedItems[0];
    }
    if (self.currentFeedItem != nil) {
        self.feedIndicator.hidden = YES;
        self.feedContainer.hidden = NO;
        
        self.feedFriendNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.currentFeedItem.user.first_name, self.currentFeedItem.user.last_name];
        self.feedHopNameLabel.text = self.currentFeedItem.hop.name;
        self.feedHopTaskNameLabel.text = [self.currentFeedItem completedTaskName];
        self.feedTimeLabel.text = @"some time ago";
        [self.feedHopImageView setImageWithURL:[self.currentFeedItem smallHopImageURL] placeholderImage:[UIImage imageNamed: @"spinner.png"]];
        [self.feedAvatarImageView setImageWithURL:[self.currentFeedItem.user avatarURL] placeholderImage:[UIImage imageNamed: @"spinner.png"]];
    } else {
        self.feedIndicator.hidden = NO;
        self.feedContainer.hidden = YES;
    }
}


- (void) updateOtherHopsSection {
    int otherHopsCount = [[CHHopsManager instance].otherHops count];
    if (otherHopsCount > 0) {
        self.otherHopsIndicator.hidden = YES;
        
        self.firstHopContainer.hidden = NO;
        self.firstHopNameLabel.text = [[CHHopsManager instance].otherHops[0] name];
        self.firstHopPrizeLabel.text = [NSString stringWithFormat:@"%@", [[CHHopsManager instance].otherHops[0] jackpot]];

        if (otherHopsCount > 1) {
            self.secondHopContainer.hidden = NO;
            self.secondHopNameLabel.text = [[CHHopsManager instance].otherHops[1] name];
            self.secondHopPrizeLabel.text = [NSString stringWithFormat:@"%@", [[CHHopsManager instance].otherHops[1] jackpot]];
        } else {
            self.secondHopContainer.hidden = YES;
        }
        
        if (otherHopsCount > 2) {
            self.otherHopsCountLabel.hidden = NO;
            self.otherHopsCountLabel.text = [NSString stringWithFormat:@"%i more...", otherHopsCount - 2];
        } else {
            self.otherHopsCountLabel.hidden = YES;
        }
        
    } else {
        self.firstHopContainer.hidden = YES;
        self.secondHopContainer.hidden = YES;
        self.otherHopsCountLabel.hidden = YES;
        self.otherHopsIndicator.hidden = NO;
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"daily_hops_segue"]) {
        ((CHOtherHopsListVC*)vc).isDailyHops = YES;
    } else if ([segue.identifier isEqualToString:@"other_hops_segue"]) {
        ((CHOtherHopsListVC*)vc).isDailyHops = NO;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (DELEGATE.needOpenDailyHops) {
        [self performSegueWithIdentifier:@"daily_hops_segue" sender:self];
        DELEGATE.needOpenDailyHops = NO;
    }
    if (DELEGATE.needOpenOtherHops) {
        [self performSegueWithIdentifier:@"other_hops_segue" sender:self];
        DELEGATE.needOpenOtherHops = NO;
    }
    if (DELEGATE.needOpenFriendsFeed) {
        [self performSegueWithIdentifier:@"friends_feed_segue" sender:self];
        DELEGATE.needOpenFriendsFeed = NO;
    }
    [self loadTopADS];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isViewLoaded && self.view.window) {
        [self showAdsWithType:@"FULL" andHopID:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dailyHopPressed:(id)sender {
}

- (IBAction)playNowPressed:(id)sender {
}


- (void)viewDidUnload {
    [self setBackButton:nil];
    [self setBannerImView:nil];
    [self setScrollView:nil];
    [self setMenuButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.hopsUpdatedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.hopTaskUpdatedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.friendsFeedUpdatedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.globalFeedUpdatedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.feedItemUpdatedNotification];
    [self setDailyHopButton:nil];
    [self setDailyHopExists:nil];
    [super viewDidUnload];
}


- (IBAction)menuTapped:(id)sender {

    [DELEGATE.menuContainerVC toggleLeftSideMenuCompletion:nil];
    
}


@end
