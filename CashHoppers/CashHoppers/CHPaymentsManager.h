//
//  CHPaymentsManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 21.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"

@interface CHPaymentsManager : CHBaseManager

+ (CHPaymentsManager*) instance;


// if balance == nil something went wrong
- (void) getBalanceWithCompletionHandler:(void (^)(NSNumber* balance)) handler;

// TODO: need add logic if user buy currency but server is down?
- (void) refillBalanceFor:(NSNumber*)frogLegs withCompletionHandler:(void (^)(NSError* error)) handler;

- (void) removeAdsWithCompletionHandler:(void (^)(NSError* error)) handler;


@end
