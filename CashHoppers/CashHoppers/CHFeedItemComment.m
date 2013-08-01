//
//  CHFeedItemComment.m
//  CashHoppers
//
//  Created by Eugene on 29.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFeedItemComment.h"

@implementation CHFeedItemComment


- (void) updateFromDictionary:(NSDictionary*) dic{

    self.user_id = [dic objectForKey:@"user_id"];
    self.text = [CHBaseModel safeStringFrom:[dic objectForKey:@"text"] defaultValue:@""];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    self.created_at = [df dateFromString: [dic objectForKey:@"created_at"]];
    
}

@end
