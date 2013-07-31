//
//  CHBuyAdFreeVC.m
//  CashHoppers
//
//  Created by Eugene on 30.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBuyAdFreeVC.h"
#import "CHAppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "CHCheckMark.h"

@interface CHBuyAdFreeVC ()

@end

@implementation CHBuyAdFreeVC

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
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"nav_bar_background"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuPressed:(id)sender {
    [DELEGATE.menuContainerVC toggleLeftSideMenuCompletion:nil];
}

- (IBAction)buyPressed:(id)sender {
    
}

- (void)viewDidUnload {
    [self setPriceLabel:nil];
    [self setBuyNowButton:nil];
    [self setCheckMark:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end
