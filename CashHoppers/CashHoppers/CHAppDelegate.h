//
//  CHAppDelegate.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHHomeScreenViewController.h"
#import "GPPURLHandler.h"
#define kSocialAccountTypeKey @"SOCIAL_ACCOUNT_TYPE"


enum CHView{
    CHHome = 1,
    CHFeed,
    CHHopChooser,
    CHPicture,
    CHMessage
};

@class MHCustomTabBarController, ACAccount;;
@interface CHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MHCustomTabBarController *tabBarController;
@property (strong, nonatomic) CHHomeScreenViewController *homeScreenVC;
@property (strong, nonatomic) UINavigationController* navController;
-(void)switchViewTo:(enum CHView)view;
- (void)openSession;
- (void)getTwitterAccountOnCompletion:(void(^)(ACAccount *))completionHandler;
@end
