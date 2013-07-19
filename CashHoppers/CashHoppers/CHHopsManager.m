//
//  CHHopsManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHopsManager.h"
#import "CHAPIClient.h"

@interface CHHopsManager ()

@end


@implementation CHHopsManager

+ (CHHopsManager*) instance {
    static CHHopsManager* inst = nil;
    if (inst == nil) {
        inst = [[CHHopsManager alloc] init];
        
    }
    return inst;
}


- (id) init {
    if (self = [super init]) {
        self.otherHops = [NSMutableArray new];
    }
    return self;
}


- (void) refreshHops {
    [self loadDailyHop];
    
    //NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hops.json?api_key=%@", CH_API_KEY];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];

    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [self.otherHops removeAllObjects];
        
        NSArray* hops = [JSON objectForKey:@"hops"];
        if (hops) {
            for (NSDictionary* objDic in hops) {
                CHHop* newHop = [[CHHop alloc] init];
                [newHop updateFromDictionary:objDic];
                
                if ([newHop.daily_hop boolValue]) {
                    self.dailyHop = newHop;
                } else {
                    [self.otherHops addObject:newHop];
                }
                
                [self loadTasksForHop:newHop];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_UPDATED object:self];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //[self defaultErrorHandlerForResponce:response :error :JSON];
        
        [self.otherHops removeAllObjects];
        self.dailyHop = nil;
        
        NSArray* hops = [JSON objectForKey:@"hops"];
        if (hops) {
            for (NSDictionary* objDic in hops) {
                CHHop* newHop = [[CHHop alloc] init];
                [newHop updateFromDictionary:objDic];
                
                if ([newHop.daily_hop boolValue]) {
                    self.dailyHop = newHop;
                } else {
                    [self.otherHops addObject:newHop];
                }
            
                [self loadTasksForHop:newHop];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_UPDATED object:self];

    }];
    
    [operation start];
}


- (void) loadDailyHop {
    //NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hops/daily?api_key=%@", CH_API_KEY];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.dailyHop = nil;
        
        NSArray* hops = [JSON objectForKey:@"hops"];
        if (hops) {
            for (NSDictionary* objDic in hops) {
                CHHop* newHop = [[CHHop alloc] init];
                [newHop updateFromDictionary:objDic];
                
                if ([newHop.daily_hop boolValue]) {
                    self.dailyHop = newHop;
                } else {
                    [self.otherHops addObject:newHop];
                }
                
                [self loadTasksForHop:newHop];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_UPDATED object:self];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //[self defaultErrorHandlerForResponce:response :error :JSON];
        
        [self.otherHops removeAllObjects];
        self.dailyHop = nil;
        
        NSArray* hops = [JSON objectForKey:@"hops"];
        if (hops) {
            for (NSDictionary* objDic in hops) {
                CHHop* newHop = [[CHHop alloc] init];
                [newHop updateFromDictionary:objDic];
                
                if ([newHop.daily_hop boolValue]) {
                    self.dailyHop = newHop;
                } else {
                    [self.otherHops addObject:newHop];
                }
                
                [self loadTasksForHop:newHop];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_UPDATED object:self];
        
    }];
    
    [operation start];
}


- (void) loadTasksForHop:(CHHop*) hop {
    
    //NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/get_hop_tasks?api_key=%@&hop_id=%i", CH_API_KEY, [hop.identifier intValue]];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSMutableArray* tasks = [NSMutableArray new];
        
        NSArray* json_tasks = [JSON objectForKey:@"hop_tasks"];
        if (json_tasks) {
            for (NSDictionary* objDic in json_tasks) {
                CHHopTask* newHopTask = [[CHHopTask alloc] init];
                [newHopTask updateFromDictionary:objDic];
                
                [tasks addObject:newHopTask];
            }
            hop.tasks = tasks;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_TASKS_UPDATED object:hop];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //[self defaultErrorHandlerForResponce:response :error :JSON];
        

        NSMutableArray* tasks = [NSMutableArray new];
        
        NSArray* json_tasks = [JSON objectForKey:@"hop_tasks"];
        if (json_tasks) {
            for (NSDictionary* objDic in json_tasks) {
                CHHopTask* newHopTask = [[CHHopTask alloc] init];
                [newHopTask updateFromDictionary:objDic];
                
                [tasks addObject:newHopTask];
            }
            hop.tasks = tasks;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_TASKS_UPDATED object:hop];

    }];
    
    [operation start];
    
}


@end
