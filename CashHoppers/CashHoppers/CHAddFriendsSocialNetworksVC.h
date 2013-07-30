//
//  CHAddFriendsSocialNetworksVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

#define CH_SERVICE_FACEBOOK 1
#define CH_SERVICE_GOOGLE 2
#define CH_SERVICE_TWITTER 3

@interface CHAddFriendsSocialNetworksVC : UIViewController <UITableViewDataSource, UITableViewDelegate,FBRequestDelegate                                                                                                                                                                                                                                                                                                                                                                                         >

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITableView *friendsTable;

@property (retain, nonatomic) NSArray *peopleList;
@property (retain, nonatomic) NSMutableArray *peopleImageList;

@property (nonatomic, assign) int currentService;

- (void)listPeople:(NSString *)collection;
- (void)reportAuthStatus;
- (void)fetchPeopleImages;

@end
