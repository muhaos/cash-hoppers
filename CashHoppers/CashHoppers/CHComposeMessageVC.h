//
//  CHComposeMessageVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/26/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHComposeMessageVC : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITextView *inputMessageTextView;
@property (strong, nonatomic) IBOutlet UITableView *userListTable;

- (IBAction)sendMessageTapped:(id)sender;

@end
