//
//  CHLikeNotification.m
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHLikeNotification.h"
#import "CHFriendsFeedItem.h"

@implementation CHLikeNotification

- (void) updateFromDictionary:(NSDictionary*) dic {
    [super updateFromDictionary:dic];
    
    NSDictionary* likeDic = [dic objectForKey:@"like"];
    NSDictionary* friendDic = [likeDic objectForKey:@"user"];
    
    self.userAvatarURLString = [friendDic objectForKey:@"avatar"];
    self.userName = [NSString stringWithFormat:@"%@ %@", [friendDic objectForKey:@"first_name"], [friendDic objectForKey:@"last_name"]];
    
    self.user_hop_task_id = [likeDic objectForKey:@"user_hop_task_id"];
}


- (NSString*) notificationDescription {
    if (self.feedItem != nil) {
        return [NSString stringWithFormat:@"Liked your completed HOP item\n%@", [self.feedItem completedTaskName]];
    }
    return @"Liked your completed HOP item";
}

@end
