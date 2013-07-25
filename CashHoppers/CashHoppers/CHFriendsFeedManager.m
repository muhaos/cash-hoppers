//
//  CHFriendsFeedManager.m
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFriendsFeedManager.h"
#import "CHAPIClient.h"
#import "CHFriendsFeedItem.h"
#import "CHUser.h"
#import "CHHopTask.h"
#import "CHHop.h"
#import "CHHopsManager.h"

@implementation CHFriendsFeedManager

+ (CHFriendsFeedManager*) instance {
    static CHFriendsFeedManager* inst = nil;
    if (inst == nil) {
        inst = [[CHFriendsFeedManager alloc] init];
    }
    return inst;
}


- (id) init {
    if (self = [super init]) {
        self.friendsFeedItems = [NSMutableArray new];
        self.globalFeedItems = [NSMutableArray new];
    }
    return self;
}


- (void) loadFeedsFromPath:(NSString*) feedsPath destinationArray:(NSMutableArray*)dArray completionHandler:(void(^)(NSArray* result))handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"%@?api_key=%@&authentication_token=%@", feedsPath, CH_API_KEY,aToken];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray* json_tasks = [JSON objectForKey:@"tasks"];
        if (json_tasks) {
            [dArray removeAllObjects];
            for (NSDictionary* objDic in json_tasks) {
                CHFriendsFeedItem* newFeedItem = [[CHFriendsFeedItem alloc] init];
                [newFeedItem updateFromDictionary:objDic];
                [dArray addObject:newFeedItem];
            }
        }
        
        handler(dArray);
        
        for (CHFriendsFeedItem* f in dArray) {
            [self loadHopForFeedItem:f];
        }

    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForResponce:response :error :JSON];
    }];
    
    [operation start];
}


- (void) refreshFeeds {
    [self loadFriendsFeed];
    [self loadGlobalFeed];
}


- (void) loadGlobalFeed{
    
    [self loadFeedsFromPath:@"/api/tasks/get_all_hoppers_hop_tasks.json" destinationArray:self.globalFeedItems completionHandler:^(NSArray* result){
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_GLOBAL_FEED_UPDATED object:self];
    }];
    
}


- (void) loadFriendsFeed{

    [self loadFeedsFromPath:@"/api/tasks/get_friends_hop_tasks.json" destinationArray:self.friendsFeedItems completionHandler:^(NSArray* result){
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
    }];

}


- (void) loadHopForFeedItem:(CHFriendsFeedItem*)fItem {
    [[CHHopsManager instance] loadHopForID:fItem.hopID completionHandler:^(CHHop* hop) {
        fItem.hop = hop;
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FEED_ITEM_UPDATED object:fItem];
    }];
}



- (void) loadUserInfoForFeedItem:(CHFriendsFeedItem*)fItem{
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/users/get_my_info.json?api_key=%@&authentication_token=%@&user_id=%d", CH_API_KEY,aToken,[fItem.userID integerValue]];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSDictionary* userInfo = [JSON objectForKey:@"user"];
        if (userInfo) {
                CHUser* newUser = [[CHUser alloc] init];
                [newUser updateFromDictionary:userInfo];
                fItem.hopUser = newUser;
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSDictionary* userInfo = [JSON objectForKey:@"user"];
        if (userInfo) {
                CHUser* newUser = [[CHUser alloc] init];
                [newUser updateFromDictionary:userInfo];
                fItem.hopUser = newUser;
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
        
    }];
    
    [operation start];
}





@end
