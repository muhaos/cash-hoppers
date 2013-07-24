//
//  CHFriendsListVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHFriendsFeedManager;

@interface CHFriendsListVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *friendsTable;
@property (strong, nonatomic) IBOutlet UIButton *friendsButton;
@property (strong, nonatomic) IBOutlet UIButton *allHoppersButton;
@property (strong, nonatomic) CHFriendsFeedManager *friendsFeedManager;
@property (strong, nonatomic) NSMutableArray *friendsFeed;
@property (strong, nonatomic) NSMutableArray *globalFeed;
@property (strong, nonatomic) NSMutableArray *hopsImages;

- (IBAction)friendsButtonTapped:(id)sender;
- (IBAction)allHopppersButtonTapped:(id)sender;


@end
