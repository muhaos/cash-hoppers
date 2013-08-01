//
//  CHFindFriendsVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface CHFindFriendsVC : UIViewController <UITextFieldDelegate>{
    ACAccount *myAccount;
    NSMutableString *paramString;
    NSMutableArray *resultFollowersNameList;
}

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *headerText;

@property(nonatomic,retain) ACAccount *myAccount;
@property(nonatomic, retain) NSMutableString *paramString;
@property(nonatomic, retain) NSMutableArray *resultFollowersNameList;

- (IBAction)twitterFriendsTapped:(id)sender;
- (IBAction)facebookFriendsTapped:(id)sender;
- (IBAction)googleFriendsTapped:(id)sender;
- (IBAction)sendEmailTapped:(id)sender;

@end
