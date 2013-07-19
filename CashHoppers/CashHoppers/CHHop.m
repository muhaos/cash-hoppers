//
//  CHHop.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHop.h"

@implementation CHHop

- (void) updateFromDictionary:(NSDictionary*) dic {
    
    self.identifier = [dic objectForKey:@"id"];
    self.name = [self safeStringFrom:[dic objectForKey:@"name"] defaultValue:@"No Name"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    self.time_start = [df dateFromString: [dic objectForKey:@"time_start"]];
    self.time_end = [df dateFromString: [dic objectForKey:@"time_end"]];
    
    self.code = [self safeStringFrom:[dic objectForKey:@"code"] defaultValue:@""];
    self.price = [self safeStringFrom:[dic objectForKey:@"price"] defaultValue:@""];
    self.jackpot = [dic objectForKey:@"jackpot"];
    self.daily_hop = [dic objectForKey:@"daily_hop"];
    self.close = [dic objectForKey:@"close"];
    self.event = [self safeStringFrom:[dic objectForKey:@"event"] defaultValue:@""];

}


@end
