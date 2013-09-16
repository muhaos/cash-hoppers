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
#import "CHCheckMarkView.h"
#import "CHPaymentsManager.h"
#import "CHUserManager.h"
#import "CHLoadingVC.h"


@interface CHBuyAdFreeVC ()

@end

@implementation CHBuyAdFreeVC

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"nav_bar_background"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    [self setupTriangleBackButton];
	// Do any additional setup after loading the view.
    
    [self refreshBalance];
}



- (void) refreshBalance {
    if ([[CHUserManager instance].currentUser.adEnabled intValue] == NO) {
        self.balanceLabel.text = @"Already buyed!";
        self.buyNowButton.hidden = YES;
        self.balanceActivityView.hidden = YES;
        self.topDescription.hidden = YES;
    } else {
        self.balanceLabel.hidden = YES;
        self.balanceActivityView.hidden = NO;
        self.buyNowButton.enabled = NO; 
        self.buyNowButton.alpha = 0.5f;
        
        [[CHPaymentsManager instance] getBalanceWithCompletionHandler:^(NSNumber* balance){
            if (balance != nil && ![balance isKindOfClass:[NSNull class]]) {
                self.balanceLabel.text = [NSString stringWithFormat:@"YOUR BALANCE:\n%i", [balance intValue]];
                if ([balance intValue] < 20) {
                    self.buyNowButton.enabled = NO;
                    self.buyNowButton.alpha = 0.5f;
                } else {
                    self.buyNowButton.enabled = YES;
                    self.buyNowButton.alpha = 1.0f;
                }
            } else {
                self.balanceLabel.text = @"Error get balance...";
                self.buyNowButton.enabled = NO;
                self.buyNowButton.alpha = 0.5f;
            }
            self.balanceLabel.hidden = NO;
            self.balanceActivityView.hidden = YES;
        }];
    }
}


- (IBAction)buyPressed:(id)sender {
    [[CHLoadingVC sharedLoadingVC] showInController:self withText:@"Please wait..."];

    [[CHPaymentsManager instance] removeAdsWithCompletionHandler:^(NSError* error){
        if (error != nil) {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Can't buy ad free version: %@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
        } else {
            [CHUserManager instance].currentUser.adEnabled = [NSNumber numberWithInt:0];
            [[CHUserManager instance] updateCurrentUser];
        }
        [self refreshBalance];
        [[CHLoadingVC sharedLoadingVC] hide];
    }];
}


- (void) backButtonTapped {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setPriceLabel:nil];
    [self setBuyNowButton:nil];
    [self setCheckMark:nil];
    [self setToolbar:nil];
    [self setTopDescription:nil];
    [super viewDidUnload];
}
@end
