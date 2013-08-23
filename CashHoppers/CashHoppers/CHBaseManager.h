//
//  CHBaseManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHBaseModel;

@interface CHBaseManager : NSObject

- (void) defaultErrorHandlerForReqest:(NSURLRequest*) request responce: (NSHTTPURLResponse *)response :(NSError *)error :(id) JSON;

// api key and auth token will be appeded to the path
- (void) requestWithMethod:(NSString*) method :(NSString*)path :(void (^)(NSError* error)) handler;

- (void) requestWithMethod:(NSString*) method urlPath:(NSString*)path block:(void (^)(NSError* error, NSDictionary* json)) handler;

- (CHBaseModel*) findObjectWithID:(NSNumber*)_id inArray:(NSArray*) array;

// caching

- (void) initCacheWithName:(NSString*) cacheName andExpirationTime:(NSTimeInterval) expirationTime;
- (CHBaseModel*) findObjectWithID:(NSNumber*) _id inCache:(NSString*) cacheName;
- (void) putObject:(CHBaseModel*)obj intoCache:(NSString*) cacheName;
- (void) removeObjectWithID:(NSNumber*) _id fromCache:(NSString*) cacheName;



@end
