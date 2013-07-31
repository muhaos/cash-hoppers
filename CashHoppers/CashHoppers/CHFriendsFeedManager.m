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
#import "CHUserManager.h"
#import "CHFeedItemComment.h"

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
//        NSLog(@"json = %@")
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
            [self loadUserForFeedItem:f];
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


- (void) loadUserForFeedItem:(CHFriendsFeedItem*)fItem {
    [[CHUserManager instance] loadUserForID:fItem.userID completionHandler:^(CHUser* user){
        fItem.user = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FEED_ITEM_UPDATED object:fItem];
    }];
}

-(void) loadCommentsForFeedItem:(CHFriendsFeedItem*) feedItem completionHandler:(void (^)(NSArray* coments)) handler{
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/task/get_comments.json?api_key=%@&authentication_token=%@&user_hop_task_id=%d", CH_API_KEY,aToken,[feedItem.identifier integerValue]];
    NSLog(@"feedItem.identifier=%@",feedItem.identifier);
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray* json_comments = [JSON objectForKey:@"comments"];
        NSMutableArray *comments = [NSMutableArray arrayWithCapacity:1];
        if (json_comments) {
            for (NSDictionary* objDic in json_comments) {
                CHFeedItemComment* newComment = [[CHFeedItemComment alloc] init];
                [newComment updateFromDictionary:objDic];
                [comments addObject:newComment];
            }
        }
        
        handler(comments);

        
        for (CHFeedItemComment *comment in comments) {
            [[CHUserManager instance]loadUserForID:comment.user_id completionHandler:^(CHUser *user) {
                comment.user = user;
                [[NSNotificationCenter defaultCenter] postNotificationName:CH_FEED_ITEM_COMMENT_UPDATED object:comment];
            }];
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSArray* json_comments = [JSON objectForKey:@"comments"];
        NSMutableArray *comments = [NSMutableArray arrayWithCapacity:1];
        if (json_comments) {
            for (NSDictionary* objDic in json_comments) {
                CHFeedItemComment* newComment = [[CHFeedItemComment alloc] init];
                [newComment updateFromDictionary:objDic];
                [comments addObject:newComment];
            }
        }
        
        handler(comments);

            

        for (CHFeedItemComment *comment in comments) {
            [[CHUserManager instance]loadUserForID:comment.user_id completionHandler:^(CHUser *user) {
                comment.user = user;
                [[NSNotificationCenter defaultCenter] postNotificationName:CH_FEED_ITEM_COMMENT_UPDATED object:comment];
            }];
        }
        
    } ];
    
    [operation start];
}


-(void) postCommentForFeedItem:(CHFriendsFeedItem*) feedItem withText:(NSString*) text completionHandler:(void (^)(BOOL success))handler{
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/task/comment.json"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:CH_API_KEY forKey:@"api_key"];
    [params setObject:aToken forKey:@"authentication_token"];
    [params setObject:feedItem.identifier forKey:@"user_hop_task_id"];
    [params setObject:text forKey:@"text"];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:params];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        handler(YES);
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_COMMENT_SENT object:nil];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForResponce:response :error :JSON];
        
        handler(NO);
        
    }];

    
    [operation start];
    
    
}

-(void) postLikeForFeedItem:(CHFriendsFeedItem*) feedItem completionHandler:(void (^)(NSError* error))handler{
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/task/like.json"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:CH_API_KEY forKey:@"api_key"];
    [params setObject:aToken forKey:@"authentication_token"];
    [params setObject:feedItem.identifier forKey:@"user_hop_task_id"];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:params];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        handler(nil);
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        [self defaultErrorHandlerForResponce:response :error :JSON];
        handler(error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat: @"Error occured while trying to send like: %@",error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }];
    
    
    [operation start];
    
}



@end
