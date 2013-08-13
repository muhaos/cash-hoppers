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
    
    NSDictionary *dic1 = [NSDictionary new];
    [dic1 setValue:@"$500" forKey:@"1st Prize"];
    NSDictionary *dic2 = [[NSDictionary alloc] init];
    [dic2 setValue:@"$400" forKey:@"2st Prize"];
    NSDictionary *dic3 = [NSDictionary new];
    [dic3 setValue:@"40 TV" forKey:@"Most Creative Pic"];
    NSDictionary *dic4 = [NSDictionary new];
    [dic4 setValue:@"Apple iPod Touch" forKey:@"Raffle Prize"];
    
    NSArray *strArray = [[NSArray alloc] initWithObjects:[dic1 allKeys], [dic2 allKeys], [dic3 allKeys], [dic4 allKeys], nil];
    
    
    NSDictionary *whiteAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans-CondensedBold" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:256/256.0f green:256/256.0f blue:256/256.0f alpha:1.0f]};
    NSDictionary *yellowAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"DroidSans-Bold" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:255/256.0f green:204/256.0f blue:0.0f alpha:1.0f]};
    
        
    for (int i = 0; i <= [strArray count]; i++) {

        NSString *keysStr = [[[strArray objectAtIndex:i] allKeys] componentsJoinedByString:@""];
        NSString *valueStr = [[[strArray objectAtIndex:i] allValues] componentsJoinedByString:@""];
        
        NSMutableAttributedString* whiteStr = [[NSMutableAttributedString alloc] initWithString:keysStr];
        NSMutableAttributedString* yellowStr = [[NSMutableAttributedString alloc] initWithString:valueStr];

        NSInteger white_str_length = [keysStr length];
        NSInteger yellow_str_length = [valueStr length];

        [whiteStr setAttributes:whiteAttribs range:NSMakeRange(finalyStr.length, white_str_length)];
        [yellowStr setAttributes:yellowAttribs range:NSMakeRange(white_str_length+1, yellow_str_length)];

        finalyStr = [NSString stringWithFormat:@"%@ - %@", whiteStr, yellowStr];
    }
    
    prizesTextView.text = finalyStr;
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
