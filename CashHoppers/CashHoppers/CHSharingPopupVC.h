//
//  CHSharingPopupVC.h
//  CashHoppers
//
//  Created by Eugene on 01.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPPShare.h"

@interface CHSharingPopupVC : UIViewController<GPPShareDelegate>

@property (nonatomic, strong) NSNumber* hopTaskID;
@property (strong, nonatomic) UIImage* imageToShare;
@property (nonatomic, retain) UIViewController* currentController;

- (void) showInController:(UIViewController*)controller;

+ (CHSharingPopupVC*) instance;

- (IBAction)facebookButTapped:(id)sender;
- (IBAction)gPlusButTapped:(id)sender;
- (IBAction)twitterButTapped:(id)sender;

@end
