//
//  CHMessage.m
//  CashHoppers
//
//  Created by Vova Musiienko on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHMessage.h"

@implementation CHMessage


- (void) updateFromDictionary:(NSDictionary*) dic {
    self.text = [CHBaseModel safeStringFrom:[dic objectForKey:@"text"] defaultValue:[CHBaseModel safeStringFrom:[dic objectForKey:@"last_message_text"] defaultValue:@"No message!"]];
}


@end
