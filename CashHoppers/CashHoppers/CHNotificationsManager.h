//
//  CHNotificationsManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"

#import "CHFriendInviteNotification.h"
#import "CHFriendInviteAcceptedNotification.h"
#import "CHEndOfHopNotification.h"
#import "CHCommentNotification.h"
#import "CHLikeNotification.h"


#define CH_NOTIFICATION_UPDATED @"CH_NOTIFICATION_UPDATED"


@interface CHNotificationsManager : CHBaseManager

+ (CHNotificationsManager*) instance;

- (void) loadNotificationsWithCompletionHandler:(void (^)(NSArray* notifications)) handler;

@end
