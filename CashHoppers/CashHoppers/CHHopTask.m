//
//  CHHopTask.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHopTask.h"
#import "CHAPIClient.h"

@implementation CHHopTask

- (void) updateFromDictionary:(NSDictionary*) dic {
    self.identifier = [dic objectForKey:@"id"];
    self.text = [CHBaseModel safeStringFrom:[dic objectForKey:@"text"] defaultValue:@"No Description"];
    self.completed = [CHBaseModel safeNumberFrom:[dic objectForKey:@"completed"] defaultValue:@0];
    self.logoUrlString = [CHBaseModel safeStringFrom:[dic objectForKey:@"logo"] defaultValue:nil];
}


- (NSURL*) logoURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.logoUrlString]];
}


@end
