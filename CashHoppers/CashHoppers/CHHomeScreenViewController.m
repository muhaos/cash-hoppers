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

@interface CHHomeScreenViewController ()

@property (nonatomic, retain) id hopsUpdatedNotification;
@property (nonatomic, retain) id friendsFeedUpdatedNotification;
@property (nonatomic, retain) id globalFeedUpdatedNotification;
@property (nonatomic, retain) id feedItemUpdatedNotification;
@property (nonatomic, retain) CHFriendsFeedItem* currentFeedItem;

@property (nonatomic, retain) NSURL* adsImageURL;
@property (nonatomic, retain) NSURL* adsLinkURL;

@end

@implementation CHHomeScreenViewController
@synthesize menuButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [menuButton addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView setContentSize:CGSizeMake(340,470)];
    
    self.hopsUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_HOPS_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self updateOtherHopsSection];
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

    
    
    
    [[CHHopsManager instance] refreshHops];
    [[CHFriendsFeedManager instance] refreshFeeds];

    [self updateOtherHopsSection];
    [self updateFriendsFeedSection];
    
    [self loadTopADS];
}


- (void) loadTopADS {
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
        
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Can't load url: %@ \n %@", request.URL, [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        
    }];
    
    [operation start];
}


- (IBAction) topBannerTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:self.adsLinkURL];
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
        [self.feedHopImageView setImageWithURL:[self.currentFeedItem hopImageURL]];
        [self.feedAvatarImageView setImageWithURL:[self.currentFeedItem.user avatarURL]];
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
        self.firstHopPrizeLabel.text = [NSString stringWithFormat:@"$%i", [[[CHHopsManager instance].otherHops[0] jackpot] intValue]];

        if (otherHopsCount > 1) {
            self.secondHopContainer.hidden = NO;
            self.secondHopNameLabel.text = [[CHHopsManager instance].otherHops[1] name];
            self.secondHopPrizeLabel.text = [NSString stringWithFormat:@"$%i", [[[CHHopsManager instance].otherHops[1] jackpot] intValue]];
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
    [super viewDidUnload];
}


- (IBAction)menuTapped:(id)sender {

    [DELEGATE.menuContainerVC toggleLeftSideMenuCompletion:nil];
    
}


@end
