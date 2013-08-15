//
//  CHBuyHopVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/15/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBuyHopVC.h"
#import <QuartzCore/QuartzCore.h>

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
    [self updateView];
}


-(void)updateView
{
     NSString *ribbitsString = [NSString stringWithFormat: @"%i", yourRibbits];
    [yourBalanceLabel setText:ribbitsString];
    
    if ([yourBalanceLabel.text intValue] >= [costHopLabel.text intValue] ) {
        buyNowButton.enabled = YES;
    } else {
        buyNowButton.enabled = NO;
        buyNowButton.backgroundColor = [UIColor colorWithRed:1 green:204/255.0f blue:0/255.0f alpha:0.3f];
    }
}


- (IBAction)buyNowButtonTapped:(id)sender
{
    [self.view removeFromSuperview];
}


- (IBAction)buy10RibbitsButtonTapped:(id)sender
{
    yourRibbits = yourRibbits+10;
    [self updateView];
}


- (IBAction)buy50RibbitsButtonTapped:(id)sender
{
      yourRibbits = yourRibbits+50;
    [self updateView];
}


- (IBAction)buy100RibbitsButtonTapped:(id)sender
{
    yourRibbits = yourRibbits+100;;
    [self updateView];
}


- (IBAction)cancelButtonTapped:(id)sender
{
    [self.view removeFromSuperview];
}


+ (CHBuyHopVC*) sharedBuyHopVC {
    static CHBuyHopVC* instance = nil;
    if (instance == nil) {
        instance = [[CHBuyHopVC alloc] initWithNibName:@"CHBuyHopVC" bundle:nil];
    }
    return instance;
}


- (void) showInController:(UIViewController*) c
              withNameHop:(NSString*)nameHop
              withCostHop:(NSString*)costHop
{
     if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"CHBuyHopVC" reason:@"CHBuyHop controller already showed!" userInfo:nil];
    }
    [c.view addSubview:self.view];
    nameHopLabel.text = nameHop;
    costHopLabel.text = costHop;
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
