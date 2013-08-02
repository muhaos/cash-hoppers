//
//  CHCHFriendInviteAcceptedNotification.m
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFriendInviteAcceptedNotification.h"

@implementation CHFriendInviteAcceptedNotification

- (void) updateFromDictionary:(NSDictionary*) dic {
    [super updateFromDictionary:dic];
    
    NSDictionary* friendDic = [dic objectForKey:@"friend"];
    self.friendID = [friendDic objectForKey:@"id"];
    self.userAvatarURLString = [friendDic objectForKey:@"avatar"];
    self.userName = [NSString stringWithFormat:@"%@ %@", [friendDic objectForKey:@"first_name"], [friendDic objectForKey:@"last_name"]];
}


- (NSString*) notificationDescription {
    return @"Accepted your friend invitation.";
}

@end
