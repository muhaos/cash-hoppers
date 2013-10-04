//
//  CHAgreeToTermsVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 10/4/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAgreeToTermsVC : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)yesButtonTapped:(id)sender;
- (IBAction)noButtonTapped:(id)sender;

+ (CHAgreeToTermsVC*) sharedAgreeToTermsVC;
- (void) showInController:(UIViewController*) c;

@end
