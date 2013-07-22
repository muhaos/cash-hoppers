//
//  CHHopChooserVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/28/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHHopChooserVC : UIViewController

- (IBAction)dailyHopTapped:(id)sender;
- (IBAction)specialHopsTapped:(id)sender;
- (IBAction)closeTapped:(id)sender;

+ (CHHopChooserVC*) sharedHopChooserVC;
- (void) showInController:(UIViewController*) c;

@end
