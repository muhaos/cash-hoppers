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
    self.text = [self safeStringFrom:[dic objectForKey:@"text"] defaultValue:@"No Description"];
//    self.completed = [NSNumber numberWithBool:[[dic objectForKey:@"completed"] boolValue]];
    BOOL isCompleted = [[dic objectForKey:@"completed"] boolValue];
    self.completed = isCompleted?@"YES":@"NO";

}

@end
