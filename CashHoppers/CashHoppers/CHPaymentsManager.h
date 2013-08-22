//
//  CHPaymentsManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 21.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"

#define kProductRibbitsTier1    @"com.bigloretta.cashhoppers.inapp.ribbits.1"
#define kProductRibbitsTier2    @"com.bigloretta.cashhoppers.inapp.ribbits.2"
#define kProductRibbitsTier3    @"com.bigloretta.cashhoppers.inapp.ribbits.3"


@interface CHPaymentsManager : CHBaseManager

+ (CHPaymentsManager*) instance;


// if balance == nil something went wrong
- (void) getBalanceWithCompletionHandler:(void (^)(NSNumber* balance)) handler;

// TODO: need add logic if user buy currency but server is down?
- (void) refillBalanceFor:(NSNumber*)frogLegs withCompletionHandler:(void (^)(NSError* error)) handler;

- (void) removeAdsWithCompletionHandler:(void (^)(NSError* error)) handler;


@end
