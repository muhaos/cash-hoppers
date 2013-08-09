//
//  CHAddFriendVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/22/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAddFriendVC.h"
#import "CHUserManager.h"
#import <QuartzCore/QuartzCore.h>
#import "CHUserManager.h"

@interface CHAddFriendVC ()

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation CHAddFriendVC
@synthesize nameLabel, photoImageView, inviteSentCheckmarkImageView, inviteSentLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    
    [self.photoImageView setImageWithURL:self.currentUser.avatarURL];
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", self.currentUser.first_name, self.currentUser.last_name]];
    [self.descTextView setText:[NSString stringWithFormat:@"%@", self.currentUser.bio]];
    [self.countFriendsLabel setText:[NSString stringWithFormat:@"%i", [self.currentUser.friends_count intValue]]];
    
    photoImageView.layer.cornerRadius = 4.0f;
    photoImageView.layer.masksToBounds = YES;
    
    inviteSentLabel.hidden = YES;
    inviteSentCheckmarkImageView.hidden = YES;
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setNameLabel:nil];
    [self setDescTextView:nil];
    [self setCountFriendsLabel:nil];
    [self setYourFriendsImageView:nil];
    [self setAddFriendButton:nil];
    [self setInviteSentCheckmarkImageView:nil];
    [self setInviteSentLabel:nil];
    [super viewDidUnload];
}


- (IBAction)addFriendTapped:(id)sender
{
    self.addFriendButton.enabled = NO;

    
    [[CHUserManager instance] sendFriendInvitationToUser:self.currentUser withCompletionHandler:^(NSError *error) {
        
        if ([error isEqual: @"200"]){
            
            self.addFriendButton.hidden = YES;
            inviteSentCheckmarkImageView.hidden = NO;
            inviteSentLabel.hidden = NO;
            self.addFriendButton.enabled = YES;
            self.addFriendButton.hidden = YES;
            
        }else if ([error isEqual:@"406"]){
            self.addFriendButton.enabled = YES;
        }
    }];

    
//    [self.yourFriendsImageView setImage:[UIImage imageNamed:@"you_are_friends.png"]];
}


@end
