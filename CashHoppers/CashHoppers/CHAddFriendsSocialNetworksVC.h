//
//  CHAddFriendsSocialNetworksVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CHAddFriendsCell.h"

@interface CHAddFriendsSocialNetworksVC : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITableView *friendsTable;
@property (retain, nonatomic) NSArray *peopleList;
@property (retain, nonatomic) NSMutableArray *peopleImageList;

//- (void)listPeople:(NSString *)collection;
//- (void)reportAuthStatus;
//- (void)fetchPeopleImages;

@end
