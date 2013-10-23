//
//  CHSettingsProfileNotificationsVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/12/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHSettingsProfileNotificationsVC.h"
#import "CHPushNotificationsVC.h"
#import "CHProfileUserVC.h"

@interface CHSettingsProfileNotificationsVC (){
    BOOL  profileButtonActive;
}

@end

@implementation CHSettingsProfileNotificationsVC
@synthesize profileButton, notificationsButton, containerView, profileUserVC, pushNotificationsVC;


- (void)viewDidLoad
{
    [super viewDidLoad];
    profileButtonActive = YES;
    [self activeButton:YES];
    
    if (self.storyboard) {
        profileUserVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileUserVC"];
        pushNotificationsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pushNotificationsVC"];
    }
    [self addProfileToView];
    
    [self setupTriangleBackButton];
    
}


- (void) backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)activeButton:(BOOL)profilesButton {
    if (profilesButton == YES) {
        [profileButton setImage:[UIImage imageNamed:@"button_profile_act"] forState:UIControlStateNormal];
        [notificationsButton setImage:[UIImage imageNamed:@"button_notific_n"] forState:UIControlStateNormal];
    } else {
        [profileButton setImage:[UIImage imageNamed:@"button_profile_n"] forState:UIControlStateNormal];
        [notificationsButton setImage:[UIImage imageNamed:@"button_notific_act"] forState:UIControlStateNormal];
    }
}


- (void)viewDidUnload {
    [self setContainerView:nil];
    [self setProfileButton:nil];
    [self setNotificationsButton:nil];
    [super viewDidUnload];
}


- (IBAction)profileButtonTapped:(id)sender {
    profileButtonActive = YES;
    [self activeButton:profileButtonActive];
    
    if (![pushNotificationsVC.view isHidden]) {
        [pushNotificationsVC.view removeFromSuperview];
    }
    [self addProfileToView];
}


- (IBAction)notificationsButtonTapped:(id)sender {
    profileButtonActive = NO;
    [self activeButton:profileButtonActive];
    
    if (![profileUserVC.view isHidden]) {
         [profileUserVC.view removeFromSuperview];
    }
    
    CGRect pushNotificationsFrame = self.containerView.frame;
    pushNotificationsFrame.origin.x = 0;
    pushNotificationsFrame.origin.y = 0;
    
    pushNotificationsVC.view.frame = pushNotificationsFrame;
    [self addChildViewController:pushNotificationsVC];
    [self.containerView addSubview:pushNotificationsVC.view];
}


-(void)addProfileToView
{
    CGRect profileUserFrame = self.containerView.frame;
    profileUserFrame.origin.x = 0;
    profileUserFrame.origin.y = 0;
    
    profileUserVC.view.frame = profileUserFrame;
    [self addChildViewController:profileUserVC];
    [self.containerView addSubview:profileUserVC.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
