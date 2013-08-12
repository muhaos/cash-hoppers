//
//  CHSettingsProfileNotificationsVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/12/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHPushNotificationsVC, CHProfileUserVC;

@interface CHSettingsProfileNotificationsVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationsButton;

@property (strong, nonatomic, readwrite) CHPushNotificationsVC *pushNotificationsVC;
@property (strong, nonatomic, readwrite) CHProfileUserVC *profileUserVC;

- (IBAction)profileButtonTapped:(id)sender;
- (IBAction)notificationsButtonTapped:(id)sender;


@end
