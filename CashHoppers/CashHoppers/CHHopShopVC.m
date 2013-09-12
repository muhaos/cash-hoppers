//
//  CHHopShopVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/30/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHopShopVC.h"
#import "CHPaymentsManager.h"
#import "MKStoreManager.h"
#import "CHLoadingVC.h"
#import "CHAppDelegate.h"



@interface CHHopShopVC ()
@property (nonatomic, assign) int yourRibbits;
@end

@implementation CHHopShopVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    self.activityIndicator.hidden = YES;
    self.yourRibbits = 0;
    [self refreshBalance];
}


- (void) backButtonTapped {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) refreshBalance {
    self.yourBalanceLabel.hidden = YES;
    self.activityIndicator.hidden = NO;
    
    [[CHPaymentsManager instance] getBalanceWithCompletionHandler:^(NSNumber* balance){
        if (balance != nil && ![balance isKindOfClass:[NSNull class]]) {
            self.yourRibbits = [balance intValue];
            self.yourBalanceLabel.text = [NSString stringWithFormat:@"%i", [balance intValue]];
        } else {
            self.yourBalanceLabel.text = @"Error get balance...";
        }
        self.yourBalanceLabel.hidden = NO;
        self.activityIndicator.hidden = YES;
    }];
}


- (void) buyRibbits:(NSNumber*) count sender:(UIButton*) button {
    
    if ([DELEGATE.serverReachability currentReachabilityStatus] == NotReachable) {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Seems like our server is offline. Try later."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        return;
    }
    
    
    [[CHLoadingVC sharedLoadingVC] showInController:self withText:@"Please wait..."];
    
    button.enabled = NO;
    
    NSString* productID = nil;
    switch ([count intValue]) {
        case 10:
            productID = kProductRibbitsTier1;
            break;
        case 50:
            productID = kProductRibbitsTier2;
            break;
        case 100:
            productID = kProductRibbitsTier3;
            break;
    }
    
    [[MKStoreManager sharedManager] buyFeature:productID
                                    onComplete:^(NSString* purchasedFeature,
                                                 NSData* purchasedReceipt,
                                                 NSArray* availableDownloads)
     {
         
         [[CHPaymentsManager instance] refillBalanceFor:count withCompletionHandler:^(NSError* error){
             if (error == nil) {
                 [self refreshBalance];
             } else {
                 UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"CANT BUY RIBBITS: %@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [av show];
             }
             button.enabled = YES;
             
             [[CHLoadingVC sharedLoadingVC] hide];
             
         }];
         
     }
                                   onCancelled:^
     {
         button.enabled = YES;
         [[CHLoadingVC sharedLoadingVC] hide];
     }];
}


- (IBAction)buy10RibbitsButtonTapped:(id)sender
{
    [self buyRibbits:@10 sender:sender];   
}


- (IBAction)buy50RibbitsButtonTapped:(id)sender
{
    [self buyRibbits:@50 sender:sender];   
}


- (IBAction)buy100RibbitsButtonTapped:(id)sender
{
    [self buyRibbits:@100 sender:sender];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setYourBalanceLabel:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

@end
