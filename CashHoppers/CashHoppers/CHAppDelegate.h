//
//  CHAppDelegate.h
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CHView{
    CHHome = 1,
    CHFeed,
    CHNewHop,
    CHPicture,
    CHMessage
};

@class MHCustomTabBarController;
@interface CHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MHCustomTabBarController *tabBarController;

-(void)switchViewTo:(enum CHView)view;

@end
