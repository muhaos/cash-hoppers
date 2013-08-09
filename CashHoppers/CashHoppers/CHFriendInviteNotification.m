//
//  CHFriendInviteNotification.m
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFriendInviteNotification.h"

@implementation CHFriendInviteNotification


- (void) updateFromDictionary:(NSDictionary*) dic {
    [super updateFromDictionary:dic];
    
    NSDictionary* friendDic = [dic objectForKey:@"friend"];
    self.friendID = [friendDic objectForKey:@"id"];
    self.userAvatarURLString = [CHBaseModel safeStringFrom:[friendDic objectForKey:@"avatar"] defaultValue:nil] ;
    self.userName = [NSString stringWithFormat:@"%@ %@", [friendDic objectForKey:@"first_name"], [friendDic objectForKey:@"last_name"]];
    self.friends_status = [CHBaseModel safeStringFrom:[friendDic objectForKey:@"friendship_status"] defaultValue:nil];
}


- (NSAttributedString*) notificationDescription {
    NSString* s = @"Invited you to be friends. ";
    if ([self.friends_status isEqualToString:@"accepted"]) {
        s = [s stringByAppendingString:@"You accepted the invitation."];
    }
    if (self.friends_status == nil) {
        s = [s stringByAppendingString:@"Invitation declined."];
    }
    
    return [self attributedString:s withBoldString:nil];
}


@end
