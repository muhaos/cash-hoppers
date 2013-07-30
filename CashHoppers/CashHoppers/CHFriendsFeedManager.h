//
//  CHFriendsFeedManager.h
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHBaseManager.h"
#import "CHFriendsFeedItem.h"

#define CH_NUMBER_OF_NEWS_PER_PAGE @"100500"
#define CH_FRIEND_FEED_UPDATED @"CH_FRIEND_FEED_UPDATED"
#define CH_GLOBAL_FEED_UPDATED @"CH_GLOBAL_FEED_UPDATED"

// User or hop loaded for feed item. Object is feed item instance
#define CH_FEED_ITEM_UPDATED @"CH_FEED_ITEM_UPDATED"

#define CH_COMMENT_SENT @"CH_COMMENT_SENT"
#define CH_COMMENTS_RECEIVED @"CH_COMMENTS_RECEIVED"
#define CH_COMMENT_UPDATED @"CH_COMMENT_UPDATED"

@interface CHFriendsFeedManager : CHBaseManager
 
    
+ (CHFriendsFeedManager*) instance;

- (void) refreshFeeds;
- (void) loadFriendsFeed;
- (void) loadGlobalFeed;
-(void) loadCommentsForFeedItem:(CHFriendsFeedItem*) feedItem completionHandler:(void (^)(NSArray* coments)) handler;
-(void) postCommentForFeedItem:(CHFriendsFeedItem*) feedItem withText:(NSString*) text completionHandler:(void (^)(BOOL success))handler;

@property (nonatomic, strong) NSMutableArray *friendsFeedItems;
@property (nonatomic, strong) NSMutableArray *globalFeedItems;

@end
