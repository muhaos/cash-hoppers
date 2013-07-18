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

@interface CHHomeScreenViewController ()

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
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[CHMenuSlidingVC class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [menuButton addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView setContentSize:CGSizeMake(340,470)];
    
    [[CHHopsManager instance] refreshHops];
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
    [DELEGATE switchViewTo:CHFeed];
    
}

- (IBAction)playNowPressed:(id)sender {
 //   [DELEGATE switchViewTo:CHNewHop];
    [DELEGATE.tabBarController performSegueWithIdentifier:@"otherHops" sender:[[UIButton alloc] init]];
}


- (void)viewDidUnload {
    [self setBackButton:nil];
    [self setBannerImView:nil];
    [self setScrollView:nil];
    [self setMenuButton:nil];
    [super viewDidUnload];
}


- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}


@end
