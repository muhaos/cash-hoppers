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

@implementation CHFriendsFeedManager

@synthesize friendsFeed,globalFeed;

+ (CHFriendsFeedManager*) instance {
    static CHFriendsFeedManager* inst = nil;
    if (inst == nil) {
        inst = [[CHFriendsFeedManager alloc] init];
        
    }
    return inst;
}

- (id) init {
    if (self = [super init]) {
        friendsFeed = [NSMutableArray new];
        globalFeed = [NSMutableArray new];
    }
    return self;
}

- (void) loadGlobalFeed{
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/tasks/get_all_hoppers_hop_tasks.json?api_key=%@&authentication_token=%@&per_page=%@&page=1", CH_API_KEY,aToken,CH_NUMBER_OF_NEWS_PER_PAGE];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSArray* json_tasks = [JSON objectForKey:@"tasks"];
        if (json_tasks) {
            for (NSDictionary* objDic in json_tasks) {
                CHFriendsFeedItem* newFeedItem = [[CHFriendsFeedItem alloc] init];
                [newFeedItem updateFromDictionary:objDic];
                [self loadUserInfoForFeedItem:newFeedItem];
                [self loadHopTaskForFeedItem:newFeedItem];
                [globalFeed addObject:newFeedItem];
                
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_GLOBAL_FEED_UPDATED object:self];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSArray* json_tasks = [JSON objectForKey:@"tasks"];
        if (json_tasks) {
            for (NSDictionary* objDic in json_tasks) {
                CHFriendsFeedItem* newFeedItem = [[CHFriendsFeedItem alloc] init];
                [newFeedItem updateFromDictionary:objDic];
                [self loadUserInfoForFeedItem:newFeedItem];
                [self loadHopTaskForFeedItem:newFeedItem];
                [self loadHopForFeedItem:newFeedItem];
                [friendsFeed addObject:newFeedItem];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_GLOBAL_FEED_UPDATED object:self];
        
    }];
    
    [operation start];
    
}


- (void) loadFriendsFeed{
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/tasks/get_friends_hop_tasks.json?api_key=%@&authentication_token=%@&per_page=%@&page=1", CH_API_KEY,aToken,CH_NUMBER_OF_NEWS_PER_PAGE];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSArray* json_tasks = [JSON objectForKey:@"tasks"];
        if (json_tasks) {
            for (NSDictionary* objDic in json_tasks) {
                CHFriendsFeedItem* newFeedItem = [[CHFriendsFeedItem alloc] init];
                [newFeedItem updateFromDictionary:objDic];
                [self loadUserInfoForFeedItem:newFeedItem];
                [self loadHopTaskForFeedItem:newFeedItem];
                [friendsFeed addObject:newFeedItem];
                
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {        
                
        NSArray* json_tasks = [JSON objectForKey:@"tasks"];
        if (json_tasks) {
            for (NSDictionary* objDic in json_tasks) {
                CHFriendsFeedItem* newFeedItem = [[CHFriendsFeedItem alloc] init];
                [newFeedItem updateFromDictionary:objDic];
                [self loadUserInfoForFeedItem:newFeedItem];
                [self loadHopTaskForFeedItem:newFeedItem];
                [self loadHopForFeedItem:newFeedItem];
                [friendsFeed addObject:newFeedItem];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
        
    }];
    
    [operation start];
    
}
-(void)loadUserInfoForFeedItem:(CHFriendsFeedItem*)fItem{
    
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

-(void)loadHopTaskForFeedItem:(CHFriendsFeedItem*)fItem{
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/task/get_hop_task.json?api_key=%@&authentication_token=%@&hop_task_id=%d", CH_API_KEY,aToken,[fItem.hopTaskID integerValue]];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSDictionary* taskInfo = [JSON objectForKey:@"hop_task"];
        if (taskInfo) {
                CHHopTask* newTask = [[CHHopTask alloc] init];
                [newTask updateFromDictionary:taskInfo];
                fItem.hopTask = newTask;
        }
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSDictionary* taskInfo = [JSON objectForKey:@"hop_task"];
        if (taskInfo) {
                CHHopTask* newTask = [[CHHopTask alloc] init];
                [newTask updateFromDictionary:taskInfo];
                fItem.hopTask = newTask;
        }
        //        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
        
    }];
    
    [operation start];
}

-(void)loadHopForFeedItem:(CHFriendsFeedItem*)fItem{
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hop/get_hop.json?api_key=%@&authentication_token=%@&hop_id=%d", CH_API_KEY,aToken,[fItem.hopID integerValue]];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        NSDictionary* taskInfo = [JSON objectForKey:@"hop"];
        if (taskInfo) {
            CHHop* newHop = [[CHHop alloc] init];
            [newHop updateFromDictionary:taskInfo];
            fItem.hop = newHop;
        }
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSDictionary* taskInfo = [JSON objectForKey:@"hop"];
        if (taskInfo) {
            CHHop* newHop = [[CHHop alloc] init];
            [newHop updateFromDictionary:taskInfo];
            fItem.hop = newHop;
        }
        //        [[NSNotificationCenter defaultCenter] postNotificationName:CH_FRIEND_FEED_UPDATED object:self];
        
    }];
    
    [operation start];
}




@end
