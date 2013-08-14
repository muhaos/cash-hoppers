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
@synthesize prizesTextView, finalyStr;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray* prizes = @[
                        @{@"prize_position": @"1st Prize", @"prize_value": @"$500" },
                        @{@"prize_position": @"2st Prize", @"prize_value": @"$400" },
                        @{@"prize_position": @"Most Creative Pic", @"prize_value": @"40 TV" },
                        @{@"prize_position": @"Raffle Prize", @"prize_value": @"Apple iPod Touch" }
  ];
    
    NSDictionary *whiteAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-CondensedBold" size:21.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]};
    NSDictionary *yellowAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-CondensedBold" size:21.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:204/255.0f blue:0.0f alpha:1.0f]};
    
    NSString* finalStr = @"";
    
    NSRange boldParts[100];
    for (int i = 0; i < [prizes count]; i++) {
        boldParts[i].location = [finalStr length];
        boldParts[i].length = [[prizes[i] objectForKey:@"prize_position"] length];
        finalStr = [finalStr stringByAppendingFormat:@"%@ - %@\n", [prizes[i] objectForKey:@"prize_position"], [prizes[i] objectForKey:@"prize_value"]];
    }

    NSMutableAttributedString* aString = [[NSMutableAttributedString alloc] initWithString:finalStr];
    NSInteger str_length = [finalStr length];
    [aString setAttributes:whiteAttribs range:NSMakeRange(0, str_length)];

    for (int i = 0; i < [prizes count]; i++) {
        [aString setAttributes:yellowAttribs range:boldParts[i]];
    }

    prizesTextView.attributedText = aString;
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
