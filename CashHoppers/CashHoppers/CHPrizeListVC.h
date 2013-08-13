//
//  CHPrizeListVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/12/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHPrizeListVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *prizesTextView;
@property (nonatomic, retain) NSMutableString *finalyStr;

- (IBAction)cancelButtonTapped:(id)sender;
+ (CHPrizeListVC*) sharedPrizeListVC;
- (void) showInController:(UIViewController*) c;

@end
