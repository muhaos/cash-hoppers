//
//  CHLikeNotification.m
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHLikeNotification.h"
#import "CHFriendsFeedItem.h"
#import "CHFriendsFeedManager.h"
#import "CHNotificationsManager.h"

@implementation CHLikeNotification

- (void) updateFromDictionary:(NSDictionary*) dic {
    [super updateFromDictionary:dic];
    
    NSDictionary* likeDic = [dic objectForKey:@"like"];
    NSDictionary* friendDic = [likeDic objectForKey:@"user"];
    
    self.userAvatarURLString = [CHBaseModel safeStringFrom:[friendDic objectForKey:@"avatar"] defaultValue:nil] ;
    self.userName = [NSString stringWithFormat:@"%@ %@", [friendDic objectForKey:@"first_name"], [friendDic objectForKey:@"last_name"]];
    
    self.user_hop_task_id = [likeDic objectForKey:@"user_hop_task_id"];
}


- (NSAttributedString*) notificationDescription {
    if (self.feedItem != nil) {
        NSString* msg = [NSString stringWithFormat:@"Liked your completed HOP item\n%@", [self.feedItem completedTaskName]];
        return [self attributedString:msg withBoldString:[self.feedItem completedTaskName]];
    }
    return [self attributedString:@"Liked your completed HOP item" withBoldString:nil];
}


- (void) loadParts {
        
    [[CHFriendsFeedManager instance] loadFeedItemWithID:self.user_hop_task_id completionHandler:^(CHFriendsFeedItem* feedItem){
        
        self.feedItem = feedItem;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CH_NOTIFICATION_UPDATED object:self];
    }];
    
}


@end
