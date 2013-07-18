//
//  CHMessagesVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/18/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMessagesVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *messagesTable;
@property (strong, nonatomic) IBOutlet UIButton *messagesButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationsButton;

- (IBAction)messagesTapped:(id)sender;
- (IBAction)notificationsTapped:(id)sender;

@end
