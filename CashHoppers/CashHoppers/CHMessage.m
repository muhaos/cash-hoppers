//
//  CHMessage.m
//  CashHoppers
//
//  Created by Vova Musiienko on 31.07.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHMessage.h"
#import "CHAPIClient.h"

@implementation CHMessage


- (void) updateFromDictionary:(NSDictionary*) dic {
    self.text = [CHBaseModel safeStringFrom:[dic objectForKey:@"text"] defaultValue:[CHBaseModel safeStringFrom:[dic objectForKey:@"last_message_text"] defaultValue:@"No message!"]];
    
    self.friend_id = [CHBaseModel safeNumberFrom:[dic objectForKey:@"friend_id"] defaultValue:nil];
    self.friend_avatar = [CHBaseModel safeStringFrom:[dic objectForKey:@"friend_avatar"] defaultValue:@""];
    self.friend_first_name = [CHBaseModel safeStringFrom:[dic objectForKey:@"friend_first_name"] defaultValue:@"No First Name"];
    self.friend_last_name = [CHBaseModel safeStringFrom:[dic objectForKey:@"friend_last_name"] defaultValue:@"No Last Name"];
    self.friend_user_name = [CHBaseModel safeStringFrom:[dic objectForKey:@"friend_user_name"] defaultValue:@"No Username"];
}


- (NSURL*) friendAvatarURL {
    return [NSURL URLWithString:[[CHAPIClient sharedClient].baseURL.absoluteString stringByAppendingPathComponent:self.friend_avatar]];
}


@end
