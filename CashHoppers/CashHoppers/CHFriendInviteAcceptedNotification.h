//
//  CHCHFriendInviteAcceptedNotification.h
//  CashHoppers
//
//  Created by Vova Musiienko on 02.08.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHBaseNotification.h"

@interface CHFriendInviteAcceptedNotification : CHBaseNotification

@property (nonatomic, retain) NSNumber* friendID;


- (NSAttributedString*) notificationDescription;
- (void) updateFromDictionary:(NSDictionary*) dic;


@end
