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
#import "CHStartVC.h"
#import "CHAppDelegate.h"


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
    [self.caches setObject:[@{@"objects":[NSMutableArray new], @"expiration": [NSNumber numberWithDouble:expirationTime]} mutableCopy] forKey:cacheName];
}


- (void) clearCacheWithName:(NSString*) cacheName {
    NSMutableDictionary* cache = [self.caches objectForKey:cacheName];
    if (cache == nil) {
        @throw [NSException exceptionWithName:@"CHBaseManager" reason:[NSString stringWithFormat:@"Can't clear uninitialized cache \"%@\"", cacheName] userInfo:nil];
    }
    
    [cache setObject:[NSMutableArray new] forKey:@"objects"];
}


- (CHBaseModel*) findObjectWithID:(NSNumber*) _id inCache:(NSString*) cacheName {
    NSDictionary* cache = [self.caches objectForKey:cacheName];
    if (cache == nil) {
        @throw [NSException exceptionWithName:@"CHBaseManager" reason:[NSString stringWithFormat:@"Can't fint object in uninitialized cache \"%@\"", cacheName] userInfo:nil];
    }
    CHBaseModel* obj = [self findObjectWithID:_id inArray:[cache objectForKey:@"objects"]];
    
    if (obj) {
        // expiration check
        NSDate* timePast = [[NSDate date] laterDate:obj.cacheDate];
        NSTimeInterval timeIntervalPast = [timePast timeIntervalSinceDate:obj.cacheDate];
        if (timeIntervalPast > [[cache objectForKey:@"expiration"] doubleValue] || timeIntervalPast < 0.0f) {
            [[cache objectForKey:@"objects"] removeObject:obj];
            obj = nil;
        }
    }
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
    obj.cacheDate = [NSDate date];
    
    [[cache objectForKey:@"objects"] addObject:obj];
}


- (void) removeObjectWithID:(NSNumber*) _id fromCache:(NSString*) cacheName {
    NSDictionary* cache = [self.caches objectForKey:cacheName];
    if (cache == nil) {
        @throw [NSException exceptionWithName:@"CHBaseManager" reason:[NSString stringWithFormat:@"Can't fint object in uninitialized cache \"%@\"", cacheName] userInfo:nil];
    }
    CHBaseModel* obj = [self findObjectWithID:_id inArray:[cache objectForKey:@"objects"]];
    
    if (obj) {
        [[cache objectForKey:@"objects"] removeObject:obj];
    }
}



- (void) defaultErrorHandlerForReqest:(NSURLRequest*) request responce: (NSHTTPURLResponse *)response :(NSError *)error :(id) JSON {
    NSString* errMsg = nil;
    if (JSON != nil && [JSON  objectForKey:@"info"]) {
        errMsg = [JSON  objectForKey:@"info"];
    } else {
        errMsg = [error localizedDescription];
    }
    
    NSLog(@"Can't load url: %@ \n=%@", request.URL, errMsg);
    
    if (response.statusCode == 401) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_LOGIN_EXPIRED object:self];
    }
    
//    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Can't load url: %@ \n %@", request.URL, errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [av show];
}


- (void) requestWithMethod:(NSString*) method :(NSString*)path :(void (^)(NSError* error)) handler {
    [self requestWithMethod:method urlPath:path block:^(NSError* error, NSDictionary* json) {
        handler(error);
    }];
}


- (void) requestWithMethod:(NSString*) method urlPath:(NSString*)path block:(void (^)(NSError* error, NSDictionary* json)) handler {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString* sym_prefix = @"&";
    if ([path rangeOfString:@"?"].location == NSNotFound) {
        sym_prefix = @"?";
    }
    
    NSString *full_path = [path stringByAppendingFormat:@"%@api_key=%@&authentication_token=%@", sym_prefix, CH_API_KEY, aToken];
    
    NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:method path:full_path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        handler(nil, JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self defaultErrorHandlerForReqest:request responce:response :error :JSON];
        handler(error, nil);
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
