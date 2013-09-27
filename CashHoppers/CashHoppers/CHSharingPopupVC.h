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

@property (nonatomic, retain) NSURL *imageToShareURL;
@property (nonatomic, strong) NSNumber* hopTaskID;
@property (strong, nonatomic) UIImage* imageToShare;
@property (strong, nonatomic) UIImage* logoToShare;
@property (strong, nonatomic) NSString* bonusPointsCount;
@property (strong, nonatomic) NSString* curentHop;
@property (strong, nonatomic) NSString* commentToHopTask;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *googleButton;

@property (strong, nonatomic) IBOutlet UILabel *bonusPointsLabel;
@property (nonatomic, assign) UIViewController* currentController;

- (void) showInController:(UIViewController*)controller;

+ (CHSharingPopupVC*) instance;

- (IBAction)facebookButTapped:(id)sender;
- (IBAction)gPlusButTapped:(id)sender;
- (IBAction)twitterButTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;

@end
