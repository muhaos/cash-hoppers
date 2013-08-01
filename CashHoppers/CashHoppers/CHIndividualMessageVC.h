//
//  CHComposeNewMessageVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHIndividualMessageVC : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *messagesTable;
@property (strong, nonatomic) IBOutlet UITextView *inputMessageTextView;

@property (strong, nonatomic) NSNumber* currentFriendID;

- (IBAction) replyMessageButtonTapped:(id)sender;
- (IBAction) composeNewMessageTapped:(id)sender;

@end
