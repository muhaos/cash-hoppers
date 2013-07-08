//
//  CHTradeShowEntryVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHTradeShowEntryVC.h"

@interface CHTradeShowEntryVC ()

@end

@implementation CHTradeShowEntryVC

@synthesize tradeShowImageView,tradeShowLabel, passcodeTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (CHTradeShowEntryVC*) sharedTradeShowEntryVC
{
    static CHTradeShowEntryVC* instance = nil;
    if (instance == nil) {
        instance = [[CHTradeShowEntryVC alloc] initWithNibName:@"CHTradeShowEntryVC" bundle:nil];
    }
    return instance;
}


- (void) showInController:(UIViewController*) c
                 withText:(NSString*) text
                withImage:(UIImageView*) image;
{
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"CHTradeShowEntryVC" reason:@"TradeShowEntry controller already showed!" userInfo:nil];
    }
    [c.view addSubview:self.view];
    tradeShowLabel.text = text;
    tradeShowImageView = image;
}


- (void)viewDidUnload {
    [self setTradeShowImageView:nil];
    [self setTradeShowLabel:nil];
    [self setPasscodeTextField:nil];
    [super viewDidUnload];
}


- (IBAction)startPlayingTapped:(id)sender {
//    passcodeTextField.text;
}


- (IBAction)cancelTapped:(id)sender {
    [self.view removeFromSuperview];
}


- (IBAction)helpTapped:(id)sender {
}


@end
