//
//  CHNotificationsManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHNotificationsManager.h"
#import "CHAPIClient.h"

@implementation CHNotificationsManager

+ (CHNotificationsManager*) instance {
    static CHNotificationsManager* inst = nil;
    if (inst == nil) {
        inst = [[CHNotificationsManager alloc] init];
        
    }
    return inst;
}


- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}


- (void) loadNotificationsWithCompletionHandler:(void (^)(NSArray* notifications)) handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/notifications.json?api_key=%@&authentication_token=%@&page=1&per_page=50",CH_API_KEY,aToken];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSMutableArray* resultNotifs = [NSMutableArray new];
        NSArray* notifsList = [JSON objectForKey:@"events"];
        
        if (notifsList) {
            for (NSDictionary* notifDic in notifsList) {
                enum CHNotificationType nType = [CHBaseNotification notificationTypeFromString:[notifDic objectForKey:@"event_type"]];
                CHBaseNotification* newNotif = nil;
                
                switch (nType) {
                    case CHNotificationTypeFriendInvite: {
                        newNotif = [[CHFriendInviteNotification alloc] init];
                        break;
                    }
                    case CHNotificationTypeEndOfHop: {
                        newNotif = [[CHEndOfHopNotification alloc] init];
                        break;
                    }
                    case CHNotificationTypeComment: {
                        newNotif = [[CHCommentNotification alloc] init];
                        break;
                    }
                    case CHNotificationTypeLike: {
                        newNotif = [[CHLikeNotification alloc] init];
                        break;
                    }
                    case CHNotificationTypeFriendInviteAccepted: {
                        newNotif = [[CHFriendInviteAcceptedNotification alloc] init];
                        break;
                    }
                    case CHNotificationTypeNone: {
                    }
                }
                
                [newNotif updateFromDictionary:notifDic];
                [resultNotifs addObject:newNotif];
            }
            
            handler(resultNotifs);
            
            for (CHBaseNotification* n in resultNotifs) {
                [n loadParts];
            }
            
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(@[]);
    }];
    
    [operation start];
}


@end
