//
//  CHAddFriendVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/22/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAddFriendVC.h"

@interface CHAddFriendVC ()

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation CHAddFriendVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    
    [self.photoImageView setImage:[UIImage imageNamed:@"photo_hop"]];
    [self.nameLabel setText:@"Brian Kelly"];
    [self.descTextView setText:@"Owner of Hayes and Taylor Apparel. UI/UX/Graohic Designer.Buckey Fan. Indianapolis, 1N"];
    [self.countFriendsLabel setText:@"78 Friends"];
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
    [super viewDidUnload];
}


- (IBAction)addFriendTapped:(id)sender
{
    self.addFriendButton.hidden = YES;
    [self.yourFriendsImageView setImage:[UIImage imageNamed:@"you_are_friends.png"]];
}


@end
