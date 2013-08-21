//
//  CHPaymentsManager.m
//  CashHoppers
//
//  Created by Vova Musiienko on 21.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHPaymentsManager.h"

@implementation CHPaymentsManager


+ (CHPaymentsManager*) instance {
    static CHPaymentsManager* inst = nil;
    if (inst == nil) {
        inst = [[CHPaymentsManager alloc] init];
        
    }
    return inst;
}


- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}


- (void) getBalanceWithCompletionHandler:(void (^)(NSNumber* balance)) handler {
    [self requestWithMethod:@"GET" urlPath:@"/api/payment/get_frog_legs_count.json" block:^(NSError* error, NSDictionary* json){
        handler([json objectForKey:@"frog_legs_count"]);
    }];
}


- (void) refillBalanceFor:(NSNumber*)frogLegs withCompletionHandler:(void (^)(NSError* error)) handler {
    NSString* path = [NSString stringWithFormat:@"/api/payment/refill_your_account.json?frog_legs_count=%i", [frogLegs intValue]];
    [self requestWithMethod:@"POST" urlPath:path block:^(NSError* error, NSDictionary* json){
        handler(error);
    }];
}


- (void) removeAdsWithCompletionHandler:(void (^)(NSError* error)) handler {
    [self requestWithMethod:@"POST" urlPath:@"/api/payment/disable_ads.json" block:^(NSError* error, NSDictionary* json){
        handler(error);
    }];
}



@end
