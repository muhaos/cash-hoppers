//
//  CHTradeShowEntryVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHHop;

@protocol CHTradeShowEntryVCDelegate <NSObject>

-(void) tradeShowEntryVCClosedSucced:(BOOL) succed;

@end


@interface CHTradeShowEntryVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *tradeShowImageView;
@property (strong, nonatomic) IBOutlet UILabel *tradeShowLabel;
@property (strong, nonatomic) IBOutlet UITextField *passcodeTextField;

@property (strong, nonatomic) CHHop* currentHop;
@property (weak, nonatomic) id<CHTradeShowEntryVCDelegate> delegate;

- (IBAction)startPlayingTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)helpTapped:(id)sender;


@end
