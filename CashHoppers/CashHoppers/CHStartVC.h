//
//  CHStartVC.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPPSignIn.h"

static NSString * const kClientId = @"60822672999.apps.googleusercontent.com";

typedef enum SocialAccountType  {
    SocialAccountTypeFacebook = 1,
    SocialAccountTypeTwitter = 2
} SocialAccountType;

@class GPPSignInButton;

@interface CHStartVC : UIViewController <GPPSignInDelegate>

- (void)loginFailed;
- (id)initWithSocialAccountType:(SocialAccountType)socialAccountType;
@property (retain, nonatomic) IBOutlet GPPSignInButton *loginWithGoogleButton;

@end
