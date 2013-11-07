//
//  CHFirstTimeSetUpVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 11/7/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHFirstTimeSetUpVC : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)cancelButtonTapped:(id)sender;

+ (CHFirstTimeSetUpVC*) sharedFirstTimeSetUpVC;
- (void) showInController:(UIViewController*) c;

@end
