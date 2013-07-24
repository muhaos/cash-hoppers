//
//  CHFriendsFeedManager.h
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHBaseManager.h"

#define CH_NUMBER_OF_NEWS_PER_PAGE @"6"
#define CH_FRIEND_FEED_UPDATED @"CH_FRIEND_FEED_UPDATED"
#define CH_GLOBAL_FEED_UPDATED @"CH_GLOBAL_FEED_UPDATED"

@interface CHFriendsFeedManager : CHBaseManager
 
    
+ (CHFriendsFeedManager*) instance;
-(void)loadFriendsFeed;
- (void) loadGlobalFeed;

@property (nonatomic, strong) NSMutableArray *friendsFeed;
@property (nonatomic, strong) NSMutableArray *globalFeed;



@end
