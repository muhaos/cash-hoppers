//
//  UIViewController+Utils.m
//  CashHoppers
//
//  Created by Vova Musiienko on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "CHAdvertisingVC.h"
#import "CHAppDelegate.h"

@implementation UIViewController (Utils)

- (void) setupTriangleBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"button_nav_back"];
    [backBtn setImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 40, 20);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 15, 1, 10);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}


static CHAdvertisingVC* vc = nil;

- (void) showAdsWithType:(NSString*) adsType andHopID:(NSNumber*) hopID {
    

    if (vc) {
        [vc closeTapped:nil];
        vc = nil;
    }
    
    vc = [CHAdvertisingVC instanceWithAdType:adsType andHopID:hopID];
    UIWindow* w = ((CHAppDelegate*)[[UIApplication sharedApplication] delegate]).window;
    vc.ownerController = self;
    [w addSubview:vc.view];
    CGRect r = w.bounds;
    float offset = 20.0f;
    r.origin.y = offset;
    r.size.height = r.size.height - offset;
    vc.view.frame = r;
    
    // 3/4 ads
    if ([adsType isEqualToString:@"RPOU"]) {
        float offset = vc.container.frame.size.height * 0.25f;
        CGRect r = vc.container.frame;
        r.origin.y += offset;
        r.size.height -= offset;
        vc.container.frame = r;
    }
}


@end
