//
//  CHPrizeListVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/12/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHPrizeListVC.h"

@interface CHPrizeListVC ()

@end

@implementation CHPrizeListVC
@synthesize prizesTextView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dic1 = [NSDictionary new];
    [dic1 setValue:@"$500" forKey:@"1st Prize"];
    NSDictionary *dic2 = [[NSDictionary alloc] init];
    [dic2 setValue:@"$400" forKey:@"2st Prize"];
    NSDictionary *dic3 = [NSDictionary new];
    [dic3 setValue:@"40 TV" forKey:@"Most Creative Pic"];
    NSDictionary *dic4 = [NSDictionary new];
    [dic4 setValue:@"Apple iPod Touch" forKey:@"Raffle Prize"];
    
    NSArray *strArray = [[NSArray alloc] initWithObjects:dic1, dic2, dic3, dic4, nil];
}


+ (CHPrizeListVC*) sharedPrizeListVC {
    static CHPrizeListVC* instance = nil;
    if (instance == nil) {
        instance = [[CHPrizeListVC alloc] initWithNibName:@"CHPrizeListVC" bundle:nil];
    }
    return instance;
}


- (void) showInController:(UIViewController*) c {
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"CHPrizeListVC" reason:@"Loading controller already showed!" userInfo:nil];
    }
    [c.view addSubview:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setPrizesTextView:nil];
    [super viewDidUnload];
}


- (IBAction)cancelButtonTapped:(id)sender
{
    [self.view removeFromSuperview];
}


@end
