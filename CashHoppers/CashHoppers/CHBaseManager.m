//
//  CHBaseManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"
#import "CHBaseModel.h"
#import "CHAPIClient.h"

@interface CHBaseManager ()

@property (nonatomic, strong) NSMutableDictionary* caches;

@end


@implementation CHBaseManager


- (id) init {
    if (self = [super init]) {
        self.caches = [NSMutableDictionary new];
    }
    return self;
}


- (void) initCacheWithName:(NSString*) cacheName andExpirationTime:(NSTimeInterval) expirationTime {
    [self.caches setObject:@{@"objects":[NSMutableArray new], @"expiration": [NSNumber numberWithDouble:expirationTime]} forKey:cacheName];
}


- (CHBaseModel*) findObjectWithID:(NSNumber*) _id inCache:(NSString*) cacheName {
    NSDictionary* cache = [self.caches objectForKey:cacheName];
    if (cache == nil) {
        @throw [NSException exceptionWithName:@"CHBaseManager" reason:[NSString stringWithFormat:@"Can't fint object in uninitialized cache \"%@\"", cacheName] userInfo:nil];
    }
    CHBaseModel* obj = [self findObjectWithID:_id inArray:[cache objectForKey:@"objects"]];
    // expiration check must be here
    return obj;
}


- (void) putObject:(CHBaseModel*)obj intoCache:(NSString*) cacheName {
    NSDictionary* cache = [self.caches objectForKey:cacheName];
    if (cache == nil) {
        @throw [NSException exceptionWithName:@"CHBaseManager" reason:[NSString stringWithFormat:@"Can't put object in uninitialized cache \"%@\"", cacheName] userInfo:nil];
    }
    
    // remove old version if exist
    CHBaseModel* oldObj = [self findObjectWithID:obj.identifier inArray:[cache objectForKey:@"objects"]];
    if (oldObj) {
        [[cache objectForKey:@"objects"] removeObject:oldObj];
    }
    
    // there must be set expiration timestamp
    
    [[cache objectForKey:@"objects"] addObject:obj];
}




- (void) defaultErrorHandlerForReqest:(NSURLRequest*) request responce: (NSHTTPURLResponse *)response :(NSError *)error :(id) JSON {
    NSString* errMsg = nil;
    if (JSON != nil && [JSON  objectForKey:@"info"]) {
        errMsg = [JSON  objectForKey:@"info"];
    } else {
        errMsg = [error localizedDescription];
    }
    
    NSLog(@"Can't load url: %@ \n %@", request.URL, errMsg);
//    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Can't load url: %@ \n %@", request.URL, errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [av show];
}


- (void) requestWithMethod:(NSString*) method :(NSString*)path :(void (^)(NSError* error)) handler {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *full_path = [path stringByAppendingFormat:@"&api_key=%@&authentication_token=%@", CH_API_KEY, aToken];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:method path:full_path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        handler(nil);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(error);
    }];
    
    [operation start];
}


- (CHBaseModel*) findObjectWithID:(NSNumber*)_id inArray:(NSArray*) array {
    if (_id == nil || [_id isKindOfClass:[NSNull class]]) {
        @throw [NSException exceptionWithName:@"CHBaseManager" reason:[NSString stringWithFormat:@"Object identifier musn't be nil"] userInfo:nil];
    }
    
    for (CHBaseModel* obj in array) {
        if ([_id intValue] == [obj.identifier intValue]) {
            return obj;
        }
    }
    return nil;
}

@end
