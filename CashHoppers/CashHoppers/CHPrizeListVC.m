//
//  CHPrizeListVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/12/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHPrizeListVC.h"
#import "CHHopsManager.h"

@interface CHPrizeListVC ()

@property (nonatomic, strong) NSMutableArray* currentPrizes;

@end

@implementation CHPrizeListVC
@synthesize prizesTextView;


- (void)viewDidLoad
{
    prizesTextView.attributedText = nil;
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        CGRect newFrame = self.view.frame;
        newFrame.origin.y+=20;
        newFrame.size.height -=20;
        self.view.frame = newFrame;
    }
}


- (void) refreshPrizes {
    NSDictionary *whiteAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-CondensedBold" size:21.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]};
    NSDictionary *yellowAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-CondensedBold" size:21.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:204/255.0f blue:0.0f alpha:1.0f]};
    
    NSString* finalStr = @"";
    
    NSRange boldParts[100];
    for (int i = 0; i < [self.currentPrizes count]; i++) {
        boldParts[i].location = [finalStr length];
        boldParts[i].length = [[self.currentPrizes[i] objectForKey:@"prize_position"] length];
        finalStr = [finalStr stringByAppendingFormat:@"%@ - %@\n", [self.currentPrizes[i] objectForKey:@"prize_position"], [self.currentPrizes[i] objectForKey:@"prize_value"]];
    }
    
    NSMutableAttributedString* aString = [[NSMutableAttributedString alloc] initWithString:finalStr];
    NSInteger str_length = [finalStr length];
    [aString setAttributes:whiteAttribs range:NSMakeRange(0, str_length)];
    
    for (int i = 0; i < [self.currentPrizes count]; i++) {
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


- (void) showInController:(UIViewController*) c forHopID:(NSNumber*) hopID {
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"CHPrizeListVC" reason:@"Loading controller already showed!" userInfo:nil];
    }
    [c.view addSubview:self.view];
    
    prizesTextView.attributedText = nil;
    self.activityView.hidden = NO;
    
    [[CHHopsManager instance] loadPrizesForHopID:hopID completionHandler:^(NSArray* prizes) {
        self.currentPrizes = [NSMutableArray new];
        for (NSDictionary* d in prizes) {
            NSString* prize_position = [d objectForKey:@"title"];
            NSString* prize_value = [NSString stringWithFormat:@"%@", [d objectForKey:@"cost"]];
            [self.currentPrizes addObject:@{@"prize_position": prize_position, @"prize_value": prize_value }];
        }
        
        self.activityView.hidden = YES;
        [self refreshPrizes];
    }];
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
