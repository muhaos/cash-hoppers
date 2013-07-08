//
//  CHTradeShowEntryVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTradeShowEntryVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *tradeShowImageView;
@property (strong, nonatomic) IBOutlet UILabel *tradeShowLabel;
@property (strong, nonatomic) IBOutlet UITextField *passcodeTextField;

- (IBAction)startPlayingTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)helpTapped:(id)sender;

+ (CHTradeShowEntryVC*) sharedTradeShowEntryVC;

- (void) showInController:(UIViewController*) c
                 withText:(NSString*) text
                withImage:(UIImageView*) image;


@end
