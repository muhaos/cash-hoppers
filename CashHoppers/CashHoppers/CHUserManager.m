//
//  CHUserManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 26.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHUserManager.h"
#import "CHAPIClient.h"

@implementation CHUserManager

+ (CHUserManager*) instance {
    static CHUserManager* inst = nil;
    if (inst == nil) {
        inst = [[CHUserManager alloc] init];
        
    }
    return inst;
}


- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}


- (void) updateCurrentUser {
    
    [self loadUserForID:nil completionHandler:^(CHUser* user) {
        _currentUser = user;
    }];

}



- (void) loadUserForID:(NSNumber*) _id completionHandler:(void (^)(CHUser* user)) handler {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = nil;
    if (_id != nil) {
        path = [NSString stringWithFormat:@"/api/users/get_user_info.json?api_key=%@&authentication_token=%@",CH_API_KEY,aToken];
        path = [path stringByAppendingFormat:@"&user_id=%i", [_id intValue]];
    } else {
        path = [NSString stringWithFormat:@"/api/users/get_my_info.json?api_key=%@&authentication_token=%@",CH_API_KEY,aToken];
    }
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* userDic = [JSON objectForKey:@"user"];
        if (userDic) {
            CHUser* newUser = [[CHUser alloc] init];
            [newUser updateFromDictionary:userDic];
            handler(newUser);
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(nil);
    }];
    
    [operation start];
}


- (void) updateUserProfileWithUser:(CHUser*) user newPassword:(NSString*)password newAvatar:(UIImage*)avatar completionHandler:(void (^)(NSError* error)) handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/users/update_profile.json?api_key=%@&authentication_token=%@", CH_API_KEY, aToken];
    
    NSMutableURLRequest *request =
    [[CHAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        if (avatar != nil) {
            NSData* imgData = UIImageJPEGRepresentation(avatar, 0.9);
            if (imgData != nil) {
                [formData appendPartWithFileData:imgData name:@"avatar" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
            }
        }
        
        [user fillForm:formData];
        
        if (password != nil) {
            [formData appendPartWithFormData:[password dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        }
    }];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        handler(nil);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(error);
    }];
    
    [operation start];

}


- (void) loadFriendsWithCompletionHandler:(void (^)(NSArray* friends)) handler {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/friends/get_friends.json?api_key=%@&authentication_token=%@",CH_API_KEY,aToken];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray* friendsArray = [JSON objectForKey:@"friends"];
        if (friendsArray) {
            
            NSMutableArray* result = [NSMutableArray new];
            int __block completedUserRequests = 0;
            int idsCount = [friendsArray count];
            
            for (NSNumber* friendID in friendsArray) {
                [self loadUserForID:friendID completionHandler:^(CHUser* user) {
                    if (user != nil) {
                        [result addObject:user];
                    }
                    completedUserRequests ++;
                    if (completedUserRequests == idsCount) {
                        handler(result);
                    }
                }];
            }
            
        }
    
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(nil);
    
    }];
    
    [operation start];
}


- (void) searchUsersWithQuery:(NSString*) searchStr andCompletionHandler:(void (^)(NSArray* users)) handler {

    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"/api/users/get_users.json?api_key=%@&authentication_token=%@&query=%@",CH_API_KEY, aToken, [searchStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray* usersArray = [JSON objectForKey:@"users"];
        if (usersArray) {
            NSMutableArray* result = [NSMutableArray new];
            for (NSDictionary* userDic in usersArray) {
                CHUser* newUser = [[CHUser alloc] init];
                [newUser updateFromDictionary:userDic];
                [result addObject:newUser];
            }
            handler(result);
        }
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(nil);
    }];
    
    [operation start];
}


- (void) sendFriendInvitationToUser:(CHUser*) user withCompletionHandler:(void (^)(NSError* error)) handler {
    
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSDecimalNumber *identifier = [NSDecimalNumber decimalNumberWithString:[user.identifier stringValue]];
    NSString *path = [NSString stringWithFormat:@"api/friends/send_request.json?api_key=%@&authentication_token=%@&friend_id=%@",CH_API_KEY, aToken, identifier];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
    
    NSLog(@"REQUEST TO : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray* resultArray = [JSON objectForKey:@"status"];
        handler(resultArray);
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(error);
    }];
    
    [operation start];
}


@end
