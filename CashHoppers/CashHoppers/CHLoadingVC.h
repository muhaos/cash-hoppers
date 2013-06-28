//
//  CHLoadingVC.h
//  CashHoppers
//
//  Created by Eugene on 27.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHLoadingVC : UIViewController

+ (CHLoadingVC*) sharedLoadingVC;
- (void) showInController:(UIViewController*) c withText:(NSString*) text;
- (void) hide;

@end
