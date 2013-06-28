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

@interface CHHomeScreenViewController ()

@end

@implementation CHHomeScreenViewController

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
	// Do any additional setup after loading the view.
    [_scrollView setContentSize:CGSizeMake(340,470)];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    [super viewDidUnload];
}
@end
