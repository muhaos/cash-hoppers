//
//  CHAppDelegate.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHHomeScreenViewController.h"


@class MHCustomTabBarController, ACAccount,MFSideMenuContainerViewController;
@interface CHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MHCustomTabBarController *tabBarController;
@property (strong, nonatomic) CHHomeScreenViewController *homeScreenVC;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) MFSideMenuContainerViewController *menuContainerVC;
@property (nonatomic, assign) BOOL needOpenDailyHops; // for hops chooser
@property (nonatomic, assign) BOOL needOpenOtherHops;
@property (nonatomic, assign) BOOL needOpenFriendsFeed; // for tab bar button
@property (nonatomic, retain) NSTimer* messagesSyncTimer;

-(void)openSession;

@end
