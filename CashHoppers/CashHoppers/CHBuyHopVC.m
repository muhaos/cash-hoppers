//
//  CHBuyHopVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/15/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBuyHopVC.h"
#import <QuartzCore/QuartzCore.h>
#import "CHHop.h"
#import "CHPaymentsManager.h"
#import "MKStoreManager.h"
#import "CHLoadingVC.h"


@interface CHBuyHopVC ()
@property (nonatomic, assign) int yourRibbits;
@end

@implementation CHBuyHopVC
@synthesize nameHopLabel, costHopLabel, yourBalanceLabel, buyNowButton, buy100RibbitsButton, buy10RibbitsButton, buy50RibbitsButton, yourRibbits;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customButtons];
    
    yourRibbits = 0;
    nameHopLabel.text = self.currentHop.name;
    costHopLabel.text = [NSString stringWithFormat:@"%@", self.currentHop.price];
    
    [self refreshBalance];
}


- (void) refreshBalance {
    self.yourBalanceLabel.hidden = YES;
    self.yourBalanceRibbitsLabel.hidden = YES;
    self.yourBalanceActivityView.hidden = NO;
    
    [[CHPaymentsManager instance] getBalanceWithCompletionHandler:^(NSNumber* balance){
        if (balance != nil && ![balance isKindOfClass:[NSNull class]]) {
            yourRibbits = [balance intValue];
            self.yourBalanceLabel.text = [NSString stringWithFormat:@"%i", [balance intValue]];
            if (yourRibbits < [self.currentHop.price intValue]) {
                buyNowButton.enabled = NO;
                buyNowButton.alpha = 0.5f;
            } else {
                buyNowButton.enabled = YES;
                buyNowButton.alpha = 1.0f;
            }
        } else {
            self.yourBalanceLabel.text = @"Error get balance...";
            buyNowButton.enabled = NO;
            buyNowButton.alpha = 0.5f;
        }
        self.yourBalanceLabel.hidden = NO;
        self.yourBalanceRibbitsLabel.hidden = NO;
        self.yourBalanceActivityView.hidden = YES;
        
    }];
}


- (IBAction)buyNowButtonTapped:(id)sender
{
    [self.view removeFromSuperview];
}


- (void) buyRibbits:(NSNumber*) count sender:(UIButton*) button {
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


- (IBAction)cancelButtonTapped:(id)sender
{
    [self.view removeFromSuperview];
}


+ (CHBuyHopVC*) sharedBuyHopVC {
    static CHBuyHopVC* instance = nil;
    instance = [[CHBuyHopVC alloc] initWithNibName:@"CHBuyHopVC" bundle:nil];
    return instance;
}


- (void) showInController:(UIViewController*) c withHop:(CHHop*)hop {
    self.currentHop = hop;
    [c.view addSubview:self.view];
}


-(void)customButtons
{
    buyNowButton.layer.cornerRadius = 5.0f;
    buy10RibbitsButton.layer.cornerRadius = 5.0f;
    buy50RibbitsButton.layer.cornerRadius = 5.0f;
    buy100RibbitsButton.layer.cornerRadius = 5.0f;
    
    buyNowButton.layer.masksToBounds = YES;
    buy10RibbitsButton.layer.masksToBounds = YES;
    buy50RibbitsButton.layer.masksToBounds = YES;
    buy100RibbitsButton.layer.masksToBounds = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setNameHopLabel:nil];
    [self setYourBalanceLabel:nil];
    [self setCostHopLabel:nil];
    [self setYourBalanceLabel:nil];
    [self setBuyNowButton:nil];
    [self setBuy10RibbitsButton:nil];
    [self setBuy50RibbitsButton:nil];
    [self setBuy100RibbitsButton:nil];
    [super viewDidUnload];
}


@end
