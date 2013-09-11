//
//  CHAppDelegate.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHHomeScreenViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Reachability.h"

extern NSString *const FBSessionStateChangedNotification;


#define CH_LOGIN_EXPIRED @"CH_LOGIN_EXPIRED"


@class MHCustomTabBarController, ACAccount,MFSideMenuContainerViewController;
@interface CHAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id startVC;
@property (strong, nonatomic) MHCustomTabBarController *tabBarController;
@property (strong, nonatomic) CHHomeScreenViewController *homeScreenVC;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) MFSideMenuContainerViewController *menuContainerVC;
@property (nonatomic, assign) BOOL needOpenDailyHops; // for hops chooser
@property (nonatomic, assign) BOOL needOpenOtherHops;
@property (nonatomic, strong) NSNumber* needOpenHopWithID;
@property (nonatomic, assign) BOOL needOpenFriendsFeed; // for tab bar button
@property (strong, nonatomic) NSString *loggedInUserID;
@property (strong, nonatomic) FBSession *loggedInSession;
@property (nonatomic, assign) BOOL appUsageCheckEnabled;
@property (assign, nonatomic) NetworkStatus netStatus;
@property (strong, nonatomic) Reachability  *hostReach;
@property (strong, nonatomic) id loginExpiredNotif;

- (void)updateInterfaceWithReachability:(Reachability*) curReach;
- (void)switchViewTo:(enum CHView)view;
- (void)openSession;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;
- (void) sendRequest;

@end
