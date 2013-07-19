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

@interface CHHomeScreenViewController ()

@property (nonatomic, retain) id hopsUpdatedNotification;

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
    
//    if (![self.slidingViewController.underLeftViewController isKindOfClass:[CHMenuSlidingVC class]]) {
//        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
//    }
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [menuButton addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView setContentSize:CGSizeMake(340,470)];
    
    self.hopsUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_HOPS_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        [self updateOtherHopsSection];
    }];
    
    [[CHHopsManager instance] refreshHops];
    [self updateOtherHopsSection];
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
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
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
//    [self.slidingViewController anchorTopViewTo:ECRight];
    [DELEGATE.menuContainerVC toggleLeftSideMenuCompletion:nil];      
    
}


@end
