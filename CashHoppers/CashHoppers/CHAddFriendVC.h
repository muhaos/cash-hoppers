//
//  CHAddFriendVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/22/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHUser;

@interface CHAddFriendVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet UILabel *countFriendsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *yourFriendsImageView;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;

@property (strong, nonatomic) CHUser* currentUser;

- (IBAction)addFriendTapped:(id)sender;

@end
