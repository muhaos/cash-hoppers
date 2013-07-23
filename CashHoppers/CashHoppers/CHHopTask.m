//
//  CHHopTask.m
//  CashHoppers
//
//  Created by Vova Musiienko on 17.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHopTask.h"

@implementation CHHopTask

- (void) updateFromDictionary:(NSDictionary*) dic {
    self.identifier = [dic objectForKey:@"id"];
    self.text = [CHBaseModel safeStringFrom:[dic objectForKey:@"text"] defaultValue:@"No Description"];
}

@end
