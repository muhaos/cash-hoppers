//
//  CHBuyHopVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/15/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHBuyHopVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *nameHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *costHopLabel;
@property (strong, nonatomic) IBOutlet UILabel *yourBalanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyNowButton;
@property (strong, nonatomic) IBOutlet UIButton *buy10RibbitsButton;
@property (strong, nonatomic) IBOutlet UIButton *buy50RibbitsButton;
@property (strong, nonatomic) IBOutlet UIButton *buy100RibbitsButton;

- (IBAction)buyNowButtonTapped:(id)sender;
- (IBAction)buy10RibbitsButtonTapped:(id)sender;
- (IBAction)buy50RibbitsButtonTapped:(id)sender;
- (IBAction)buy100RibbitsButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;

+ (CHBuyHopVC*) sharedBuyHopVC;
- (void) showInController:(UIViewController*) c
              withNameHop:(NSString*)nameHop
              withCostHop:(NSString*)costHop ;

@end
