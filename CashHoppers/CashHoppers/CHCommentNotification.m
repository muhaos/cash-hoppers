//
//  CHCommentNotification.m
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHCommentNotification.h"
#import "CHFriendsFeedItem.h"

@implementation CHCommentNotification

- (void) updateFromDictionary:(NSDictionary*) dic {
    [super updateFromDictionary:dic];
    
    NSDictionary* commentDic = [dic objectForKey:@"comment"];
    NSDictionary* friendDic = [commentDic objectForKey:@"user"];
    
    self.userAvatarURLString = [friendDic objectForKey:@"avatar"];
    self.userName = [NSString stringWithFormat:@"%@ %@", [friendDic objectForKey:@"first_name"], [friendDic objectForKey:@"last_name"]];

    self.user_hop_task_id = [commentDic objectForKey:@"user_hop_task_id"];
}


- (NSString*) notificationDescription {
    if (self.feedItem != nil) {
        return [NSString stringWithFormat:@"Commented on your completed HOP item\n%@", [self.feedItem completedTaskName]];
    }
    return @"Commented on your completed HOP item";
}



@end
