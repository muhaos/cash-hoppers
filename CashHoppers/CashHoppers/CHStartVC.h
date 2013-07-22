//
//  CHStartVC.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPPSignIn.h"
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"

#define kOAuthConsumerKey @"mW5vfqMKEx1HGME7OeGCg";
#define kOAuthConsumerSecret @"RjiYj98WZSjKBbHn9r3hGYvMfptYPp5pQCP8h4gNH5A";

extern SA_OAuthTwitterEngine	*tweeterEngine;
static NSString * const kClientId = @"726071056773.apps.googleusercontent.com";

@class GPPSignInButton;

@interface CHStartVC : UIViewController <GPPSignInDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate>

- (void)loginFailed;

@property (retain, nonatomic) IBOutlet GPPSignInButton *loginWithGoogleButton;

@end
