//
//  CHAddFriendsSocialNetworksVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CHAddFriendsSocialNetworksVC : UIViewController <UITableViewDataSource, UITableViewDelegate                                                                                                                                                                                                                                                                                                                                                                                                      >

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITableView *friendsTable;


// A list of people that is visible to this sample app.
@property (retain, nonatomic) NSArray *peopleList;
// A list of people profile images that we will prefetch that is
// visible to this sample app.
@property (retain, nonatomic) NSMutableArray *peopleImageList;


- (void)listPeople:(NSString *)collection;
- (void)reportAuthStatus;
- (void)fetchPeopleImages;
@end
