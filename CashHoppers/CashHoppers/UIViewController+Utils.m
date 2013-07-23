//
//  UIViewController+Utils.m
//  CashHoppers
//
//  Created by Vova Musiienko on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "UIViewController+Utils.h"

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

@end
