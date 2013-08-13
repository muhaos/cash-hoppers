//
//  CHFriendsListVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHFriendsListCell.h"

@class CHFriendsListCell;

@interface CHFriendsListVC : UIViewController<CHFriendsListCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *friendsTable;
@property (strong, nonatomic) IBOutlet UIButton *friendsButton;
@property (strong, nonatomic) IBOutlet UIButton *allHoppersButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

- (IBAction)friendsButtonTapped:(id)sender;
- (IBAction)allHopppersButtonTapped:(id)sender;
- (void)likeTappedInCell:(CHFriendsListCell*)cell;
- (IBAction)settingsButtonTapped:(id)sender;



@end
