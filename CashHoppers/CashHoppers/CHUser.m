//
//  CHUser.m
//  CashHoppers
//
//  Created by Eugene on 23.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHUser.h"

@implementation CHUser

- (void) updateFromDictionary:(NSDictionary*) dic{
    
    self.firstName = [self safeStringFrom:[dic objectForKey:@"first_name"] defaultValue:@""];
    self.lastName = [self safeStringFrom:[dic objectForKey:@"last_name"] defaultValue:@""];
    self.userID = [dic objectForKey:@"id"];
}

@end
