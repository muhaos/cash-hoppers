//
//  CHLikeNotification.h
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseNotification.h"

@class CHFriendsFeedItem;

@interface CHLikeNotification : CHBaseNotification

@property (nonatomic, retain) NSNumber* user_hop_task_id;
@property (nonatomic, retain) CHFriendsFeedItem* feedItem;

- (void) updateFromDictionary:(NSDictionary*) dic;
- (NSString*) notificationDescription;
- (void) loadParts;

@end
