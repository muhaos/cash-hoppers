//
//  CHNotificationsManager.h
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseManager.h"

#import "CHFriendInviteNotification.h"
#import "CHCommentNotification.h"
#import "CHLikeNotification.h"
#import "CHMessageNotification.h"
#import "CHNewHopNotification.h"
#import "CHHopAboutToEndNotification.h"


#define CH_NOTIFICATION_UPDATED @"CH_NOTIFICATION_UPDATED"


@interface CHNotificationsManager : CHBaseManager

+ (CHNotificationsManager*) instance;

- (void) loadNotificationsWithCompletionHandler:(void (^)(NSArray* notifications)) handler;

@end
