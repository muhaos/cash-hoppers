//
//  CHAppDelegate.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHHomeScreenViewController.h"

enum CHView{
    CHHome = 1,
    CHFeed,
    CHHopChooser,
    CHPicture,
    CHMessage
};

@class MHCustomTabBarController, ACAccount,MFSideMenuContainerViewController;
@interface CHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MHCustomTabBarController *tabBarController;
@property (strong, nonatomic) CHHomeScreenViewController *homeScreenVC;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) MFSideMenuContainerViewController *menuContainerVC;

-(void)switchViewTo:(enum CHView)view;
-(void)openSession;

@end
