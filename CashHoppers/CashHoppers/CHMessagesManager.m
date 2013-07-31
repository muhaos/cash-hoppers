//
//  CHMessagesManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHMessagesManager.h"
#import "CHAPIClient.h"


@implementation CHMessagesManager

+ (CHMessagesManager*) instance {
    static CHMessagesManager* inst = nil;
    if (inst == nil) {
        inst = [[CHMessagesManager alloc] init];
        
    }
    return inst;
}


- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}



- (void) postMessageWithText:(NSString*) text toFriendsList:(NSArray*)friendsIds completionHandler:(void (^)(NSError* error))handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/messages/send_message.json?api_key=%@&authentication_token=%@",CH_API_KEY,aToken];
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:text forKey:@"text"];
    [params setObject:friendsIds forKey:@"friends"];
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:params];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        handler(nil);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForResponce:response :error :JSON];
        handler(error);
    }];
    
    
    [operation start];
}



- (void) loadMessagesOverviewWithCompletionHandler:(void (^)(NSArray* messages)) handler {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/messages/thread.json?api_key=%@&authentication_token=%@&page=1&per_page=50",CH_API_KEY,aToken];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSMutableArray* resultMessages = [NSMutableArray new];
        NSArray* messagesList = [JSON objectForKey:@"friends"];
        
        if (messagesList) {
            for (NSDictionary* msgDic in messagesList) {
                CHMessage* newMessage = [[CHMessage alloc] init];
                [newMessage updateFromDictionary:msgDic];
                [resultMessages addObject:newMessage];
            }
            handler(resultMessages);
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForResponce:response :error :JSON];
        handler(@[]);
    }];
    
    [operation start];
}



@end
