//
//  CHAddFriendVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/22/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAddFriendVC.h"

@interface CHAddFriendVC ()

@end

@implementation CHAddFriendVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"button_nav_back"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

    
    
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
