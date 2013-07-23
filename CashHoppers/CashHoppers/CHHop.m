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
    self.name = [CHBaseModel safeStringFrom:[dic objectForKey:@"name"] defaultValue:@"No Name"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    self.time_start = [CHBaseModel safeDateFrom:[dic objectForKey:@"time_start"] dateFromatter:df defaultValue:nil];
    self.time_end = [CHBaseModel safeDateFrom:[dic objectForKey:@"time_end"] dateFromatter:df defaultValue:nil];
    
    self.code = [CHBaseModel safeStringFrom:[dic objectForKey:@"code"] defaultValue:@""];
    self.price = [CHBaseModel safeStringFrom:[dic objectForKey:@"price"] defaultValue:@""];
    self.jackpot = [CHBaseModel safeNumberFrom:[dic objectForKey:@"jackpot"] defaultValue:@0];
    self.daily_hop = [dic objectForKey:@"daily_hop"];
    self.close = [dic objectForKey:@"close"];
    self.event = [CHBaseModel safeStringFrom:[dic objectForKey:@"event"] defaultValue:@""];

}


- (enum CHHopType) hopType {
    if ([self.close boolValue]) {
       return CHHopTypeCompleted;
    } else if (![self.code isEqualToString:@""]) {
        return CHHopTypeWithCode;
    } else if (![self.price isEqualToString:@""] && [self.price intValue] != 0) {
        return CHHopTypeWithEntryFee;
    } else {
        return CHHopTypeFree;
    }
}


+ (BOOL) isValidHopDictionary:(NSDictionary*) dic {
    if (nil == [CHBaseModel safeNumberFrom:[dic objectForKey:@"id"] defaultValue:nil]) {
        return NO;
    }
    return YES;
}


@end
