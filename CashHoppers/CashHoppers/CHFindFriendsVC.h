//
//  CHFindFriendsVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CHFindFriendsVC : UIViewController <UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *headerText;
@property (strong, nonatomic) IBOutlet UITableView *findFriendsSearchTableView;
@property (strong, nonatomic) IBOutlet UIButton *cancelSearchButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, retain) NSArray* searchResultUsers;

- (IBAction)twitterFriendsTapped:(id)sender;
- (IBAction)facebookFriendsTapped:(id)sender;
- (IBAction)googleFriendsTapped:(id)sender;
- (IBAction)sendEmailTapped:(id)sender;
- (IBAction)cancelSearchButtonTapped:(id)sender;

- (IBAction) searchFieldChanged:(id)sender;

@end
