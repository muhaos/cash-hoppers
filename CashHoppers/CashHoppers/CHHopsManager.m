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
        self.otherHops = @[];
        self.dailyHops = @[];
        [self initCacheWithName:@"hops" andExpirationTime:60.0f*15.0f]; // 15min
    }
    return self;
}


- (void) loadHopsFromPath:(NSString*) hopsPath destinationArray:(NSArray*)dArray completionHandler:(void(^)(NSArray* hops))handler {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"%@?page=1&per_page=100500&api_key=%@&authentication_token=%@", hopsPath, CH_API_KEY, aToken];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSMutableArray* addedOrUpdatedObjects = [NSMutableArray new];
        NSArray* hops = [JSON objectForKey:@"hops"];
        if (hops == nil && [JSON objectForKey:@"daily_hops"] != nil) {
            hops = [JSON objectForKey:@"daily_hops"];
        }
        
        if (hops) {
            for (NSDictionary* objDic in hops) {
                if ([CHHop isValidHopDictionary:objDic]) {
                    CHHop* newHop = (CHHop*)[self findObjectWithID:[objDic objectForKey:@"id"] inArray:dArray];
                    if (newHop == nil) {
                        newHop = [[CHHop alloc] init];
                    }
                    [newHop updateFromDictionary:objDic];
                    [self putObject:newHop intoCache:@"hops"];
                    [addedOrUpdatedObjects addObject:newHop];
                }
            }
            handler(addedOrUpdatedObjects);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_UPDATED object:self];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
    }];
    
    [operation start];
}


- (void) refreshHops {
    [self refreshDailyHops];
    [self refreshOtherHops];
}


- (void) refreshDailyHops {
    [self loadHopsFromPath:@"/api/hops/daily.json" destinationArray:self.dailyHops completionHandler:^(NSArray* hops){
        self.dailyHops = hops;
        for (CHHop* h in self.dailyHops) {
            [self loadTasksForHop:h completionHandler:^(CHHop* hop){}];
        }
    }];
}


- (void) refreshOtherHops {
    [self loadHopsFromPath:@"/api/hops/regular.json" destinationArray:self.otherHops completionHandler:^(NSArray* hops){
        self.otherHops = hops;
        for (CHHop* h in self.otherHops) {
            [self loadTasksForHop:h completionHandler:^(CHHop* hop){}];
        }
    }];
}


- (void) loadHopForID:(NSNumber*) _id completionHandler:(void (^)(CHHop* hop)) handler {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hop/get_hop.json?api_key=%@&authentication_token=%@&hop_id=%d", CH_API_KEY,aToken, [_id intValue]];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    CHBaseModel* cachedObj = [self findObjectWithID:_id inCache:@"hops"];
    if (cachedObj) {
        [self loadTasksForHop:(CHHop*)cachedObj completionHandler:handler];
        return;
    }
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSDictionary* hop = [JSON objectForKey:@"hop"];
        if (hop) {
            CHHop* newHop = [[CHHop alloc] init];
            [newHop updateFromDictionary:hop];
            [self putObject:newHop intoCache:@"hops"];
            [self loadTasksForHop:newHop completionHandler:handler];
        }
    
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(nil);
    }];

    [operation start];
}


- (void) loadTasksForHop:(CHHop*) hop completionHandler:(void (^)(CHHop* hop)) handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hop/get_tasks.json?api_key=%@&hop_id=%i&authentication_token=%@", CH_API_KEY, [hop.identifier intValue], aToken];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSMutableArray* tasks = [NSMutableArray new];
        
        NSArray* json_tasks = [JSON objectForKey:@"hop_tasks"];
        if (json_tasks) {
            for (NSDictionary* objDic in json_tasks) {
                CHHopTask* newHopTask = (CHHopTask*)[self findObjectWithID:[objDic objectForKey:@"id"] inArray:hop.tasks];
                if (newHopTask == nil) {
                    newHopTask = [[CHHopTask alloc] init];
                }
                [newHopTask updateFromDictionary:objDic];
                newHopTask.hop = hop;
                [tasks addObject:newHopTask];
            }
            hop.tasks = tasks;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_HOPS_TASKS_UPDATED object:hop];
        handler(hop);
    
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(hop);
    }];
    
    [operation start];
    
}


- (void) completeHopTask:(CHHopTask*) hopTask withPhoto:(UIImage*) photo comment:(NSString*) comment completionHandler:(void (^)(BOOL success))handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/task/submit.json?api_key=%@&authentication_token=%@&hop_task_id=%i", CH_API_KEY, aToken, [hopTask.identifier intValue]];
    
    NSMutableURLRequest *request =
    [[CHAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        NSData* imgData = UIImageJPEGRepresentation(photo, 0.9);
        if (imgData != nil) {
            [formData appendPartWithFileData:imgData name:@"photo" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
        }

        [formData appendPartWithFormData:[comment dataUsingEncoding:NSUTF8StringEncoding] name:@"comment"];
    }];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self refreshHops];
        handler(YES);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(NO);
    }];
    
    [operation start];
}


- (void) loadPrizesForHopID:(NSNumber*) _id completionHandler:(void (^)(NSArray* hopPrizes)) handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hop/prizes.json?api_key=%@&hop_id=%i&authentication_token=%@", CH_API_KEY, [_id intValue], aToken];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray* prizes = [JSON objectForKey:@"prizes"];
        if (prizes) {
            handler(prizes);
        } else  {
            handler(nil);
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(nil);
    }];
    
    [operation start];
}


- (void) loadYesterdayWinnerWithCompletionHandler:(void (^)(NSDictionary* yesterdayWinnerDic)) handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hops/yesterdays_winner.json?api_key=%@&authentication_token=%@", CH_API_KEY, aToken];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([JSON objectForKey:@"winner_id"] != nil) {
            handler(JSON);
        } else  {
            handler(nil);
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(nil);
    }];
    
    [operation start];
}


- (void) notifiServerOfSharingWithService:(NSString*) serviceName andHopTaskID:(NSNumber*) hopTaskID {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/task/notify_by_share.json?api_key=%@&authentication_token=%@&hop_task_id=%i&service=%@", CH_API_KEY, aToken, [hopTaskID intValue], serviceName];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
    }];
    
    [operation start];
    
}


- (void) scoreForHopID:(NSNumber*) _id completionHandler:(void (^)(NSNumber* score, NSNumber* rank, NSNumber* hoppers_count)) handler {
    NSString* path = [NSString stringWithFormat:@"/api/hop/score.json?hop_id=%i", [_id intValue]];
    [self requestWithMethod:@"GET" urlPath:path block:^(NSError* error, NSDictionary* json){
        handler([json objectForKey:@"score"], [json objectForKey:@"rank"], [json objectForKey:@"hoppers_count"]);
    }];
}


-(void) disableHopPasswordWithHopId:(NSNumber*) hop_id withPassword:(NSString*) password {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/hop/disable_password.json?api_key=%@&authentication_token=%@&hop_id=%@&password=%@",CH_API_KEY, aToken, hop_id, password];
    
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

    }];
    
    [operation start];
}


@end
