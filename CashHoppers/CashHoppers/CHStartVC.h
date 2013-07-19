//
//  CHStartVC.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPPSignIn.h"

static NSString * const kClientId = @"726071056773.apps.googleusercontent.com";

@class GPPSignInButton;

@interface CHStartVC : UIViewController <GPPSignInDelegate>

- (void)loginFailed;

@property (retain, nonatomic) IBOutlet GPPSignInButton *loginWithGoogleButton;

@end
