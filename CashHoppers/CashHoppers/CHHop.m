//
//  CHHop.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHop.h"
#import "CHHopTask.h"
#import "CHAPIClient.h"

@implementation CHHop

- (void) updateFromDictionary:(NSDictionary*) dic {
    
    self.identifier = [dic objectForKey:@"id"];
    self.name = [CHBaseModel safeStringFrom:[dic objectForKey:@"name"] defaultValue:@"No Name"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //2013-08-30T12:07:13Z
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    self.time_start = [CHBaseModel safeDateFrom:[dic objectForKey:@"time_start"] dateFromatter:df defaultValue:nil];
    self.time_end = [CHBaseModel safeDateFrom:[dic objectForKey:@"time_end"] dateFromatter:df defaultValue:nil];
    
    self.code = [CHBaseModel safeStringFrom:[dic objectForKey:@"code"] defaultValue:@""];
    self.price = [CHBaseModel safeNumberFrom:[dic objectForKey:@"price"] defaultValue:@0];
    self.jackpot = [CHBaseModel safeStringFrom:[dic objectForKey:@"jackpot"] defaultValue:@""];
    self.daily_hop = [dic objectForKey:@"daily"];
    self.close = [dic objectForKey:@"close"];
    self.event = [CHBaseModel safeStringFrom:[dic objectForKey:@"event"] defaultValue:@""];
    self.logoUrlString = [CHBaseModel safeStringFrom:[dic objectForKey:@"logo"] defaultValue:nil];
    self.purchased = [CHBaseModel safeNumberFrom:[dic objectForKey:@"purchased"] defaultValue:@NO];
    self.askPassword = [CHBaseModel safeNumberFrom:[dic objectForKey:@"ask_password"] defaultValue:@YES];
    self.adUrlString = [CHBaseModel safeStringFrom:[dic objectForKey:@"link"] defaultValue:nil];
        
}


- (enum CHHopType) hopType {
    if ([self isAllTasksCompleted]) {
       return CHHopTypeCompleted;
    } else if (![self.code isEqualToString:@""]) {
        return CHHopTypeWithCode;
    } else if ([self.price intValue] != 0) {
        return CHHopTypeWithEntryFee;
    } else {
        return CHHopTypeFree;
    }
}


- (BOOL) isAllTasksCompleted {
    if (self.tasks == nil || [self.tasks count] <= 0) {
        return NO;
    }
    for (CHHopTask* t in  self.tasks) {
        if ([t.completed boolValue] != YES) {
            return NO;
        }
    }
    return YES;
}



+ (BOOL) isValidHopDictionary:(NSDictionary*) dic {
    if (nil == [CHBaseModel safeNumberFrom:[dic objectForKey:@"id"] defaultValue:nil]) {
        return NO;
    }
    return YES;
}


- (NSString*) dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd"];
    NSString* startDate = [df stringFromDate:self.time_start];
    NSString* finalDate = startDate;
    if (self.time_end != nil) {
        NSString* endDate = [df stringFromDate:self.time_end];
        finalDate = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
    }
    return finalDate;
}


- (NSURL*) logoURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.logoUrlString]];
}


- (NSURL*) adURL {
    return [NSURL URLWithString:self.adUrlString];

}


@end
